import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension on OAuthProvider {
  IconData get iconData => switch (this) {
        OAuthProvider.apple => FontAwesomeIcons.apple,
        OAuthProvider.azure => FontAwesomeIcons.microsoft,
        OAuthProvider.bitbucket => FontAwesomeIcons.bitbucket,
        OAuthProvider.discord => FontAwesomeIcons.discord,
        OAuthProvider.facebook => FontAwesomeIcons.facebook,
        OAuthProvider.figma => FontAwesomeIcons.figma,
        OAuthProvider.github => FontAwesomeIcons.github,
        OAuthProvider.gitlab => FontAwesomeIcons.gitlab,
        OAuthProvider.google => FontAwesomeIcons.google,
        OAuthProvider.linkedin => FontAwesomeIcons.linkedin,
        OAuthProvider.slack => FontAwesomeIcons.slack,
        OAuthProvider.spotify => FontAwesomeIcons.spotify,
        OAuthProvider.twitch => FontAwesomeIcons.twitch,
        OAuthProvider.twitter => FontAwesomeIcons.xTwitter,
        _ => Icons.close,
      };

  Color get btnBgColor => switch (this) {
        OAuthProvider.apple => Colors.black,
        OAuthProvider.azure => Colors.blueAccent,
        OAuthProvider.bitbucket => Colors.blue,
        OAuthProvider.discord => Colors.purple,
        OAuthProvider.facebook => const Color(0xFF3b5998),
        OAuthProvider.figma => const Color.fromRGBO(241, 77, 27, 1),
        OAuthProvider.github => Colors.black,
        OAuthProvider.gitlab => Colors.deepOrange,
        OAuthProvider.google => Colors.white,
        OAuthProvider.kakao => const Color(0xFFFFE812),
        OAuthProvider.keycloak => const Color.fromRGBO(0, 138, 170, 1),
        OAuthProvider.linkedin => const Color.fromRGBO(0, 136, 209, 1),
        OAuthProvider.notion => const Color.fromRGBO(69, 75, 78, 1),
        OAuthProvider.slack => const Color.fromRGBO(74, 21, 75, 1),
        OAuthProvider.spotify => Colors.green,
        OAuthProvider.twitch => Colors.purpleAccent,
        OAuthProvider.twitter => Colors.black,
        OAuthProvider.workos => const Color.fromRGBO(99, 99, 241, 1),
        // ignore: unreachable_switch_case
        _ => Colors.black,
      };

  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
}

enum SocialButtonVariant {
  /// Displays the social login buttons horizontally with icons.
  icon,

  /// Displays the social login buttons vertically with icons and text labels.
  iconAndText,
}

class NativeGoogleAuthConfig {
  /// Web Client ID and iOS Client ID that you registered with Google Cloud.
  /// Needed for Sign in with Google
  final String webClientId;
  final String iosClientId;

  NativeGoogleAuthConfig(
      {required this.webClientId, required this.iosClientId});
}

/// UI Component to create social login form
class SupaSocialsAuth extends StatefulWidget {
  /// Defines native google provider to show in the form
  final NativeGoogleAuthConfig? nativeGoogleAuthConfig;

  /// Defines apple provider
  final bool enableNativeAppleAuth;

  /// List of social providers to show in the form
  final List<OAuthProvider> socialProviders;

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
    this.nativeGoogleAuthConfig,
    this.enableNativeAppleAuth = true,
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

