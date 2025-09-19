/// Classe que centraliza todos os nomes das rotas da aplicação
///
/// Esta classe fornece uma maneira organizada de gerenciar os nomes das rotas,
/// facilitando a manutenção e evitando erros de digitação.
class RouteNames {
  // Previne instanciação da classe
  RouteNames._();

  // Rotas principais
  static const String home = '/';
  static const String checkout = '/checkout';
  static const String checkoutPayment = '/checkout-payment';
  static const String paymentSuccess = '/payment-success';
  static const String orderSummary = '/order-summary';
  static const String assetSelection = '/asset-selection';
  static const String aiCamera = '/ai-camera';

  // Rotas futuras (para expansão)
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String about = '/about';

  /// Lista de todas as rotas para validação
  static const List<String> allRoutes = [
    home,
    checkout,
    checkoutPayment,
    paymentSuccess,
    orderSummary,
    assetSelection,
    aiCamera,
    profile,
    settings,
    help,
    about,
  ];

  /// Verifica se uma rota é válida
  static bool isValidRoute(String? routeName) {
    return routeName != null && allRoutes.contains(routeName);
  }

  /// Obtém o título da página baseado na rota
  static String getPageTitle(String routeName) {
    switch (routeName) {
      case home:
        return 'Tractian - Smart Solutions';
      case checkout:
        return 'Checkout - Tractian';
      case checkoutPayment:
        return 'Payment - Tractian';
      case paymentSuccess:
        return 'Payment Successful - Tractian';
      case orderSummary:
        return 'Order Summary - Tractian';
      case assetSelection:
        return 'Asset Selection - Tractian';
      case aiCamera:
        return 'AI Camera - Tractian';
      case profile:
        return 'Profile - Tractian';
      case settings:
        return 'Settings - Tractian';
      case help:
        return 'Help - Tractian';
      case about:
        return 'About - Tractian';
      default:
        return 'Tractian';
    }
  }

  /// Obtém uma descrição da página baseado na rota
  static String getPageDescription(String routeName) {
    switch (routeName) {
      case home:
        return 'Transform your operation with our predictive monitoring platform';
      case checkout:
        return 'Complete your sensor purchase';
      case checkoutPayment:
        return 'Enter your payment details';
      case paymentSuccess:
        return 'Your payment was processed successfully';
      case orderSummary:
        return 'View your order details and tracking information';
      case assetSelection:
        return 'Select the assets you want to monitor';
      case aiCamera:
        return 'Use AI to identify your assets with camera';
      case profile:
        return 'Manage your profile settings';
      case settings:
        return 'Application settings';
      case help:
        return 'Get help and support';
      case about:
        return 'Learn more about Tractian';
      default:
        return 'Tractian - Industrial maintenance transformation';
    }
  }
}
