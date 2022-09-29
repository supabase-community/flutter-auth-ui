import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';

/// Social provider that are supported
enum SocialProviders {
  apple(iconData: FontAwesomeIcons.apple, btnBgColor: Colors.black),
  azure(iconData: FontAwesomeIcons.microsoft, btnBgColor: Colors.blueAccent),
  bitbucket(iconData: FontAwesomeIcons.bitbucket, btnBgColor: Colors.blue),
  discord(iconData: FontAwesomeIcons.discord, btnBgColor: Colors.purple),
  facebook(iconData: FontAwesomeIcons.facebook, btnBgColor: Colors.blue),
  github(iconData: FontAwesomeIcons.github, btnBgColor: Colors.black),
  gitlab(iconData: FontAwesomeIcons.gitlab, btnBgColor: Colors.deepOrange),
  google(iconData: FontAwesomeIcons.google, btnBgColor: Colors.red),
  slack(iconData: FontAwesomeIcons.slack, btnBgColor: Colors.deepPurple),
  spotify(iconData: FontAwesomeIcons.spotify, btnBgColor: Colors.green),
  twitch(iconData: FontAwesomeIcons.twitch, btnBgColor: Colors.purpleAccent),
  twitter(iconData: FontAwesomeIcons.twitter, btnBgColor: Colors.lightBlue);

  const SocialProviders({
    required IconData iconData,
    required Color btnBgColor,
  })  : _iconData = iconData,
        _btnBgColor = btnBgColor;

  final IconData _iconData;
  final Color _btnBgColor;

  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
}

/// UI Component to create social login form
class SupaSocialsAuth extends StatefulWidget {
  /// List of social providers to show in the form
  final List<SocialProviders> socialProviders;

  /// Whether or not to color the social buttons in their respecful colors
  final bool colored;

  /// `redirectUrl` to be passed to the `.signIn()` or `signUp()` methods
  ///
  /// Typically used to pass a DeepLink
  final String? redirectUrl;

  /// Method to be called when the auth action is success
  final void Function() onSuccess;

  /// Method to be called when the auth action threw an excepction
  final bool Function(GoTrueException error)? onError;

  const SupaSocialsAuth({
    Key? key,
    required this.socialProviders,
    required this.colored,
    this.redirectUrl,
    required this.onSuccess,
    this.onError,
  }) : super(key: key);

  @override
  State<SupaSocialsAuth> createState() => _SupaSocialsAuthState();
}

class _SupaSocialsAuthState extends State<SupaSocialsAuth> {
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
        (index) => Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: OutlinedButton.icon(
            icon: Icon(
              providers[index]._iconData,
              color: coloredBg ? Colors.white : Colors.black,
            ),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 0),
              ),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              backgroundColor: MaterialStateProperty.all(
                  coloredBg ? providers[index]._btnBgColor : null),
            ),
            onPressed: () async {
              try {
                await SupabaseAuthUi().socialSignIn(providers[index].name,
                    redirectUrl: widget.redirectUrl);
                widget.onSuccess.call();
                if (mounted) {
                  context.showSnackBar('Successfully signed in !');
                }
              } on GoTrueException catch (error) {
                if (widget.onError == null ||
                    widget.onError?.call(error) == false) {
                  context.showErrorSnackBar(error.message);
                }
              } catch (error) {
                context
                    .showErrorSnackBar('Unexpected error has occurred: $error');
              }
            },
            label: Text(
              'Continue with ${providers[index].capitalizedName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: coloredBg ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
