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
    final icon = isError ? Icons.error_outline_rounded : Icons.check_circle_rounded;
    final color = isError ? tokens.danger : tokens.success;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: tokens.surfaceElevated,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
    final color = isError ? tokens.danger : tokens.brand;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isError ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
              color: color,
              size: 24,
            ),
          ),
          title: Text(title),
          content: Text(
            message,
            style: dialogContext.textTheme.bodyMedium?.copyWith(color: tokens.textSecondary),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: isError ? tokens.danger : tokens.brand,
                ),
                child: const Text('Tutup'),
              ),
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
    final accentColor = destructive ? tokens.danger : tokens.brand;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              destructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
              color: accentColor,
              size: 24,
            ),
          ),
          title: Text(title),
          content: Text(message, textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(cancelLabel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                    child: Text(confirmLabel),
                  ),
                ),
              ],
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
        final tokens = dialogContext.tokens;
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: <Widget>[
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.2, color: tokens.brand),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    message,
                    style: dialogContext.textTheme.bodyMedium?.copyWith(color: tokens.textSecondary),
                  ),
                ),
              ],
            ),
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
