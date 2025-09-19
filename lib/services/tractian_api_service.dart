import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tractian_seller/models/asset.dart';

class TractianApiService {
  final Dio _dio = Dio();

  // Base URL da API Tractian
  static const String _baseUrl = 'https://twt4-backend.int.tractian.dev';

  TractianApiService() {
    // Configurar Dio com a base URL
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  /// Recupera todos os assets disponíveis
  Future<List<Asset>> getAssets() async {
    try {
      final response = await _dio.get('/assets');

      if (response.statusCode == 200) {
        final List<dynamic> assetsJson = response.data;
        return assetsJson.map((json) => Asset.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar assets: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao recuperar assets: $e');
      final list = [
        {
          "id": 1,
          "name": "Electric Motor",
          "image":
              "https://hvhindustrial.com/images/frontend_images/blogs/1586962774Elektrim-Electric-Motor-20MFM_600px_wbgrd.jpg",
          "sensorNumber": 1
        },
        {
          "id": 2,
          "name": "Reducer",
          "image":
              "https://bozzi.com.br/wp-content/uploads/2020/02/REDUTOR-MAGMA-K.jpg",
          "sensorNumber": 1
        },
        {
          "id": 3,
          "name": "Air Compressor",
          "image": "https://img.uline.com/is/image/uline/H-10916?\$ZoomHD\$",
          "sensorNumber": 1
        },
        {
          "id": 4,
          "name": "Ball Bearing",
          "image":
              "https://res.cloudinary.com/rsc/image/upload/b_rgb:FFFFFF,c_pad,dpr_1.0,f_auto,q_auto,w_700/c_pad,w_700/F2867669-01",
          "sensorNumber": 1
        },
        {
          "id": 5,
          "name": "Vane Pump",
          "image":
              "https://www.andersonprocess.com/wp-content/uploads/2022/06/blackmer-magnes-slidingvane-pump_2-LR.png",
          "sensorNumber": 1
        },
        {
          "id": 7,
          "name": "Blowers",
          "image":
              "https://beckerpumps.com/wp-content/uploads/2022/09/Becker-Single-Stage-Regen.png",
          "sensorNumber": 1
        },
        {
          "id": 8,
          "name": "Pumps",
          "image":
              "https://www.processindustryforum.com/wp-content/uploads/2014/03/Centrifugal-pumps.jpg",
          "sensorNumber": 2
        },
        {
          "id": 9,
          "name": "Fans",
          "image":
              "https://mobileimages.lowes.com/productimages/696f2c1f-8c4f-4b45-9000-2b45ef366a1f/63180555.jpg",
          "sensorNumber": 1
        },
        {
          "id": 10,
          "name": "Hydraulic Pump",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSid8cQqtdlbiB23tlWGVkluQT8CMJ8ZZIsfw&s",
          "sensorNumber": 1
        },
        {
          "id": 11,
          "name": "Hydraulic Motor",
          "image":
              "https://panagonsystems.com/wp-content/uploads/2022/03/Blog-930x470-10.jpg",
          "sensorNumber": 1
        },
        {
          "id": 12,
          "name": "Hydraulic Cylinder",
          "image":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg0F2AITupU63srUug2zVBPvr3TVnW19oD4Q&s",
          "sensorNumber": 1
        },
        {
          "id": 13,
          "name": "Hydraulic Valve",
          "image":
              "https://www.mobilehydraulictips.com/wp-content/uploads/2015/07/Hydraulic-valve-for-description-article.jpg",
          "sensorNumber": 1
        },
        {
          "id": 14,
          "name": "Hydraulic Filter",
          "image":
              "https://cdn.prod.website-files.com/617bfbfccfd67c8d5ae89950/66b4cf38edcf0a59940dacc3_649e981621b9dedf99d87ef9_filter%2520hydraulic.jpeg",
          "sensorNumber": 1
        }
      ];
      return list.map((json) => Asset.fromJson(json)).toList();
    }
  }

  /// Envia imagem para análise e retorna assets identificados
  Future<List<Asset>> analyzeImage(Uint8List imageBytes) async {
    try {
      // Cria FormData com a imagem
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.post(
        '/image',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Processar resposta da API
        final responseData = response.data;
        return _parseImageAnalysisResponse(responseData);
      } else {
        throw Exception('Erro na análise da imagem: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao analisar imagem: $e');
      throw Exception('Erro ao analisar imagem: $e');
    }
  }

  /// Calcula o número de sensores necessários
  Future<Map<String, dynamic>> calculateSensorNumber(
    List<Map<String, dynamic>> assetData,
  ) async {
    try {
      final requestBody = {
        "data": assetData,
      };

      final response = await _dio.post(
        '/calculate-sensor-number',
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Erro no cálculo de sensores: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao calcular número de sensores: $e');
      throw Exception('Erro ao calcular número de sensores: $e');
    }
  }

  /// Processa a resposta da análise de imagem
  List<Asset> _parseImageAnalysisResponse(dynamic responseData) {
    try {
      if (responseData is List) {
        return responseData.map((json) => Asset.fromJson(json)).toList();
      } else if (responseData is Map<String, dynamic>) {
        return [
          Asset.fromJson(
            {
              ...responseData['asset'],
              'isSelected': true,
              'quantity': 1,
            },
          )
        ];
      }

      return [];
    } catch (e) {
      print('Erro ao processar resposta da análise de imagem: $e');
      return [];
    }
  }
}
