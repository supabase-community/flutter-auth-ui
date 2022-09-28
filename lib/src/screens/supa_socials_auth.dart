import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';

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
    required this.iconData,
    required this.btnBgColor,
  });

  final IconData iconData;
  final Color btnBgColor;

  String get capitalizedName => name[0].toUpperCase() + name.substring(1);
}

class SupaSocialsAuth extends StatefulWidget {
  final List<SocialProviders> socialProviders;
  final bool colored;
  final String? redirectUrl;

  final void Function()? onSuccess;
  final bool Function(GoTrueException error)? onError;

  const SupaSocialsAuth({
    Key? key,
    required this.socialProviders,
    required this.colored,
    this.redirectUrl,
    this.onSuccess,
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
              providers[index].iconData,
              color: coloredBg ? Colors.white : Colors.black,
            ),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, 0),
              ),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              backgroundColor: MaterialStateProperty.all(
                  coloredBg ? providers[index].btnBgColor : null),
            ),
            onPressed: () async {
              try {
                await SupabaseAuthUi().socialSignIn(providers[index].name,
                    redirectUrl: widget.redirectUrl);
                widget.onSuccess?.call();
                if (mounted) {
                  successSnackBar(context, 'Successfully signed in !');
                }
              } on GoTrueException catch (error) {
                if (widget.onError == null ||
                    widget.onError?.call(error) == false) {
                  await warningSnackBar(context, error.message);
                }
              } catch (error) {
                await warningSnackBar(
                    context, 'Unexpected error has occurred: $error');
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
