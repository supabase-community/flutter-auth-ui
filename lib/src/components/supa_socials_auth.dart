import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';

/// Social provider that are supported
enum SocialProviders {
  apple(
    iconData: FontAwesomeIcons.apple,
    btnBgColor: Colors.black,
    provider: Provider.apple,
  ),
  azure(
    iconData: FontAwesomeIcons.microsoft,
    btnBgColor: Colors.blueAccent,
    provider: Provider.azure,
  ),
  bitbucket(
    iconData: FontAwesomeIcons.bitbucket,
    btnBgColor: Colors.blue,
    provider: Provider.bitbucket,
  ),
  discord(
    iconData: FontAwesomeIcons.discord,
    btnBgColor: Colors.purple,
    provider: Provider.discord,
  ),
  facebook(
    iconData: FontAwesomeIcons.facebook,
    btnBgColor: Color(0xFF3b5998),
    provider: Provider.facebook,
  ),
  github(
    iconData: FontAwesomeIcons.github,
    btnBgColor: Colors.black,
    provider: Provider.github,
  ),
  gitlab(
    iconData: FontAwesomeIcons.gitlab,
    btnBgColor: Colors.deepOrange,
    provider: Provider.gitlab,
  ),
  google(
    iconData: FontAwesomeIcons.google,
    btnBgColor: Colors.white,
    provider: Provider.google,
  ),
  slack(
    iconData: FontAwesomeIcons.slack,
    btnBgColor: Colors.deepPurple,
    provider: Provider.slack,
  ),
  spotify(
    iconData: FontAwesomeIcons.spotify,
    btnBgColor: Colors.green,
    provider: Provider.spotify,
  ),
  twitch(
    iconData: FontAwesomeIcons.twitch,
    btnBgColor: Colors.purpleAccent,
    provider: Provider.twitch,
  ),
  twitter(
    iconData: FontAwesomeIcons.twitter,
    btnBgColor: Color(0xFF1DA1F2),
    provider: Provider.twitter,
  );

  const SocialProviders({
    required IconData iconData,
    required Color btnBgColor,
    required this.provider,
  })  : _iconData = iconData,
        _btnBgColor = btnBgColor;

  final IconData _iconData;
  final Color _btnBgColor;
  final Provider provider;

  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
}

/// UI Component to create social login form
class SupaSocialsAuth extends StatefulWidget {
  /// List of social providers to show in the form
  final List<SocialProviders> socialProviders;

  /// Whether or not to color the social buttons in their respecful colors
  ///
  /// You can control the appearance through `ElevatedButtonTheme` when set to false.
  final bool colored;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(Session) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  const SupaSocialsAuth({
    Key? key,
    required this.socialProviders,
    this.colored = true,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<SupaSocialsAuth> createState() => _SupaSocialsAuthState();
}

class _SupaSocialsAuthState extends State<SupaSocialsAuth> {
  late final StreamSubscription<AuthState> _gotrueSubscription;

  @override
  void initState() {
    super.initState();
    _gotrueSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && mounted) {
        widget.onSuccess.call(session);
        context.showSnackBar('Successfully signed in !');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gotrueSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final providers = widget.socialProviders;
    final coloredBg = widget.colored == true;

    if (providers.isEmpty) {
      return ErrorWidget(Exception('Social provider list cannot be empty'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        providers.length,
        (index) {
          final socialProvider = providers[index];

          Widget iconWidget = SizedBox(
            height: 48,
            width: 48,
            child: Icon(socialProvider._iconData),
          );

          Color? foregroundColor =
              coloredBg ? Theme.of(context).colorScheme.onBackground : null;
          Color? backgroundColor =
              coloredBg ? socialProvider._btnBgColor : null;
          Color? overlayColor = coloredBg ? Colors.white10 : null;

          Color? iconColor =
              coloredBg ? Theme.of(context).colorScheme.onBackground : null;

          if (socialProvider == SocialProviders.google && coloredBg) {
            iconWidget = Image.asset(
              'assets/logos/google_light.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );

            foregroundColor = Colors.black;
            backgroundColor = Colors.white;
            overlayColor = Colors.white;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: iconWidget,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(foregroundColor),
                backgroundColor: MaterialStateProperty.all(backgroundColor),
                overlayColor: MaterialStatePropertyAll(overlayColor),
                iconColor: MaterialStatePropertyAll(iconColor),
              ),
              onPressed: () async {
                try {
                  await supaClient.auth.signInWithOAuth(
                    socialProvider.provider,
                    redirectTo: widget.redirectUrl,
                  );
                } on AuthException catch (error) {
                  if (widget.onError == null) {
                    context.showErrorSnackBar(error.message);
                  } else {
                    widget.onError?.call(error);
                  }
                } catch (error) {
                  if (widget.onError == null) {
                    context.showErrorSnackBar(
                        'Unexpected error has occurred: $error');
                  } else {
                    widget.onError?.call(error);
                  }
                }
              },
              label: Text('Continue with ${socialProvider.capitalizedName}'),
            ),
          );
        },
      ),
    );
  }
}
