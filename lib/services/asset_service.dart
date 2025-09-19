import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:tractian_seller/models/asset.dart';
import 'package:tractian_seller/services/tractian_api_service.dart';

class AssetService {
  late final Dio _dio;
  final TractianApiService _tractianApiService = TractianApiService();
  static const String _baseUrl = 'https://api.tractian.com'; // URL base da API

  AssetService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor para logs (apenas em desenvolvimento)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ),
    );
  }

  /// Busca todos os ativos disponíveis
  Future<List<Asset>> getAssets() async {
    try {
      // Tentar usar a API da Tractian primeiro
      try {
        return await _tractianApiService.getAssets();
      } catch (e) {
        print('Erro ao buscar assets da API Tractian: $e');
        throw Exception('Erro ao buscar assets: $e');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erro inesperado ao buscar ativos: $e');
    }
  }

  /// Calcula a quantidade recomendada de sensores para uma lista de ativos
  Future<SensorRecommendation> calculateRecommendedSensors(
      List<Asset> selectedAssets) async {
    try {
      // Preparar dados para envio para a API da Tractian
      final List<Map<String, dynamic>> assetData = selectedAssets
          .where((asset) => asset.isSelected && asset.quantity > 0)
          .map((asset) => {
                'id': asset.id,
                'quantity': asset.quantity,
              })
          .toList();

      // Tentar usar a API da Tractian primeiro
      try {
        final apiResponse =
            await _tractianApiService.calculateSensorNumber(assetData);

        return SensorRecommendation(
          recommendedSensors: apiResponse['sensorNumber'] ?? 0,
          calculatedSensors: apiResponse['sensorNumber'] ?? 0,
        );
      } catch (e) {
        print('Erro ao calcular sensores via API Tractian: $e');
        // Em caso de erro, usar cálculo local
      }

      // Se a API da Tractian falhou, não há fallback
      throw Exception('Não foi possível calcular o número de sensores');
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erro inesperado ao calcular sensores: $e');
    }
  }

  /// Identifica ativo por imagem usando IA
  Future<List<Asset>> identifyAssetByImage(Uint8List imageBytes) async {
    try {
      // Usar o TractianApiService para análise de imagem
      return await _tractianApiService.analyzeImage(imageBytes);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Erro inesperado ao identificar ativo: $e');
    }
  }

  /// Trata erros do Dio e retorna mensagens mais amigáveis
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Tempo limite de conexão excedido');
      case DioExceptionType.receiveTimeout:
        return Exception('Tempo limite para receber dados excedido');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Erro no servidor';
        return Exception('Erro $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Requisição cancelada');
      case DioExceptionType.unknown:
        return Exception('Erro de conexão. Verifique sua internet.');
      default:
        return Exception('Erro inesperado: ${e.message}');
    }
  }
}

/// Classe para representar a recomendação de sensores
class SensorRecommendation {
  final int recommendedSensors;
  final int calculatedSensors;

  SensorRecommendation({
    required this.recommendedSensors,
    required this.calculatedSensors,
  });

  factory SensorRecommendation.fromJson(Map<String, dynamic> json) {
    return SensorRecommendation(
      recommendedSensors: json['recommendedSensors'] ?? 0,
      calculatedSensors: json['calculatedSensors'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendedSensors': recommendedSensors,
      'calculatedSensors': calculatedSensors,
    };
  }
}
