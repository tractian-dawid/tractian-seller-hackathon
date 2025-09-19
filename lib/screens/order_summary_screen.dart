import 'package:flutter/material.dart';
import 'package:tractian_seller/routes/app_routes.dart';

import 'home_screen.dart';

class OrderSummaryData {
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;
  final String cardNumber;
  final String cardType;
  final String expiryDate;

  OrderSummaryData({
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
    required this.cardNumber,
    required this.cardType,
    required this.expiryDate,
  });
}

class OrderSummaryScreen extends StatelessWidget {
  final OrderSummaryData? orderData;

  const OrderSummaryScreen({super.key, this.orderData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

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
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 24 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 600 : screenWidth,
                      ),
                      child: Column(
                        children: [
                          _buildTitleWithBackButton(context, isDesktop),
                          const SizedBox(height: 24),
                          _buildOrderDetailsCard(isDesktop),
                          _Divider(),
                          _buildDeliveryCard(isDesktop),
                          _Divider(),
                          _buildTimelineCard(isDesktop),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 600 : screenWidth,
                      ),
                      child: _buildPaymentMethodCard(isDesktop),
                    ),
                  ],
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

  Widget _buildTitleWithBackButton(BuildContext context, bool isDesktop) {
    return Row(
      children: [
        IconButton(
          onPressed: () => AppRoutes.navigateAndReplace(
            context,
            AppRoutes.home,
          ),
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Order Summary',
            style: TextStyle(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsCard(bool isDesktop) {
    final data = orderData;
    final quantity = data?.quantity ?? 32;
    final unitPrice = data?.unitPrice ?? 375.00;
    final total = data?.total ?? 12043.40;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.receipt_outlined,
                size: isDesktop ? 20 : 18,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: isDesktop ? 18 : 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: isDesktop ? 80 : 60,
              height: isDesktop ? 80 : 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'TRACTIAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isDesktop ? 10 : 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Trac',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 8),
                  Text(
                    '\$${unitPrice.toStringAsFixed(2)} × $quantity uni',
                    style: TextStyle(
                      fontSize: isDesktop ? 14 : 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$ ${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDeliveryCard(bool isDesktop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.local_shipping_outlined,
          size: isDesktop ? 20 : 18,
          color: Colors.blue,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimated delivery:',
              style: TextStyle(
                fontSize: isDesktop ? 14 : 12,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sep 29, 2025',
              style: TextStyle(
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineCard(bool isDesktop) {
    return Column(
      children: [
        _buildTimelineItem(
          'Payment approved',
          'Sep 18 at 08:03 PM',
          isCompleted: true,
          isDesktop: isDesktop,
        ),
        _buildTimelineItem(
          'Invoice issued',
          'Sep 18 at 08:03 PM',
          isCompleted: true,
          isDesktop: isDesktop,
        ),
        _buildTimelineItem(
          'Preparing shipment...',
          'Sep 18 at 08:05 PM',
          isCompleted: true,
          isDesktop: isDesktop,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time, {
    required bool isCompleted,
    required bool isDesktop,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFE5E7EB),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 10,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isDesktop ? 14 : 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 6),
              Container(
                width: 1,
                height: 20,
                color: const Color(0xFFE5E7EB),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildPaymentMethodCard(bool isDesktop) {
    final data = orderData;
    final cardType = data?.cardType ?? 'MC';
    final cardNumber = data?.cardNumber ?? '••••4578';
    final cardColor = _getCardColor(cardType);
    final cardName = _getCardName(cardType);

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.credit_card_outlined,
                  size: isDesktop ? 20 : 18,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 32,
                height: 20,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    cardType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$cardName $cardNumber',
                style: TextStyle(
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCardColor(String cardType) {
    switch (cardType.toUpperCase()) {
      case 'VISA':
        return const Color(0xFF1A1F71);
      case 'MC':
        return const Color(0xFFEB001B);
      case 'AMEX':
        return const Color(0xFF006FCF);
      case 'DISC':
        return const Color(0xFFFF6000);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getCardName(String cardType) {
    switch (cardType.toUpperCase()) {
      case 'VISA':
        return 'Visa';
      case 'MC':
        return 'Mastercard';
      case 'AMEX':
        return 'American Express';
      case 'DISC':
        return 'Discover';
      default:
        return 'Card';
    }
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Divider(
        color: Colors.black.withValues(alpha: 0.1),
      ),
    );
  }
}
