import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Social provider that are supported
enum SocialProviders {
  apple(
    iconData: FontAwesomeIcons.apple,
    btnBgColor: Colors.black,
    provider: OAuthProvider.apple,
  ),
  azure(
    iconData: FontAwesomeIcons.microsoft,
    btnBgColor: Colors.blueAccent,
    provider: OAuthProvider.azure,
  ),
  bitbucket(
    iconData: FontAwesomeIcons.bitbucket,
    btnBgColor: Colors.blue,
    provider: OAuthProvider.bitbucket,
  ),
  discord(
    iconData: FontAwesomeIcons.discord,
    btnBgColor: Colors.purple,
    provider: OAuthProvider.discord,
  ),
  facebook(
    iconData: FontAwesomeIcons.facebook,
    btnBgColor: Color(0xFF3b5998),
    provider: OAuthProvider.facebook,
  ),
  github(
    iconData: FontAwesomeIcons.github,
    btnBgColor: Colors.black,
    provider: OAuthProvider.github,
  ),
  gitlab(
    iconData: FontAwesomeIcons.gitlab,
    btnBgColor: Colors.deepOrange,
    provider: OAuthProvider.gitlab,
  ),
  google(
    iconData: FontAwesomeIcons.google,
    btnBgColor: Colors.white,
    provider: OAuthProvider.google,
  ),
  slack(
    iconData: FontAwesomeIcons.slack,
    btnBgColor: Color.fromRGBO(74, 21, 75, 1),
    provider: OAuthProvider.slack,
  ),
  spotify(
    iconData: FontAwesomeIcons.spotify,
    btnBgColor: Colors.green,
    provider: OAuthProvider.spotify,
  ),
  twitch(
    iconData: FontAwesomeIcons.twitch,
    btnBgColor: Colors.purpleAccent,
    provider: OAuthProvider.twitch,
  ),
  x(
    iconData: FontAwesomeIcons.xTwitter,
    btnBgColor: Colors.black,
    provider: OAuthProvider.twitter,
  ),
  figma(
    iconData: FontAwesomeIcons.figma,
    btnBgColor: Color.fromRGBO(241, 77, 27, 1),
    provider: OAuthProvider.figma,
  ),
  notion(
    iconData: FontAwesomeIcons.x,
    btnBgColor: Color.fromRGBO(69, 75, 78, 1),
    provider: OAuthProvider.notion,
  ),
  kakao(
    iconData: FontAwesomeIcons.kaaba,
    btnBgColor: Colors.black,
    provider: OAuthProvider.kakao,
  ),
  keycloak(
    iconData: FontAwesomeIcons.xTwitter,
    btnBgColor: Color.fromRGBO(0, 138, 170, 1),
    provider: OAuthProvider.keycloak,
  ),
  workOS(
    iconData: FontAwesomeIcons.xTwitter,
    btnBgColor: Color.fromRGBO(99, 99, 241, 1),
    provider: OAuthProvider.workos,
  ),
  linkedIn(
    iconData: FontAwesomeIcons.linkedin,
    btnBgColor: Color.fromRGBO(0, 136, 209, 1),
    provider: OAuthProvider.linkedin,
  );

  const SocialProviders({
    required IconData iconData,
    required Color btnBgColor,
    required this.provider,
  })  : _iconData = iconData,
        _btnBgColor = btnBgColor;

  final IconData _iconData;
  final Color _btnBgColor;
  final OAuthProvider provider;

  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
}

enum SocialButtonVariant {
  /// Displays the social login buttons horizontally with icons.
  icon,

  /// Displays the social login buttons vertically with icons and text labels.
  iconAndText,
}

/// UI Component to create social login form
class SupaSocialsAuth extends StatefulWidget {
  /// List of social providers to show in the form
  final List<SocialProviders> socialProviders;

  /// Whether or not to color the social buttons in their respecful colors
  ///
  /// You can control the appearance through `ElevatedButtonTheme` when set to false.
  final bool colored;

  /// Whether or not to show the icon only or icon and text
  final SocialButtonVariant socialButtonVariant;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function(Session) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Whether to show a SnackBar after a successful sign in
  final bool showSuccessSnackBar;

  const SupaSocialsAuth({
    Key? key,
    required this.socialProviders,
    this.colored = true,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
    this.socialButtonVariant = SocialButtonVariant.iconAndText,
    this.showSuccessSnackBar = true,
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
        if (widget.showSuccessSnackBar) {
          context.showSnackBar('Successfully signed in!');
        }
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

    final authButtons = List.generate(
      providers.length,
      (index) {
        final socialProvider = providers[index];

        Color? foregroundColor = coloredBg ? Colors.white : null;
        Color? backgroundColor = coloredBg ? socialProvider._btnBgColor : null;
        Color? overlayColor = coloredBg ? Colors.white10 : null;

        Color? iconColor = coloredBg ? Colors.white : null;

        Widget iconWidget = SizedBox(
          height: 48,
          width: 48,
          child: Icon(
            socialProvider._iconData,
            color: iconColor,
          ),
        );
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

        switch (socialProvider) {
          case SocialProviders.notion:
            iconWidget = Image.asset(
              'assets/logos/notion.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case SocialProviders.kakao:
            iconWidget = Image.asset(
              'assets/logos/kakao.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case SocialProviders.keycloak:
            iconWidget = Image.asset(
              'assets/logos/keycloak.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case SocialProviders.workOS:
            iconWidget = Image.asset(
              'assets/logos/workOS.png',
              package: 'supabase_auth_ui',
              color: coloredBg ? Colors.white : null,
              width: 48,
              height: 48,
            );
            break;
          default:
            // Handle other cases or provide a default behavior.
            break;
        }

        onAuthButtonPressed() async {
          try {
            await supabase.auth.signInWithOAuth(
              socialProvider.provider,
              redirectTo: widget.redirectUrl,
            );
          } on AuthException catch (error) {
            if (widget.onError == null && context.mounted) {
              context.showErrorSnackBar(error.message);
            } else {
              widget.onError?.call(error);
            }
          } catch (error) {
            if (widget.onError == null && context.mounted) {
              context
                  .showErrorSnackBar('Unexpected error has occurred: $error');
            } else {
              widget.onError?.call(error);
            }
          }
        }

        final authButtonStyle = ButtonStyle(
          foregroundColor: MaterialStateProperty.all(foregroundColor),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          overlayColor: MaterialStateProperty.all(overlayColor),
          iconColor: MaterialStateProperty.all(iconColor),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: widget.socialButtonVariant == SocialButtonVariant.icon
              ? Material(
                  shape: const CircleBorder(),
                  elevation: 2,
                  color: backgroundColor,
                  child: InkResponse(
                    radius: 24,
                    onTap: onAuthButtonPressed,
                    child: iconWidget,
                  ),
                )
              : ElevatedButton.icon(
                  icon: iconWidget,
                  style: authButtonStyle,
                  onPressed: onAuthButtonPressed,
                  label:
                      Text('Continue with ${socialProvider.capitalizedName}'),
                ),
        );
      },
    );

    return widget.socialButtonVariant == SocialButtonVariant.icon
        ? Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: authButtons,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: authButtons,
          );
  }
}
