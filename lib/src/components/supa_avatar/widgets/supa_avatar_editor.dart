// 📁 supa_avatar_modal.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_auth_ui/src/components/supa_avatar/widgets/supa_user_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ui_avatar/ui_avatar.dart';

class SupaAvatarEditor extends StatefulWidget {
  final String? cacheBuster;
  final String supabaseStorageBucket;
  final String supabaseStoragePath;
  final String supabaseUserAttributeImageUrlKey;
  final Widget fallbackIcon;
  final double radius;
  final User? user;

  const SupaAvatarEditor({
    super.key,
    this.cacheBuster,
    required this.supabaseStorageBucket,
    required this.supabaseStoragePath,
    required this.supabaseUserAttributeImageUrlKey,
    required this.fallbackIcon,
    required this.radius,
    this.user,
  });

  @override
  State<SupaAvatarEditor> createState() => _SupaAvatarModalState();
}

class _SupaAvatarModalState extends State<SupaAvatarEditor> {
  File? _localImageFile;
  bool _removeRequested = false;
  final _picker = ImagePicker();

  void _removeImage() {
    if (_localImageFile == null && _removeRequested) return;
    setState(() {
      _localImageFile = null;
      _removeRequested = true;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;
    setState(() {
      _localImageFile = File(picked.path);
      _removeRequested = false;
    });
  }

  void _onSaveChanges() {
    Navigator.of(
      context,
    ).pop({'file': _localImageFile, 'remove': _removeRequested});
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isChanged = _removeRequested || _localImageFile != null;
    final String name =
        widget.user?.userMetadata?['username'] ?? widget.user?.email ?? '';

    final avatar = _localImageFile != null
        ? CircleAvatar(
            radius: widget.radius,
            backgroundImage: FileImage(_localImageFile!),
          )
        : _removeRequested
            ? name.isNotEmpty
                ? UiAvatar(
                    name: name,
                    size: widget.radius * 2,
                    useRandomColors: true,
                  )
                : CircleAvatar(
                    radius: widget.radius, child: widget.fallbackIcon)
            : SupaUserAvatar(
                radius: widget.radius,
                cacheBuster: widget.cacheBuster,
                fallbackIcon: widget.fallbackIcon,
                supabaseStorageBucket: widget.supabaseStorageBucket,
                supabaseStoragePath: widget.supabaseStoragePath,
                supabaseUserAttributeImageUrlKey:
                    widget.supabaseUserAttributeImageUrlKey,
              );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        
        children: [
          const Text(
            "Update User Avatar",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          avatar,
          const SizedBox(height: 24),
          ListTile(
            onTap: () => _pickImage(ImageSource.gallery),
            leading: const Icon(Icons.photo),
            title: const Text("Choose from gallery"),
          ),
          ListTile(
            onTap: () => _pickImage(ImageSource.camera),
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take photo"),
          ),
          
          ListTile(
            onTap: (_localImageFile == null && _removeRequested)
                ? null
                : _removeImage,
            leading: Icon(Icons.delete, color: theme.colorScheme.error),
            title: Text(
              "Remove avatar",
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
         
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: isChanged ? _onSaveChanges : null,
              child: const Text(
                "Save changes",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
