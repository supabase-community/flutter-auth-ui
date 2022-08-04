import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/supabase_auth_ui.dart';

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

  const SupaSocialsAuth({
    Key? key,
    required this.socialProviders,
    required this.colored,
  }) : super(key: key);

  @override
  State<SupaSocialsAuth> createState() => _SupaSocialsAuthState();
}

class _SupaSocialsAuthState extends State<SupaSocialsAuth> {
  @override
  Widget build(BuildContext context) {
    final providers = widget.socialProviders;
    final coloredBg = widget.colored == true;
    final emptyList = providers.isEmpty;
    return emptyList
        ? ErrorWidget(Exception('Social provider list cannot be empty'))
        : Column(
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
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all(
                        coloredBg ? providers[index].btnBgColor : null),
                  ),
                  onPressed: () {
                    SupabaseAuthUi().socialSignIn(providers[index].name);
                  },
                  label: Text(
                    'Sign in with ${providers[index].capitalizedName}',
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
