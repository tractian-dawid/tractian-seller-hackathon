import 'dart:html' as html;

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tractian_seller/models/asset.dart';
import 'package:tractian_seller/routes/app_routes.dart';
import 'package:tractian_seller/services/tractian_api_service.dart';

class AiCameraScreen extends StatefulWidget {
  const AiCameraScreen({super.key});

  @override
  State<AiCameraScreen> createState() => _AiCameraScreenState();
}

class _AiCameraScreenState extends State<AiCameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String? _capturedImagePath;
  final TractianApiService _tractianApiService = TractianApiService();
  bool _hasPermission = false;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Primeiro, verificar/solicitar permissões
    await _requestCameraPermission();

    if (!_hasPermission) {
      return; // Não continuar se não tiver permissão
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.firstWhereOrNull((camera) =>
                  camera.lensDirection == CameraLensDirection.back) ??
              _cameras.first,
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } else {
        if (mounted) {
          _showErrorDialog('Nenhuma câmera disponível no dispositivo.');
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        String errorMessage;
        if (kIsWeb) {
          errorMessage = '$e';
        } else {
          errorMessage = 'Erro ao inicializar câmera: $e';
        }
        _showErrorDialog(errorMessage);
      }
    }
  }

  Future<void> _requestCameraPermission() async {
    if (mounted) {
      setState(() {
        _isRequestingPermission = true;
      });
    }

    try {
      // Usar a API nativa do navegador para solicitar permissões
      try {
        // Tentar acessar getUserMedia diretamente para solicitar permissão
        final mediaDevices = await html.window.navigator.getUserMedia(
          video: true,
          audio: false,
        );

        // Se chegou até aqui, temos permissão
        _hasPermission = true;

        // Parar o stream pois só queríamos verificar a permissão
        mediaDevices.getTracks().forEach((track) => track.stop());
      } catch (e) {
        debugPrint('Web camera permission error: $e');
        _hasPermission = false;
      }
    } catch (e) {
      debugPrint('Error requesting camera permission: $e');
      _hasPermission = false;
    }

    if (mounted) {
      setState(() {
        _isRequestingPermission = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      setState(() {
        _capturedImagePath = image.path;
      });

      // Processar imagem com AI
      await _processImageWithAI(image.path);
    } catch (e) {
      debugPrint('Error taking picture: $e');
      AppRoutes.goBack(context, []);
      _showErrorDialog('Error capturing image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processImageWithAI(String imagePath) async {
    try {
      Uint8List imageBytes;

      // Compatibilidade web - usar XFile para obter bytes da imagem
      final XFile imageFile = XFile(imagePath);
      imageBytes = await imageFile.readAsBytes();

      // Chamar serviço de AI para encontrar assets similares
      final List<Asset> similarAssets =
          await _tractianApiService.analyzeImage(imageBytes);

      if (mounted) {
        AppRoutes.goBack(context, similarAssets);
      }
    } catch (e) {
      debugPrint('Error processing image with AI: $e');
      AppRoutes.goBack(context, []);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _retakePicture() {
    setState(() {
      _capturedImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 768;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview ou Imagem Capturada
          if (_capturedImagePath != null)
            _buildCapturedImageView()
          else if (_isCameraInitialized)
            _buildCameraPreview()
          else
            _buildLoadingView(),

          // Overlay UI
          _buildOverlayUI(isDesktop),

          // Loading overlay
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return SizedBox.expand(
      child: CameraPreview(_cameraController!),
    );
  }

  Widget _buildCapturedImageView() {
    return SizedBox.expand(
      child: kIsWeb
          ? Image.network(
              _capturedImagePath!,
              fit: BoxFit.cover,
            )
          : Image.network(
              _capturedImagePath!,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildLoadingView() {
    String message;
    Widget icon;
    List<Widget> actions = [];

    if (_isRequestingPermission) {
      message = kIsWeb
          ? 'Requesting access to webcam...\nClick "Allow" when the browser requests.'
          : 'Requesting camera permission...';
      icon = const CircularProgressIndicator(color: Colors.white);
    } else if (!_hasPermission) {
      message =
          kIsWeb ? 'Access to webcam required' : 'camera permission required';
      icon = const Icon(Icons.camera_alt_outlined,
          size: 64, color: Colors.white70);
      actions = [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _requestCameraPermission(),
              icon: const Icon(Icons.camera_alt),
              label: Text(kIsWeb ? 'Allow Webcam' : 'Allow Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => AppRoutes.goBack(context, []),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ];
    } else {
      message = 'Initializing camera...';
      icon = const CircularProgressIndicator(color: Colors.white);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            ...actions,
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayUI(bool isDesktop) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          _buildHeader(),

          const Spacer(),

          // Instructions
          if (_capturedImagePath == null) _buildInstructions(isDesktop),

          const SizedBox(height: 32),

          // Controls
          _buildControls(isDesktop),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => AppRoutes.goBack(context),
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
          ),
          const Expanded(
            child: Text(
              'Search Asset with AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 44), // Para balancear o botão de fechar
        ],
      ),
    );
  }

  Widget _buildInstructions(bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            color: Color(0xFF2563EB),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Position the asset in the center of the screen',
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 18 : 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure the asset is well lit and in focus for better results.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isDesktop ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildControls(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_capturedImagePath != null) ...[
            // Botão Refazer
            _buildControlButton(
              icon: Icons.refresh,
              label: 'Retake',
              onTap: _retakePicture,
              isSecondary: true,
            ),
            const SizedBox(width: 32),
            // Botão Confirmar
            _buildControlButton(
              icon: Icons.check,
              label: 'Analyze',
              onTap: () => _processImageWithAI(_capturedImagePath!),
              isSecondary: false,
            ),
          ] else ...[
            // Botão Capturar
            GestureDetector(
              onTap: _isCameraInitialized ? _takePicture : null,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF2563EB),
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: const Color(0xFF2563EB),
                  size: isDesktop ? 32 : 28,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isSecondary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSecondary
              ? Colors.white.withOpacity(0.2)
              : const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(24),
          border: isSecondary
              ? Border.all(color: Colors.white.withOpacity(0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF2563EB)),
            SizedBox(height: 24),
            Text(
              'Analyzing image with AI...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This may take a few seconds',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
