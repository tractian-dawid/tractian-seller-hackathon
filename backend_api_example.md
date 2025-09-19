# API Backend para Análise de Assets por IA

## Endpoint
`POST https://api.seu-backend.com/ai/analyze-asset`

## Headers
```
Authorization: Bearer your-backend-api-key
Content-Type: application/json
```

## Request Body
```json
{
  "image": "base64_encoded_image_string",
  "image_format": "jpeg",
  "analysis_type": "industrial_asset",
  "return_similar": true,
  "max_results": 5
}
```

## Response Success (200)
```json
{
  "success": true,
  "data": {
    "confidence": 0.85,
    "processing_time_ms": 1250,
    "identified_asset": {
      "name": "Motor Elétrico Industrial",
      "model": "W22 75HP",
      "manufacturer": "WEG",
      "type": "electricMotor",
      "recommended_sensors": 2,
      "confidence": 0.92
    },
    "similar_assets": [
      {
        "name": "Motor ABB M3BP",
        "model": "M3BP 75HP",
        "manufacturer": "ABB",
        "type": "electricMotor",
        "recommended_sensors": 2,
        "similarity_score": 0.88
      },
      {
        "name": "Motor Siemens 1LE1",
        "model": "1LE1 75HP",
        "manufacturer": "Siemens",
        "type": "electricMotor",
        "recommended_sensors": 2,
        "similarity_score": 0.82
      }
    ],
    "basic_analysis": {
      "detected_type": "Motor Elétrico",
      "category": "electricMotor",
      "dominant_colors": ["gray", "black", "metallic"],
      "estimated_size": "large",
      "industrial_context": true
    }
  }
}
```

## Response Error (400/500)
```json
{
  "success": false,
  "error": {
    "code": "ANALYSIS_FAILED",
    "message": "Unable to analyze the provided image",
    "details": "Image quality too low or format not supported"
  }
}
```

## Tipos de Assets Suportados
- `electricMotor` - Motor Elétrico
- `pump` - Bomba
- `compressor` - Compressor
- `servomotor` - Servomotor
- `fan` - Ventilador
- `generator` - Gerador
- `turbine` - Turbina
- `other` - Outros equipamentos

## Notas de Implementação
1. A imagem deve ser enviada em base64
2. Formatos suportados: JPEG, PNG
3. Tamanho máximo recomendado: 5MB
4. O campo `recommended_sensors` indica quantos sensores são recomendados por unidade
5. O `similarity_score` vai de 0.0 a 1.0 (quanto maior, mais similar)
