import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:ui_avatar/ui_avatar.dart';

class SupaUserAvatar extends StatelessWidget {
  const SupaUserAvatar({
    super.key,
    this.radius = 32,
    this.fallbackIcon = const Icon(Icons.person),
    this.cacheBuster,
    this.supabaseStorageBucket = 'avatars',
    this.supabaseStoragePath = 'profile',
    this.supabaseUserAttributeImageUrlKey = 'avatar_url',
  });

  final double radius;
  final Widget fallbackIcon;
  final String? cacheBuster;
  final String supabaseStorageBucket;
  final String supabaseStoragePath;
  final String supabaseUserAttributeImageUrlKey;

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return CircleAvatar(radius: radius, child: fallbackIcon);
    }

    final avatarUrl = user.userMetadata?[supabaseUserAttributeImageUrlKey] as String?;
    if (avatarUrl != null && avatarUrl.startsWith('http')) {
      final bustedUrl = _appendCacheBuster(avatarUrl);
      return CircleAvatar(
        radius: radius,
        foregroundImage: NetworkImage(bustedUrl),
        child: _buildUiAvatar(user),
      );
    }

    final publicUrl = Supabase.instance.client.storage
        .from(supabaseStorageBucket)
        .getPublicUrl('${user.id}/$supabaseStoragePath');

    final bustedUrl = _appendCacheBuster(publicUrl);
    return CircleAvatar(
      radius: radius,
      foregroundImage: NetworkImage(bustedUrl),
      child: _buildUiAvatar(user),
    );
  }

  String _appendCacheBuster(String url) {
    if (cacheBuster == null) return url;
    return '$url?cb=$cacheBuster';
  }

  Widget _buildUiAvatar(User user) {
    final name = user.userMetadata?['username'] ?? user.email ?? '';
    if (name.isNotEmpty) {
      return UiAvatar(name: name, size: radius * 2, useRandomColors: true,);
    }
    return fallbackIcon;
  }
}
