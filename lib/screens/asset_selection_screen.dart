import 'package:flutter/material.dart';
import 'package:tractian_seller/models/asset.dart';
import 'package:tractian_seller/services/asset_service.dart';

import '../routes/routes.dart';
import 'home_screen.dart';

class AssetSelectionScreen extends StatefulWidget {
  const AssetSelectionScreen({super.key});

  @override
  State<AssetSelectionScreen> createState() => _AssetSelectionScreenState();
}

class _AssetSelectionScreenState extends State<AssetSelectionScreen> {
  final AssetService _assetService = AssetService();
  final TextEditingController _searchController = TextEditingController();

  List<Asset> _assets = [];
  List<Asset> _filteredAssets = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedAssetsCount = 0;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _loadAssets();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterAssets();
    });
  }

  void _filterAssets() {
    if (_searchQuery.isEmpty) {
      _filteredAssets = _assets;
    } else {
      // Otimização: usar toLowerCase apenas uma vez
      final searchLower = _searchQuery.toLowerCase();
      _filteredAssets = _assets
          .where((asset) => asset.name.toLowerCase().contains(searchLower))
          .toList();
    }
  }

  Future<void> _loadAssets() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final assets = await _assetService.getAssets();

      setState(() {
        _assets = assets;
        _filteredAssets = List.from(_assets);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar ativos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleAssetSelection(Asset asset) {
    setState(() {
      asset.isSelected = !asset.isSelected;
      if (asset.isSelected) {
        asset.quantity = 1;
      } else {
        asset.quantity = 0;
      }
      _updateSelectedCount();
    });
  }

  void _updateAssetQuantity(Asset asset, int quantity) {
    setState(() {
      asset.quantity = quantity;
      if (quantity > 0 && !asset.isSelected) {
        asset.isSelected = true;
      } else if (quantity == 0) {
        asset.isSelected = false;
      }
      _updateSelectedCount();
    });
  }

  void _updateSelectedCount() {
    _selectedAssetsCount = _assets.where((asset) => asset.isSelected).length;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Header(),

            // Main Content
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 80 : 20,
                vertical: isDesktop ? 40 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Subtitle
                  _buildTitleSection(isDesktop),

                  const SizedBox(height: 32),

                  // Search Bar
                  _buildSearchBar(isDesktop),

                  const SizedBox(height: 24),

                  // AI Suggestion Button
                  _buildAISuggestionButton(isDesktop),

                  const SizedBox(height: 32),

                  // Selected Assets Counter
                  _buildSelectedCounter(isDesktop),

                  const SizedBox(height: 24),

                  // Assets List
                  _buildAssetsList(isDesktop),

                  const SizedBox(height: 32),

                  // Continue Button
                  _buildContinueButton(isDesktop),
                ],
              ),
            ),

            // Footer
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => AppRoutes.goBack(context),
              icon: const Icon(Icons.arrow_back),
              color: const Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Select the assets you want to monitor',
                style: TextStyle(
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Text(
            'Choose the equipment you want to monitor and we will calculate the ideal number of sensors for your operation.',
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDesktop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 56),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search asset models',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildAISuggestionButton(bool isDesktop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 56),
      child: InkWell(
        onTap: () async {
          // Navegar para a tela da câmera AI
          final result = await AppRoutes.navigateTo<List<Asset>>(
            context,
            AppRoutes.aiCamera,
          );

          if (result != null && result.isNotEmpty && mounted) {
            // Atualizar a lista de assets com os resultados da AI
            setState(() {
              _assets = List.from(result);
              _filteredAssets = List.from(_assets);
              _updateSelectedCount();
            });

            // Mostrar mensagem de sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '${result.length} asset(s) similar(es) encontrado(s) pela AI!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF8FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find my asset by AI',
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Take a picture of your asset and we will find it for you.',
                      style: TextStyle(
                        fontSize: isDesktop ? 12 : 11,
                        color: const Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF2563EB),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedCounter(bool isDesktop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 56),
      child: Text(
        '$_selectedAssetsCount Assets selected',
        style: TextStyle(
          fontSize: isDesktop ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildAssetsList(bool isDesktop) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(
            color: Color(0xFF2563EB),
          ),
        ),
      );
    }

    if (_filteredAssets.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 56),
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No assets found',
                style: TextStyle(
                  fontSize: isDesktop ? 16 : 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 56),
      child: Column(
        children: _filteredAssets
            .map((asset) => _buildAssetCard(asset, isDesktop))
            .toList(),
      ),
    );
  }

  Widget _buildAssetCard(Asset asset, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: asset.isSelected
              ? const Color(0xFF2563EB)
              : Colors.grey.withOpacity(0.2),
          width: asset.isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Asset Image
              Container(
                width: isDesktop ? 60 : 50,
                height: isDesktop ? 60 : 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    asset.image,
                    width: isDesktop ? 60 : 50,
                    height: isDesktop ? 60 : 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.precision_manufacturing,
                          color: const Color(0xFF6B7280),
                          size: isDesktop ? 24 : 20,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          color: const Color(0xFF6B7280),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Asset Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.name,
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${asset.sensornumber} recommended sensors',
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF8FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ID: ${asset.id}',
                            style: TextStyle(
                              fontSize: isDesktop ? 12 : 10,
                              color: const Color(0xFF1E40AF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quantity Controls for Desktop
              if (asset.isSelected && isDesktop) ...[
                const SizedBox(width: 16),
                _buildQuantityControls(asset, isDesktop),
              ],

              const SizedBox(width: 16),

              // Selection Checkbox
              GestureDetector(
                onTap: () => _toggleAssetSelection(asset),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: asset.isSelected
                        ? const Color(0xFF2563EB)
                        : Colors.transparent,
                    border: Border.all(
                      color: asset.isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFD1D5DB),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: asset.isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
            ],
          ),

          // Quantity Controls for Mobile - Below the asset info
          if (asset.isSelected && !isDesktop) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: _buildQuantityControls(asset, isDesktop),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuantityControls(Asset asset, bool isDesktop) {
    return Row(
      children: [
        // Decrease Button
        GestureDetector(
          onTap: () {
            if (asset.quantity > 1) {
              _updateAssetQuantity(asset, asset.quantity - 1);
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: asset.quantity > 1
                  ? const Color(0xFF2563EB)
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.remove,
              color:
                  asset.quantity > 1 ? Colors.white : const Color(0xFF9CA3AF),
              size: 16,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Quantity Display
        Text(
          '${asset.quantity}',
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),

        const SizedBox(width: 12),

        // Increase Button
        GestureDetector(
          onTap: () => _updateAssetQuantity(asset, asset.quantity + 1),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(bool isDesktop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 56),
      width: double.infinity,
      child: _selectedAssetsCount > 0
          ? Button(
              buttonText: _isCalculating ? 'Calculating...' : 'Continue',
              isPopular: true,
              onPressed: _isCalculating
                  ? () {}
                  : () {
                      _calculateRecommendation();
                    },
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Select at least one asset to continue',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _calculateRecommendation() async {
    if (_isCalculating) return;

    setState(() {
      _isCalculating = true;
    });

    try {
      final selectedAssets =
          _assets.where((asset) => asset.isSelected).toList();
      final recommendation =
          await _assetService.calculateRecommendedSensors(selectedAssets);

      // Voltar para a tela de checkout com a recomendação
      if (mounted) {
        AppRoutes.goBack(context, recommendation);
      }
    } catch (e) {
      setState(() {
        _isCalculating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error calculating recommendation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
