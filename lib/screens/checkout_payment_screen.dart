import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tractian_seller/screens/order_summary_screen.dart';
import 'package:tractian_seller/screens/payment_success_screen.dart';

import 'home_screen.dart';

// Formatadores personalizados
class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }

    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 5) {
        formattedText += '-';
      }
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 16) {
      newText = newText.substring(0, 16);
    }

    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 4) {
      newText = newText.substring(0, 4);
    }

    String formattedText = '';
    for (int i = 0; i < newText.length; i++) {
      if (i == 2) {
        formattedText += ' / ';
      }
      formattedText += newText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class PostalCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 5) {
      newText = newText.substring(0, 5);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class CheckoutData {
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final double tax;
  final double shipping;
  final double total;

  CheckoutData({
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.total,
  });
}

class CheckoutPaymentScreen extends StatefulWidget {
  final CheckoutData? checkoutData;

  const CheckoutPaymentScreen({super.key, this.checkoutData});

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _selectedCountry = 'United States';

  @override
  void dispose() {
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

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
                  child: _buildPaymentForm(isDesktop),
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

  Widget _buildPaymentForm(bool isDesktop) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 32 : 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with Back Button
            _buildTitleWithBackButton(isDesktop),
            const SizedBox(height: 32),

            // Address Section
            _buildSectionHeader('Address', Icons.location_on, isDesktop),
            const SizedBox(height: 24),

            // CEP Field
            _buildTextField(
              controller: _cepController,
              label: 'ZIP Code',
              placeholder: 'E.g.: 12123-000',
              isDesktop: isDesktop,
              inputFormatters: [CepInputFormatter()],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Street/Avenue Field
            _buildTextField(
              controller: _streetController,
              label: 'Street/Avenue',
              placeholder: 'E.g.: Avenue los Leones',
              isDesktop: isDesktop,
            ),
            const SizedBox(height: 16),

            // Number Field
            _buildTextField(
              controller: _numberController,
              label: 'Number',
              placeholder: 'E.g.: 1234',
              isDesktop: isDesktop,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),

            // Payment Method Section
            _buildSectionHeader('Payment Method', Icons.payment, isDesktop),
            const SizedBox(height: 24),

            // Card Number Field
            _buildTextField(
              controller: _cardNumberController,
              label: 'Card number',
              placeholder: '1234 1234 1234 1234',
              isDesktop: isDesktop,
              suffixWidget: _buildCardLogos(),
              inputFormatters: [CardNumberInputFormatter()],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Expiry and CVC Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _expiryController,
                    label: 'Expiry',
                    placeholder: 'MM / YY',
                    isDesktop: isDesktop,
                    inputFormatters: [ExpiryDateInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _cvcController,
                    label: 'CVC',
                    placeholder: 'CVC',
                    isDesktop: isDesktop,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Country and Postal Code Row
            Row(
              children: [
                Expanded(
                  child: _buildCountryDropdown(isDesktop),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _postalCodeController,
                    label: 'Postal code',
                    placeholder: '90210',
                    isDesktop: isDesktop,
                    inputFormatters: [PostalCodeInputFormatter()],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Finish Button
            SizedBox(
              width: double.infinity,
              child: Button(
                buttonText: 'Finish',
                isPopular: true,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _processPayment();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWithBackButton(bool isDesktop) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Payment Information',
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

  Widget _buildSectionHeader(String title, IconData icon, bool isDesktop) {
    return Row(
      children: [
        Icon(
          icon,
          size: isDesktop ? 20 : 18,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: isDesktop ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required bool isDesktop,
    Widget? suffixWidget,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            color: const Color(0xFF1F2937),
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: const Color(0xFF9CA3AF),
            ),
            suffixIcon: suffixWidget,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Country',
          style: TextStyle(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCountry,
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            color: const Color(0xFF1F2937),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: const [
            DropdownMenuItem(
                value: 'United States', child: Text('United States')),
            DropdownMenuItem(value: 'Brazil', child: Text('Brazil')),
            DropdownMenuItem(value: 'Canada', child: Text('Canada')),
            DropdownMenuItem(value: 'Mexico', child: Text('Mexico')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCountry = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCardLogos() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCardLogo('VISA', const Color(0xFF1A1F71)),
          const SizedBox(width: 4),
          _buildCardLogo('MC', const Color(0xFFEB001B)),
          const SizedBox(width: 4),
          _buildCardLogo('AMEX', const Color(0xFF006FCF)),
          const SizedBox(width: 4),
          _buildCardLogo('DISC', const Color(0xFFFF6000)),
        ],
      ),
    );
  }

  Widget _buildCardLogo(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _processPayment() {
    // Determinar o tipo de cartão baseado no número
    String cardType = _getCardType(_cardNumberController.text);

    // Mascarar o número do cartão (mostrar apenas os últimos 4 dígitos)
    String maskedCardNumber = _maskCardNumber(_cardNumberController.text);

    // Criar dados do pedido
    final orderData = OrderSummaryData(
      quantity: widget.checkoutData?.quantity ?? 1,
      unitPrice: widget.checkoutData?.unitPrice ?? 350.00,
      subtotal: widget.checkoutData?.subtotal ?? 350.00,
      tax: widget.checkoutData?.tax ?? 28.00,
      shipping: widget.checkoutData?.shipping ?? 15.00,
      total: widget.checkoutData?.total ?? 393.00,
      cardNumber: maskedCardNumber,
      cardType: cardType,
      expiryDate: _expiryController.text,
    );

    // Navegar para payment success screen primeiro
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(orderData: orderData),
      ),
    );
  }

  String _getCardType(String cardNumber) {
    // Remove espaços e outros caracteres
    String cleanNumber = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.isEmpty) return 'MC';

    // Visa: começa com 4
    if (cleanNumber.startsWith('4')) {
      return 'VISA';
    }
    // Mastercard: começa com 5 ou entre 2221-2720
    else if (cleanNumber.startsWith('5') ||
        (cleanNumber.length >= 4 &&
            int.tryParse(cleanNumber.substring(0, 4)) != null &&
            int.parse(cleanNumber.substring(0, 4)) >= 2221 &&
            int.parse(cleanNumber.substring(0, 4)) <= 2720)) {
      return 'MC';
    }
    // American Express: começa com 34 ou 37
    else if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37')) {
      return 'AMEX';
    }
    // Discover: começa com 6
    else if (cleanNumber.startsWith('6')) {
      return 'DISC';
    }

    return 'MC'; // Default
  }

  String _maskCardNumber(String cardNumber) {
    String cleanNumber = cardNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.length < 4) {
      return '••••$cleanNumber';
    }

    return '••••${cleanNumber.substring(cleanNumber.length - 4)}';
  }
}
