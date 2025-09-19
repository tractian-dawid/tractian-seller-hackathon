import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:tractian_seller/models/asset.dart';
import 'package:tractian_seller/services/tractian_api_service.dart';

class AiAssetService {
  final Dio _dio = Dio();
  final TractianApiService _tractianApiService = TractianApiService();

  // URL do seu backend próprio (fallback)
  static const String _backendApiUrl =
      'https://api.seu-backend.com/ai/analyze-asset';
  static const String _apiKey =
      'your-backend-api-key'; // Substitua pela sua chave

  /// Encontra assets similares baseado em uma imagem
  Future<List<Asset>> findSimilarAssets(Uint8List imageBytes) async {
    try {
      // Primeiro, tentar usar a API da Tractian
      try {
        return await _tractianApiService.analyzeImage(imageBytes);
      } catch (e) {
        print('Erro na API da Tractian: $e');
        // Continuar para fallback
      }

      // Fallback: tentar backend próprio
      final String base64Image = base64Encode(imageBytes);

      final response = await _dio.post(
        _backendApiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'image': base64Image,
          'image_format': 'jpeg',
          'analysis_type': 'industrial_asset',
          'return_similar': true,
          'max_results': 5,
        },
      );

      // Processar resposta do backend próprio
      final responseData = response.data;

      if (responseData['success'] == true) {
        final analysisResult = responseData['data'];
        return _convertBackendResponseToAssets(analysisResult);
      } else {
        throw Exception('Backend returned error: ${responseData['message']}');
      }
    } catch (e) {
      // Error calling backend services
      print('Erro em todos os serviços de análise: $e');
      throw Exception('Não foi possível analisar a imagem: $e');
    }
  }

  /// Converte a resposta do backend em uma lista de Assets
  List<Asset> _convertBackendResponseToAssets(
      Map<String, dynamic> backendData) {
    final List<Asset> assets = [];

    try {
      // Processar asset identificado principal
      final identifiedAsset = backendData['identified_asset'];
      if (identifiedAsset != null) {
        final mainAsset = Asset(
          id: DateTime.now().millisecondsSinceEpoch,
          name: identifiedAsset['name'] ?? 'Asset Identificado por IA',
          image: identifiedAsset['image'] ??
              'https://example.com/images/identified-asset.jpg',
          sensornumber: (identifiedAsset['recommended_sensors'] ?? 2).toInt(),
          isSelected: false,
        );
        assets.add(mainAsset);
      }

      // Processar assets similares encontrados
      final similarAssets = backendData['similar_assets'] as List?;
      if (similarAssets != null) {
        for (final assetData in similarAssets) {
          final asset = Asset(
            id: DateTime.now().millisecondsSinceEpoch + assets.length,
            name: assetData['name'] ?? 'Asset Similar',
            image: assetData['image'] ??
                'https://example.com/images/similar-asset.jpg',
            sensornumber: (assetData['recommended_sensors'] ?? 2).toInt(),
            isSelected: false,
          );
          assets.add(asset);
        }
      }

      // Se não encontrou nenhum asset, criar um baseado na análise básica
      if (assets.isEmpty) {
        final basicAnalysis = backendData['basic_analysis'];
        final fallbackAsset = Asset(
          id: DateTime.now().millisecondsSinceEpoch,
          name: basicAnalysis?['detected_type'] ?? 'Equipamento Industrial',
          image: 'https://example.com/images/fallback-asset.jpg',
          sensornumber: 2,
          isSelected: false,
        );
        assets.add(fallbackAsset);
      }
    } catch (e) {
      // Error converting backend response
      print('Erro ao processar resposta do backend: $e');
      throw Exception('Erro ao processar resposta da análise: $e');
    }

    return assets;
  }

  /// Busca assets por texto (para complementar a busca por imagem)
  Future<List<Asset>> searchAssetsByText(String searchQuery) async {
    try {
      // Usar a API da Tractian para buscar assets
      final allAssets = await _tractianApiService.getAssets();

      return allAssets.where((asset) {
        return asset.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    } catch (e) {
      // Error searching assets by text
      print('Erro na busca textual: $e');
      throw Exception('Erro ao buscar assets por texto: $e');
    }
  }
}
