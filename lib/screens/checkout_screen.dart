import 'package:flutter/material.dart';
import 'package:tractian_seller/screens/checkout_payment_screen.dart';
import 'package:tractian_seller/screens/order_summary_screen.dart';
import 'package:tractian_seller/services/asset_service.dart';

import '../routes/routes.dart';
import 'home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int quantity = 20;
  final double unitPrice = 120.00;
  final double taxRate = 0.08; // 8% tax
  final double shippingCost = 15.00;
  SensorRecommendation? _recommendation;

  // Receiver section variables
  bool? _isDistanceLessThan100m;
  int _numberOfLocations = 1;

  double get subtotal => quantity * unitPrice;
  double get tax => subtotal * taxRate;
  double get total => subtotal + tax + shippingCost;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
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
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 600 : screenWidth,
                  ),
                  child: _buildCheckoutCard(isDesktop),
                ),
              ),
            ),

            // Footer
            Footer()
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutCard(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SENSORS Title
          Text(
            'SENSORS',
            style: TextStyle(
              fontSize: isDesktop ? 14 : 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),

          // Product Section
          _buildProductSection(isDesktop),

          const SizedBox(height: 24),

          // Smart Recommendation Button
          _buildSmartRecommendationButton(isDesktop),

          const DividerWidget(),

          // Receiver Section
          _buildReceiverSection(isDesktop),

          const DividerWidget(),

          // Price Summary
          _buildPriceSummary(isDesktop),

          const SizedBox(height: 32),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: Button(
              buttonText: 'Proceed to Checkout',
              isPopular: true,
              onPressed: () {
                _proceedToCheckout();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(bool isDesktop) {
    return SizedBox(
      height: isDesktop ? 120 : 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: isDesktop ? 120 : 80,
            height: isDesktop ? 120 : 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Center(
              child: Image.asset('assets/sensor.png'),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Trac Ultra',
                          style: TextStyle(
                            fontSize: isDesktop ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          'Ultra',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        child: Text(
                          '\$${unitPrice.toStringAsFixed(2)} /mo',
                          style: TextStyle(
                            fontSize: isDesktop ? 14 : 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: _buildQuantitySelector(isDesktop)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrease Button
          FittedBox(
            child: GestureDetector(
              onTap: () {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                  });
                }
              },
              child: Icon(
                Icons.remove,
                color: Colors.blue,
                size: 18,
              ),
            ),
          ),

          // Quantity Display
          Center(
            child: Text(
              '$quantity UNI',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),

          // Increase Button
          FittedBox(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  quantity++;
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.blue,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartRecommendationButton(bool isDesktop) {
    return GestureDetector(
      onTap: () async {
        final result = await AppRoutes.navigateTo<SensorRecommendation>(
          context,
          AppRoutes.assetSelection,
        );

        if (result != null && mounted) {
          setState(() {
            _recommendation = result;
            quantity = result.recommendedSensors;
            // Não muda a quantidade automaticamente, apenas mostra a sugestão
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Recommendation calculated: ${result.recommendedSensors} sensors ideal for your operation'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _recommendation != null
              ? Colors.green.shade50
              : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _recommendation != null
                ? Colors.transparent
                : Colors.blue.shade400,
          ),
        ),
        child: _recommendation != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green.shade600,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You need ${_recommendation!.recommendedSensors} sensors!',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This is the ideal number for your operation',
                          style: TextStyle(
                            fontSize: isDesktop ? 12 : 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      'Discover ideal sensor quantity based on assets I want to monitor',
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        color: _recommendation != null
                            ? const Color(0xFF059669)
                            : Colors.blue.shade900,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: _recommendation != null
                        ? const Color(0xFF059669)
                        : Colors.grey.shade500,
                    size: isDesktop ? 12 : 10,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildReceiverSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Receiver Product Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: isDesktop ? 100 : 80,
              height: isDesktop ? 100 : 80,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Center(
                child: Image.asset('assets/gateway.png'),
              ),
            ),

            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: SizedBox(
                height: isDesktop ? 100 : 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receiver',
                              style: TextStyle(
                                fontSize: isDesktop ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ultra',
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 12,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDEF7EC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    const Color(0xFF10B981).withOpacity(0.2)),
                          ),
                          child: Text(
                            'Included',
                            style: TextStyle(
                              fontSize: isDesktop ? 12 : 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF065F46),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Center(
                          child: Text(
                            '$_numberOfLocations uni',
                            style: TextStyle(
                              fontSize: isDesktop ? 16 : 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Distance Question
        Text(
          'Is the distance between the sensors less than 100 meters?',
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1F2937),
          ),
        ),

        const SizedBox(height: 16),

        // Yes/No Buttons
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isDistanceLessThan100m = true;
                    _numberOfLocations = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _isDistanceLessThan100m == true
                        ? const Color(0xFF2563EB)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isDistanceLessThan100m == true
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: _isDistanceLessThan100m == true
                            ? Colors.white
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isDistanceLessThan100m = false;
                    _numberOfLocations = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _isDistanceLessThan100m == false
                        ? const Color(0xFF2563EB)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isDistanceLessThan100m == false
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: isDesktop ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: _isDistanceLessThan100m == false
                            ? Colors.white
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Additional section when "No" is selected
        if (_isDistanceLessThan100m == false) ...[
          const SizedBox(height: 24),

          Text(
            'Number of Locations (100m apart)',
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 16),

          // Location Number Selector
          Row(
            children: [
              for (int i = 2; i <= 6; i++) ...[
                if (i > 2) const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _numberOfLocations = i;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _numberOfLocations == i
                            ? const Color(0xFF2563EB)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _numberOfLocations == i
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          i == 6 ? '+6' : '$i',
                          style: TextStyle(
                            fontSize: isDesktop ? 14 : 12,
                            fontWeight: FontWeight.w600,
                            color: _numberOfLocations == i
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Helper text
          Text(
            'The receiver works within 100 meters.\nPlease enter the number of locations that are more than 100 meters apart',
            style: TextStyle(
              fontSize: isDesktop ? 12 : 11,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSummary(bool isDesktop) {
    return Column(
      children: [
        _buildPriceRow('Subtotal ($quantity items)', subtotal, isDesktop),
        const SizedBox(height: 12),
        _buildPriceRow('Tax', tax, isDesktop),
        const SizedBox(height: 12),
        _buildPriceRow('Shipping', shippingCost, isDesktop),
        const SizedBox(height: 16),

        // Divider
        Container(
          height: 1,
          color: const Color(0xFFE5E7EB),
        ),

        const SizedBox(height: 16),
        _buildPriceRow('Total', total, isDesktop, isTotal: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, bool isDesktop,
      {bool isTotal = false}) {
    final text = isTotal ? ' /mo' : '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF1F2937),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}$text',
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  void _proceedToCheckout() {
    final checkoutData = CheckoutData(
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
      tax: tax,
      shipping: shippingCost,
      total: total,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPaymentScreen(checkoutData: checkoutData),
      ),
    );
  }
}
