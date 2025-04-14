// 📁 supa_avatar.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:supabase_auth_ui/src/components/supa_avatar/widgets/supa_avatar_modal.dart';
import 'package:supabase_auth_ui/src/components/supa_avatar/widgets/supa_user_avatar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';


class SupaAvatar extends StatefulWidget {
  const SupaAvatar({
    super.key,
    this.radius = 40,
    this.isEditable = false,
    this.cacheBuster,
    this.modalShape,
    this.modalBackgroundColor,
    this.supabaseStorageBucket = 'avatars',
    this.supabaseStoragePath = 'profile',
    this.fallbackIcon = const Icon(Icons.person),
    this.snackBarBackgroundColor,
    this.snackBarTextColor,
    this.snackBarErrorBackgroundColor,
    this.snackBarErrorTextColor,
    this.snackBarDuration,
    this.supabaseUserAttributeImageUrlKey = 'avatar_url',
  });

  final double radius;
  final bool isEditable;
  final String? cacheBuster;
  final ShapeBorder? modalShape;
  final Color? modalBackgroundColor;
  final String supabaseStorageBucket;
  final String supabaseStoragePath;
  final Widget fallbackIcon;
  final Color? snackBarBackgroundColor;
  final Color? snackBarTextColor;
  final Color? snackBarErrorBackgroundColor;
  final Color? snackBarErrorTextColor;
  final Duration? snackBarDuration;
  final String supabaseUserAttributeImageUrlKey;

  @override
  State<SupaAvatar> createState() => _SupaAvatarEditorState();
}

class _SupaAvatarEditorState extends State<SupaAvatar> {
  late String _cacheBuster;
  bool _isLoading = false;
  File? _lastAvatarFile;

  final user = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _cacheBuster =
        widget.cacheBuster ?? DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _handleAvatarEdit(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: widget.modalBackgroundColor,
      shape:
          widget.modalShape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
      builder:
          (_) => SupaAvatarModal(
            cacheBuster: _cacheBuster,
            supabaseStorageBucket: widget.supabaseStorageBucket,
            supabaseStoragePath: widget.supabaseStoragePath,
            supabaseUserAttributeImageUrlKey:
                widget.supabaseUserAttributeImageUrlKey,
            fallbackIcon: widget.fallbackIcon,
            radius: widget.radius,
          ),
    );

    if (result == null || user == null) return;

    final file = result['file'] as File?;
    final remove = result['remove'] == true;

    setState(() => _isLoading = true);

    try {
      if (remove) {
        await _removeAvatar(user!.id);
        _lastAvatarFile = null;
        _showSnackbar(context, 'Avatar removed successfully');
      } else if (file != null) {
        await _uploadAvatar(file, user!.id);
        _lastAvatarFile = file;
        _showSnackbar(context, 'Avatar updated successfully');
      }

      setState(() {
        _cacheBuster = DateTime.now().millisecondsSinceEpoch.toString();
      });
    } catch (e) {
      _showSnackbar(context, 'Something went wrong 😢', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    final bgColor =
        isError
            ? widget.snackBarErrorBackgroundColor ??
                theme.colorScheme.errorContainer
            : widget.snackBarBackgroundColor ??
                theme.colorScheme.secondaryContainer;
    final textColor =
        isError
            ? widget.snackBarErrorTextColor ??
                theme.colorScheme.onErrorContainer
            : widget.snackBarTextColor ??
                theme.colorScheme.onSecondaryContainer;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        duration: widget.snackBarDuration ?? const Duration(milliseconds: 4000),
        content: Text(message, style: TextStyle(color: textColor)),
      ),
    );
  }

  Future<void> _uploadAvatar(File file, String userId) async {
    final fileBytes = await file.readAsBytes();
    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final storagePath = '$userId/${widget.supabaseStoragePath}';

    await Supabase.instance.client.storage
        .from(widget.supabaseStorageBucket)
        .uploadBinary(
          storagePath,
          fileBytes,
          fileOptions: FileOptions(upsert: true, contentType: mimeType),
        );

    final publicUrl = Supabase.instance.client.storage
        .from(widget.supabaseStorageBucket)
        .getPublicUrl(storagePath);

    await Supabase.instance.client.auth.updateUser(
      UserAttributes(
        data: {widget.supabaseUserAttributeImageUrlKey: publicUrl},
      ),
    );
  }

  Future<void> _removeAvatar(String userId) async {
    final bucket = Supabase.instance.client.storage.from(
      widget.supabaseStorageBucket,
    );

    final files = await bucket.list(path: userId);
    for (final file in files) {
      await bucket.remove(['$userId/${file.name}']);
    }

    await Supabase.instance.client.auth.updateUser(
      UserAttributes(data: {widget.supabaseUserAttributeImageUrlKey: null}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarWidget =
        _lastAvatarFile != null
            ? CircleAvatar(
              radius: widget.radius,
              backgroundImage: FileImage(_lastAvatarFile!),
            )
            : SupaUserAvatar(
              radius: widget.radius,
              cacheBuster: _cacheBuster,
              key: ValueKey(_cacheBuster),
              fallbackIcon: widget.fallbackIcon,
              supabaseStorageBucket: widget.supabaseStorageBucket,
              supabaseStoragePath: widget.supabaseStoragePath,
              supabaseUserAttributeImageUrlKey:
                  widget.supabaseUserAttributeImageUrlKey,
            );
    return GestureDetector(
      onTap:
          widget.isEditable
              ? _isLoading
                  ? null
                  : () => _handleAvatarEdit(context)
              : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          avatarWidget,
          if (_isLoading)
            Container(
              width: widget.radius * 2,
              height: widget.radius * 2,
              decoration: BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }
}