  /// Performs Google sign in on Android and iOS
  Future<AuthResponse> _googleSignIn(webClientId, iosClientId) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  /// Performs Apple sign in on iOS or macOS
  Future<AuthResponse> _appleSignIn() async {
    final rawNonce = supabase.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  Widget _nativeAuthBtn(
      {required Widget icon,
      required String label,
      Color? bgColor,
      Color? textColor,
      required Future Function() signInMethod}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: widget.socialButtonVariant == SocialButtonVariant.icon
          ? Material(
              shape: const CircleBorder(),
              elevation: 2,
              color: bgColor,
              child: InkResponse(
                radius: 24,
                onTap: () async {
                  try {
                    await signInMethod();
                  } on AuthException catch (error) {
                    if (widget.onError == null && context.mounted) {
                      context.showErrorSnackBar(error.message);
                    } else {
                      widget.onError?.call(error);
                    }
                  } catch (error) {
                    if (widget.onError == null && context.mounted) {
                      context.showErrorSnackBar(
                          'Unexpected error has occurred: $error');
                    } else {
                      widget.onError?.call(error);
                    }
                  }
                },
                child: SizedBox(height: 48, width: 48, child: icon),
              ),
            )
          : ElevatedButton.icon(
              onPressed: () async {
                try {
                  await signInMethod();
                } on AuthException catch (error) {
                  if (widget.onError == null && context.mounted) {
                    context.showErrorSnackBar(error.message);
                  } else {
                    widget.onError?.call(error);
                  }
                } catch (error) {
                  if (widget.onError == null && context.mounted) {
                    context.showErrorSnackBar(
                        'Unexpected error has occurred: $error');
                  } else {
                    widget.onError?.call(error);
                  }
                }
              },
              icon: icon,
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: textColor,
              ),
            ),
    );
  }

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
    final googleAuthConfig = widget.nativeGoogleAuthConfig;
    final isAppleAuth = widget.enableNativeAppleAuth == true;
    final coloredBg = widget.colored == true;

    if (providers.isEmpty) {
      return ErrorWidget(Exception('Social provider list cannot be empty'));
    }

    final authButtons = List.generate(
      providers.length,
      (index) {
        final socialProvider = providers[index];

        Color? foregroundColor = coloredBg ? Colors.white : null;
        Color? backgroundColor = coloredBg ? socialProvider.btnBgColor : null;
        Color? overlayColor = coloredBg ? Colors.white10 : null;

        Color? iconColor = coloredBg ? Colors.white : null;

        Widget iconWidget = SizedBox(
          height: 48,
          width: 48,
          child: Icon(
            socialProvider.iconData,
            color: iconColor,
          ),
        );
        if (socialProvider == OAuthProvider.google && coloredBg) {
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
          case OAuthProvider.notion:
            iconWidget = Image.asset(
              'assets/logos/notion.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case OAuthProvider.kakao:
            iconWidget = Image.asset(
              'assets/logos/kakao.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case OAuthProvider.keycloak:
            iconWidget = Image.asset(
              'assets/logos/keycloak.png',
              package: 'supabase_auth_ui',
              width: 48,
              height: 48,
            );
            break;
          case OAuthProvider.workos:
            iconWidget = Image.asset(
              'assets/logos/workOS.png',
              package: 'supabase_auth_ui',
              color: coloredBg ? Colors.white : null,
              width: 48,
              height: 48,
            );
            break;
          default:
            break;
        }

        onAuthButtonPressed() async {
          try {
            await supabase.auth.signInWithOAuth(
              socialProvider,
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
            children: [
              if (googleAuthConfig != null)
                _nativeAuthBtn(
                  icon: Image.asset(
                    'assets/logos/google_light.png',
                    package: 'supabase_auth_ui',
                    width: 48,
                    height: 48,
                  ),
                  label: 'Sign in with Google',
                  signInMethod: () => _googleSignIn(
                    googleAuthConfig!.webClientId,
                    googleAuthConfig.iosClientId,
                  ),
                  bgColor: const Color.fromRGBO(242, 242, 242, 1),
                  textColor: Colors.black,
                ),
              if (isAppleAuth)
                _nativeAuthBtn(
                  icon: const Icon(
                    FontAwesomeIcons.apple,
                    color: Colors.white,
                  ),
                  label: 'Sign in with Apple',
                  signInMethod: _appleSignIn,
                  bgColor: Colors.black,
                  textColor: Colors.white,
                ),
              ...authButtons,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (googleAuthConfig != null)
                _nativeAuthBtn(
                  icon: Image.asset(
                    'assets/logos/google_light.png',
                    package: 'supabase_auth_ui',
                    width: 48,
                    height: 48,
                  ),
                  label: 'Sign in with Google',
                  signInMethod: () => _googleSignIn(
                    googleAuthConfig!.webClientId,
                    googleAuthConfig.iosClientId,
                  ),
                  bgColor: const Color.fromRGBO(242, 242, 242, 1),
                  textColor: Colors.black,
                ),
              if (isAppleAuth)
                _nativeAuthBtn(
                  icon: const Icon(
                    FontAwesomeIcons.apple,
                  ),
                  label: 'Sign in with Apple',
                  signInMethod: _appleSignIn,
                  bgColor: Colors.black,
                  textColor: Colors.white,
                ),
              ...authButtons,
            ],
          );
  }
}
