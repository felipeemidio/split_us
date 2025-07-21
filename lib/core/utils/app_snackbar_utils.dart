import 'package:flutter/material.dart';

class AppSnackbarUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> error(
    BuildContext context, {
    required String message,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.errorContainer),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> info(
    BuildContext context, {
    required String message,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.primaryContainer),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
