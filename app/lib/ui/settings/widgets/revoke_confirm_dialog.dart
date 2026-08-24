import 'package:app/l10n/l10n.dart';
import 'package:app/pairing/storage.dart';
import 'package:app/ui/core/themes/themes.dart';
import 'package:flutter/material.dart';

/// Confirmation dialog shown before a peer is revoked. Returns true if the
/// user confirmed, false (or null) otherwise.
Future<bool> showRevokeConfirmDialog(
  BuildContext context, {
  required PeerRecord peer,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.colors.surface,
      title: Text(
        ctx.l10n.settingsRevokeTitle(peer.sessionName),
        style: TextStyle(color: ctx.colors.text),
      ),
      content: Text(
        ctx.l10n.settingsRevokeBody,
        style: TextStyle(color: ctx.colors.muted2),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            ctx.l10n.commonCancel,
            style: TextStyle(color: ctx.colors.muted2),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            ctx.l10n.settingsRevoke,
            style: TextStyle(color: ctx.colors.error),
          ),
        ),
      ],
    ),
  );
  return ok == true;
}
