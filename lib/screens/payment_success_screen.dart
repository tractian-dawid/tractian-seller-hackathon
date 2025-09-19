import 'package:flutter/material.dart';
import 'package:tractian_seller/screens/order_summary_screen.dart';

import 'home_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final OrderSummaryData? orderData;

  const PaymentSuccessScreen({super.key, this.orderData});

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
                vertical: isDesktop ? 80 : 40,
              ),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 500 : screenWidth,
                  ),
                  child: _buildSuccessCard(context, isDesktop),
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

  Widget _buildSuccessCard(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 48 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Icon
          Container(
            width: isDesktop ? 80 : 64,
            height: isDesktop ? 80 : 64,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: isDesktop ? 40 : 32,
            ),
          ),

          SizedBox(height: isDesktop ? 32 : 24),

          // Success Message
          Text(
            'Payment successful!',
            style: TextStyle(
              fontSize: isDesktop ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isDesktop ? 16 : 12),

          // Subtitle
          Text(
            'Your order has been processed successfully. You will receive a confirmation email shortly.',
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isDesktop ? 40 : 32),

          // View Details Link
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      OrderSummaryScreen(orderData: orderData),
                ),
              );
            },
            child: Text(
              'View details',
              style: TextStyle(
                fontSize: isDesktop ? 14 : 12,
                color: const Color(0xFF2563EB),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
