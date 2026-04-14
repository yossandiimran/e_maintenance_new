import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:e_maintenance/widget/TextStyling.dart';

class Alert {
  const Alert._();

  static void showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, isError: false);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, isError: true);
  }

  static void _showSnackBar(BuildContext context, String message, {required bool isError}) {
    if (!context.mounted) {
      return;
    }

    final tokens = context.tokens;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? tokens.danger : tokens.surfaceElevated,
        ),
      );
  }

  static Future<void> showMessage({
    required BuildContext context,
    required String title,
    required String message,
    bool isError = false,
  }) {
    final tokens = context.tokens;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            message,
            style: dialogContext.textTheme.bodyMedium?.copyWith(color: tokens.textSecondary),
          ),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: isError ? tokens.danger : tokens.brand,
              ),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Batal',
    bool destructive = false,
  }) async {
    final tokens = context.tokens;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: destructive ? tokens.danger : tokens.brand,
              ),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  static Future<T> runWithLoading<T>({
    required BuildContext context,
    required Future<T> Function() task,
    String message = 'Mohon tunggu...',
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              ),
              const SizedBox(width: 18),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );

    try {
      return await task();
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  static Future<void> confirmExit(BuildContext context) async {
    final confirmed = await confirm(
      context: context,
      title: 'Keluar dari aplikasi?',
      message: 'Aktivitas saat ini akan ditutup di perangkat ini.',
      confirmLabel: 'Keluar',
      destructive: true,
    );

    if (confirmed) {
      await SystemNavigator.pop();
    }
  }
}
