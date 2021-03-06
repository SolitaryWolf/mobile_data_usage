import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_data_usage/widgets/app_loading.dart';
import 'package:provider/provider.dart';

/// *
/// Install:
/// Declare provider to my_app
/// Provider(create: (_) => AppLoadingProvider()),
///
/// Usage:
/// context.read<AppLoadingProvider>().showLoading(context);
/// or
/// AppLoadingProvider.show(context);
///
/// context.read<AppLoadingProvider>().hideLoading();
/// or
/// AppLoadingProvider.hide(context);
///
class AppLoadingProvider {
  AppLoadingProvider();

  BuildContext _dialogContext;
  bool requestClose = false;

  static void show(BuildContext context) {
    context.read<AppLoadingProvider>().showLoading(context);
  }

  static void hide(BuildContext context) {
    context.read<AppLoadingProvider>().hideLoading();
  }

  Future<void> showLoading(BuildContext context) async {
    hideLoading(isClean: true);
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext dialogContext) {
        _dialogContext = dialogContext;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (requestClose) {
            hideLoading();
          }
        });
        return AppLoading();
      },
    );
  }

  void hideLoading({bool isClean = false}) {
    if (_dialogContext != null) {
      if (Navigator.canPop(_dialogContext)) {
        Navigator.pop(_dialogContext);
      }
      _dialogContext = null;
    }
    requestClose = !isClean;
  }
}
