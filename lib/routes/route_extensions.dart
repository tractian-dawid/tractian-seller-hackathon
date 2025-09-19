import 'package:flutter/material.dart';

import 'app_routes.dart';

/// Extensões para facilitar a navegação usando BuildContext
extension NavigationExtensions on BuildContext {
  /// Navega para uma rota nomeada
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return AppRoutes.navigateTo<T>(this, routeName, arguments: arguments);
  }

  /// Navega e substitui a rota atual
  Future<T?> pushReplacementNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return AppRoutes.navigateAndReplace<T>(this, routeName,
        arguments: arguments);
  }

  /// Navega e limpa todo o stack de rotas
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return AppRoutes.navigateAndClearStack<T>(this, routeName,
        arguments: arguments);
  }

  /// Volta para a rota anterior
  void pop<T extends Object?>([T? result]) {
    AppRoutes.goBack(this, result);
  }

  /// Verifica se pode voltar
  bool canPop() {
    return AppRoutes.canGoBack(this);
  }

  /// Obtém o nome da rota atual
  String? get currentRoute {
    return AppRoutes.getCurrentRoute(this);
  }

  // Métodos de conveniência para rotas específicas

  /// Navega para a home
  Future<void> goToHome() {
    return pushNamedAndRemoveUntil(AppRoutes.home);
  }

  /// Navega para o checkout
  Future<void> goToCheckout() {
    return pushNamed(AppRoutes.checkout);
  }

  /// Navega para seleção de ativos
  Future<T?> goToAssetSelection<T extends Object?>() {
    return pushNamed<T>(AppRoutes.assetSelection);
  }
}
