import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Header(),

            // Primeira Seção - 3 Cards com ícones
            _buildFirstSection(context),

            // Segunda Seção - Feedbacks e Quote
            _buildSecondSection(context),

            // Terceira Seção - Planos de Preços
            _buildPricingSection(context),

            // Footer
            Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstSection(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: isDesktop ? 80 : 40,
      ),
      child: Column(
        children: [
          // Título da seção
          Text(
            'Smart Solutions for Your Business',
            style: TextStyle(
              fontSize: isDesktop ? 36 : 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Transform your operation with our predictive monitoring platform',
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Cards
          if (isDesktop)
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    Icons.analytics_outlined,
                    'Predictive Analysis',
                    'Identify problems before they happen with our advanced AI',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                    child: _buildFeatureCard(
                  Icons.speed_outlined,
                  'Real-Time Monitoring',
                  'Track your equipment performance 24/7',
                )),
                const SizedBox(width: 24),
                Expanded(
                    child: _buildFeatureCard(
                  Icons.savings_outlined,
                  'Cost Reduction',
                  'Save up to 40% on maintenance with our solution',
                )),
              ],
            )
          else
            Column(
              children: [
                _buildFeatureCard(
                  Icons.analytics_outlined,
                  'Predictive Analysis',
                  'Identify problems before they happen with our advanced AI',
                ),
                const SizedBox(height: 24),
                _buildFeatureCard(
                  Icons.speed_outlined,
                  'Real-Time Monitoring',
                  'Track your equipment performance 24/7',
                ),
                const SizedBox(height: 24),
                _buildFeatureCard(
                  Icons.savings_outlined,
                  'Cost Reduction',
                  'Save up to 40% on maintenance with our solution',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondSection(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: isDesktop ? 80 : 40,
      ),
      child: isDesktop
          ? Row(
              children: [
                // Lado esquerdo - Feedbacks e preços
                Expanded(
                  flex: 2,
                  child: _buildTestimonialsAndPricing(),
                ),
                const SizedBox(width: 48),
                // Lado direito - Get Custom Quote
                Expanded(
                  child: _buildCustomQuoteCard(context),
                ),
              ],
            )
          : Column(
              children: [
                _buildTestimonialsAndPricing(),
                const SizedBox(height: 32),
                _buildCustomQuoteCard(context),
              ],
            ),
    );
  }

  Widget _buildTestimonialsAndPricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What our customers say',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 24),

        // Testimonial
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                    5,
                    (index) => const Icon(
                          Icons.star,
                          color: Color(0xFFFBBF24),
                          size: 20,
                        )),
              ),
              const SizedBox(height: 16),
              const Text(
                '"Tractian revolutionized our maintenance. We reduced costs by 35% and significantly increased operational efficiency."',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF374151),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF2563EB),
                    child: Text(
                      'JS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Silva',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        'Maintenance Manager, XYZ Company',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Pricing info
        const Text(
          'Prices that fit your budget',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text(
              'Starting at ',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const Text(
              '\$400',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
            const Text(
              '/sensor/month',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomQuoteCard(BuildContext context) {
    return CustomQuoteWidget();
  }

  Widget _buildPricingSection(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: isDesktop ? 80 : 40,
      ),
      child: Column(
        children: [
          const Text(
            'Choose the ideal plan for your company',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          if (isDesktop)
            SizedBox(
              height: 650,
              child: Row(
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildPricingCard(
                      context: context,
                      title: '1-10 sensors',
                      subtitle:
                          'Perfect for small teams starting with predictive maintenance.',
                      price: '\$400',
                      period: '/sensor/month',
                      startingText: 'starting from 5 users, billed annually',
                      features: [
                        'Tractian AI',
                        'Unlimited assets',
                        'Security keys and Passkey login',
                        'No platform fee',
                        'Free data import',
                      ],
                      buttonText: 'Buy now',
                      isPopular: false,
                    ),
                  ),
                  Expanded(
                    child: _buildPricingCard(
                      context: context,
                      title: '10-30 sensors',
                      subtitle: 'Best value for growing operations.',
                      price: '\$350',
                      period: '/sensor/month',
                      startingText: 'starting from 10 users, billed annually',
                      features: [
                        'Tractian AI',
                        'Unlimited assets',
                        'Custom entities',
                        'Single Sign-On (SSO)',
                        'Power BI connector',
                        'No platform fee',
                      ],
                      buttonText: 'Buy now',
                      isPopular: true,
                    ),
                  ),
                  Expanded(
                    child: _buildPricingCard(
                      context: context,
                      title: 'Bundle',
                      subtitle:
                          'For operations that want to combine CMMS with Condition Monitoring Sensors, unlocking the full potential of AI-driven predictive maintenance.',
                      price: '',
                      period: '',
                      startingText: '',
                      features: [
                        'Tractian AI',
                        'Standard or Enterprise plans',
                        'Unlimited viewers',
                        'No platform fee',
                        'Patented fault detection',
                        'AI root cause analysis',
                        'Automated failure reports',
                        'Factory floor plans',
                      ],
                      buttonText: 'Talk to Sales',
                      isPopular: false,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                _buildPricingCard(
                  context: context,
                  title: '1-10 sensors',
                  subtitle:
                      'Perfect for small teams starting with predictive maintenance.',
                  price: '\$400',
                  period: '/sensor/month',
                  startingText: 'starting from 5 users, billed annually',
                  features: [
                    'Tractian AI',
                    'Unlimited assets',
                    'Security keys and Passkey login',
                    'No platform fee',
                    'Free data import',
                  ],
                  buttonText: 'Buy now',
                  isPopular: false,
                ),
                const SizedBox(height: 24),
                _buildPricingCard(
                  context: context,
                  title: '10-30 sensors',
                  subtitle: 'Best value for growing operations.',
                  price: '\$350',
                  period: '/sensor/month',
                  startingText: 'starting from 10 users, billed annually',
                  features: [
                    'Tractian AI',
                    'Unlimited assets',
                    'Custom entities',
                    'Single Sign-On (SSO)',
                    'Power BI connector',
                    'No platform fee',
                  ],
                  buttonText: 'Buy now',
                  isPopular: true,
                ),
                const SizedBox(height: 24),
                _buildPricingCard(
                  context: context,
                  title: 'Bundle',
                  subtitle:
                      'For operations that want to combine CMMS with Condition Monitoring Sensors, unlocking the full potential of AI-driven predictive maintenance.',
                  price: '',
                  period: '',
                  startingText: '',
                  features: [
                    'Tractian AI',
                    'Standard or Enterprise plans',
                    'Unlimited viewers',
                    'No platform fee',
                    'Patented fault detection',
                    'AI root cause analysis',
                    'Automated failure reports',
                    'Factory floor plans',
                  ],
                  buttonText: 'Talk to Sales',
                  isPopular: false,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required String startingText,
    required List<String> features,
    required String buttonText,
    required bool isPopular,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular
              ? const Color(0xFF2563EB)
              : Colors.grey.withOpacity(0.2),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Most Popular',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          if (price.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (startingText.isNotEmpty)
              Text(
                startingText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
          ] else ...[
            const Text(
              'Plan includes:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Features
          Column(
            children: features
                .map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: Color(0xFF10B981),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 32),
          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: Button(
              buttonText: buttonText,
              isPopular: isPopular,
              onPressed: () {
                if (buttonText == 'Buy now') {
                  AppRoutes.navigateTo(context, AppRoutes.checkout);
                } else {
                  // Outros botões podem ter outras ações
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$buttonText under development'),
                      backgroundColor: const Color(0xFF2563EB),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.buttonText,
    required this.isPopular,
    required this.onPressed,
  });

  final String buttonText;
  final bool isPopular;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPopular || buttonText == 'Talk to Sales'
            ? const Color(0xFF2563EB)
            : Colors.white,
        foregroundColor: isPopular || buttonText == 'Talk to Sales'
            ? Colors.white
            : const Color(0xFF2563EB),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPopular || buttonText == 'Talk to Sales'
              ? BorderSide.none
              : const BorderSide(color: Color(0xFF2563EB)),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      color: const Color(0xFF1F2937),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: isDesktop ? 60 : 40,
      ),
      child: Column(
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo e descrição
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        height: 32,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Transforming industrial maintenance with artificial intelligence and predictive monitoring.',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),

                // Links
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FooterLink(text: 'Features'),
                      FooterLink(text: 'Pricing'),
                      FooterLink(text: 'API'),
                      FooterLink(text: 'Documentation'),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Company',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FooterLink(text: 'About'),
                      FooterLink(text: 'Blog'),
                      FooterLink(text: 'Careers'),
                      FooterLink(text: 'Contact'),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Support',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FooterLink(text: 'Help Center'),
                      FooterLink(text: 'Status'),
                      FooterLink(text: 'Community'),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Transforming industrial maintenance with artificial intelligence and predictive monitoring.',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

          const SizedBox(height: 48),

          // Divider
          Container(
            height: 1,
            color: const Color(0xFF374151),
          ),

          const SizedBox(height: 24),

          // Copyright
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '© 2025 Tractian. All rights reserved.',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12,
                ),
              ),
              if (isDesktop)
                Row(
                  children: [
                    SocialIcon(icon: Icons.facebook),
                    const SizedBox(width: 16),
                    SocialIcon(icon: Icons.alternate_email), // Twitter/X
                    const SizedBox(width: 16),
                    SocialIcon(icon: Icons.business), // LinkedIn
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  const SocialIcon({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF374151),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF9CA3AF),
        size: 16,
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  const FooterLink({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 14,
        ),
      ),
    );
  }
}

class CustomQuoteWidget extends StatefulWidget {
  const CustomQuoteWidget({super.key});

  @override
  State<CustomQuoteWidget> createState() => _CustomQuoteWidgetState();
}

class _CustomQuoteWidgetState extends State<CustomQuoteWidget> {
  double _assetsValue = 600; // Valor inicial do slider de assets
  int _percentageValue = 1; // 0 = 0 to 10%, 1 = 10% to 20%, 2 = 30%+

  final List<String> _percentageOptions = ['0 to 10%', '10% to 20%', '30%+'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2563EB).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get Custom Quote',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 32),

          // Primeira pergunta - Assets
          const Text(
            'How many assets run in your operation?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Slider de assets
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '10',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  Text(
                    '200',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  Text(
                    '400',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  Text(
                    '600',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  Text(
                    '+800',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12),
                  activeTrackColor: const Color(0xFF2563EB),
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  thumbColor: const Color(0xFF2563EB),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: _assetsValue,
                  min: 10,
                  max: 800,
                  divisions: 79, // Para ter steps mais suaves
                  onChanged: (value) {
                    setState(() {
                      _assetsValue = value;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Segunda pergunta - Percentual
          const Text(
            'What percentage of your assets do you plan to implement predictive maintenance techniques?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Slider de percentual
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _percentageOptions
                    .map((option) => Text(
                          option,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12),
                  activeTrackColor: const Color(0xFF2563EB),
                  inactiveTrackColor: const Color(0xFFE5E7EB),
                  thumbColor: const Color(0xFF2563EB),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: _percentageValue.toDouble(),
                  min: 0,
                  max: 2,
                  divisions: 2,
                  onChanged: (value) {
                    setState(() {
                      _percentageValue = value.round();
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Botão Request Quote
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Solicitar orçamento personalizado
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Custom quote requested! Assets: ${_assetsValue.round()}, Percentage: ${_percentageOptions[_percentageValue]}',
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Request Quote',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          GestureDetector(
            onTap: () => AppRoutes.navigateAndReplace(context, AppRoutes.home),
            child: SvgPicture.asset(
              'assets/logo.svg',
              height: isDesktop ? 32 : 24,
            ),
          ),

          if (!isDesktop)
            IconButton(
              onPressed: () {
                final currentRoute = AppRoutes.getCurrentRoute(context);
                if (currentRoute == AppRoutes.checkout) return;
                AppRoutes.navigateTo(context, AppRoutes.checkout);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
        ],
      ),
    );
  }
}
