import 'package:flutter/material.dart';
import 'package:tractian_seller/screens/ai_camera_screen.dart';
import 'package:tractian_seller/screens/asset_selection_screen.dart';
import 'package:tractian_seller/screens/checkout_payment_screen.dart';
import 'package:tractian_seller/screens/checkout_screen.dart';
import 'package:tractian_seller/screens/home_screen.dart';
import 'package:tractian_seller/screens/order_summary_screen.dart';
import 'package:tractian_seller/screens/payment_success_screen.dart';

import 'route_middleware.dart';
import 'route_names.dart';

/// Classe que define todas as rotas da aplicação
class AppRoutes {
  // Nomes das rotas (usando RouteNames para consistência)
  static const String home = RouteNames.home;
  static const String checkout = RouteNames.checkout;
  static const String checkoutPayment = RouteNames.checkoutPayment;
  static const String paymentSuccess = RouteNames.paymentSuccess;
  static const String orderSummary = RouteNames.orderSummary;
  static const String assetSelection = RouteNames.assetSelection;
  static const String aiCamera = RouteNames.aiCamera;

  /// Mapa de todas as rotas da aplicação
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        checkout: (context) => const CheckoutScreen(),
        checkoutPayment: (context) => const CheckoutPaymentScreen(),
        paymentSuccess: (context) => const PaymentSuccessScreen(),
        orderSummary: (context) => const OrderSummaryScreen(),
        assetSelection: (context) => const AssetSelectionScreen(),
        aiCamera: (context) => const AiCameraScreen(),
      };

  /// Gerador de rotas para rotas dinâmicas (se necessário no futuro)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const HomeScreen(),
          settings: settings,
        );
      case checkout:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const CheckoutScreen(),
          settings: settings,
        );
      case checkoutPayment:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const CheckoutPaymentScreen(),
          settings: settings,
        );
      case paymentSuccess:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const PaymentSuccessScreen(),
          settings: settings,
        );
      case orderSummary:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const OrderSummaryScreen(),
          settings: settings,
        );
      case assetSelection:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const AssetSelectionScreen(),
          settings: settings,
        );
      case aiCamera:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const AiCameraScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const HomeScreen(),
          settings: settings,
        );
    }
  }

  /// Método para navegar usando rotas nomeadas
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    // Verificar permissões através do middleware
    if (!RouteMiddleware.onBeforeNavigate(routeName, arguments: arguments)) {
      RouteMiddleware.onNavigationFailed(routeName,
          error: 'Navigation blocked by middleware');
      return Future.value(null);
    }

    try {
      // Usar Navigator.push com rota tipada em vez de pushNamed
      final route = _createTypedRoute<T>(routeName, arguments);
      if (route == null) {
        RouteMiddleware.onNavigationFailed(routeName, error: 'Route not found');
        return Future.value(null);
      }

      final result = Navigator.push<T>(context, route);
      RouteMiddleware.onAfterNavigate(routeName, arguments: arguments);
      return result;
    } catch (error) {
      RouteMiddleware.onNavigationFailed(routeName, error: error);
      rethrow;
    }
  }

  /// Cria uma rota tipada baseada no nome da rota
  static MaterialPageRoute<T>? _createTypedRoute<T extends Object?>(
    String routeName,
    Object? arguments,
  ) {
    Widget? page;

    switch (routeName) {
      case home:
        page = const HomeScreen();
        break;
      case checkout:
        page = const CheckoutScreen();
        break;
      case checkoutPayment:
        page = const CheckoutPaymentScreen();
        break;
      case paymentSuccess:
        page = const PaymentSuccessScreen();
        break;
      case orderSummary:
        page = const OrderSummaryScreen();
        break;
      case assetSelection:
        page = const AssetSelectionScreen();
        break;
      case aiCamera:
        page = const AiCameraScreen();
        break;
      default:
        return null;
    }

    return MaterialPageRoute<T>(
      builder: (context) => page!,
      settings: RouteSettings(name: routeName, arguments: arguments),
    );
  }

  /// Método para navegar e substituir a rota atual
  static Future<T?> navigateAndReplace<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    // Verificar permissões através do middleware
    if (!RouteMiddleware.onBeforeNavigate(routeName, arguments: arguments)) {
      RouteMiddleware.onNavigationFailed(routeName,
          error: 'Navigation blocked by middleware');
      return Future.value(null);
    }

    try {
      final route = _createTypedRoute<T>(routeName, arguments);
      if (route == null) {
        RouteMiddleware.onNavigationFailed(routeName, error: 'Route not found');
        return Future.value(null);
      }

      final result = Navigator.pushReplacement<T, Object?>(context, route);
      RouteMiddleware.onAfterNavigate(routeName, arguments: arguments);
      return result;
    } catch (error) {
      RouteMiddleware.onNavigationFailed(routeName, error: error);
      rethrow;
    }
  }

  /// Método para navegar e limpar todo o stack de rotas
  static Future<T?> navigateAndClearStack<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    // Verificar permissões através do middleware
    if (!RouteMiddleware.onBeforeNavigate(routeName, arguments: arguments)) {
      RouteMiddleware.onNavigationFailed(routeName,
          error: 'Navigation blocked by middleware');
      return Future.value(null);
    }

    try {
      final route = _createTypedRoute<T>(routeName, arguments);
      if (route == null) {
        RouteMiddleware.onNavigationFailed(routeName, error: 'Route not found');
        return Future.value(null);
      }

      final result = Navigator.pushAndRemoveUntil<T>(
        context,
        route,
        (route) => false,
      );
      RouteMiddleware.onAfterNavigate(routeName, arguments: arguments);
      return result;
    } catch (error) {
      RouteMiddleware.onNavigationFailed(routeName, error: error);
      rethrow;
    }
  }

  /// Método para voltar à rota anterior
  static void goBack(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }

  /// Verifica se pode voltar
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Obtém o nome da rota atual
  static String? getCurrentRoute(BuildContext context) {
    return ModalRoute.of(context)?.settings.name;
  }
}
