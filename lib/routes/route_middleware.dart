import 'package:flutter/material.dart';

import 'route_names.dart';

/// Middleware para interceptar navegação entre rotas
///
/// Este middleware pode ser usado para:
/// - Analytics de navegação
/// - Verificação de autenticação
/// - Logs de navegação
/// - Validações personalizadas
class RouteMiddleware {
  /// Callback chamado antes de navegar para uma rota
  static bool onBeforeNavigate(String routeName, {Object? arguments}) {
    // Log da navegação
    debugPrint('🧭 Navigating to: $routeName');
    if (arguments != null) {
      debugPrint('📦 With arguments: $arguments');
    }

    // Validar se a rota existe
    if (!RouteNames.isValidRoute(routeName)) {
      debugPrint('⚠️ Invalid route: $routeName');
      return false;
    }

    // Aqui você pode adicionar lógica de autenticação
    // Por exemplo:
    // if (_requiresAuth(routeName) && !_isAuthenticated()) {
    //   return false;
    // }

    return true;
  }

  /// Callback chamado após navegar para uma rota
  static void onAfterNavigate(String routeName, {Object? arguments}) {
    debugPrint('✅ Navigation completed to: $routeName');

    // Aqui você pode adicionar analytics
    // Analytics.trackPageView(routeName);

    // Ou atualizar o título da página
    _updatePageTitle(routeName);
  }

  /// Callback chamado quando a navegação falha
  static void onNavigationFailed(String routeName, {Object? error}) {
    debugPrint('❌ Navigation failed to: $routeName');
    if (error != null) {
      debugPrint('💥 Error: $error');
    }
  }

  /// Atualiza o título da página baseado na rota
  static void _updatePageTitle(String routeName) {
    final title = RouteNames.getPageTitle(routeName);
    debugPrint('📄 Page title: $title');

    // Em uma aplicação web, você poderia atualizar o título do browser
    // html.document.title = title;
  }

  /// Verifica se uma rota requer autenticação
  static bool requiresAuth(String routeName) {
    const protectedRoutes = [
      RouteNames.profile,
      RouteNames.settings,
    ];

    return protectedRoutes.contains(routeName);
  }

  /// Simula verificação de autenticação
  static bool isAuthenticated() {
    // Aqui você verificaria o estado de autenticação real
    // Por exemplo, verificar se existe um token válido
    return true; // Simulando usuário autenticado
  }

  /// Obtém a rota de fallback para rotas não encontradas
  static String getFallbackRoute() {
    return RouteNames.home;
  }

  /// Verifica se pode navegar de volta
  static bool canNavigateBack(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Obtém informações sobre a pilha de navegação
  static void debugNavigationStack(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route != null) {
      debugPrint('🔍 Current route: ${route.settings.name}');
      debugPrint('🔍 Can pop: ${Navigator.canPop(context)}');
    }
  }
}
