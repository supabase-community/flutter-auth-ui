import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/supabase_auth_ui.dart';

enum SocialProviders {
  apple,
  azure,
  bitbucket,
  discord,
  facebook,
  github,
  gitlab,
  google,
  slack,
  spotify,
  twitch,
  twitter
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
  capitalizeName(String providerName) {
    return providerName[0].toUpperCase() + providerName.substring(1);
  }

  getIcon(String providerName) {
    if (providerName == 'apple') return FontAwesomeIcons.apple;
    if (providerName == 'azure') return FontAwesomeIcons.microsoft;
    if (providerName == 'bitbucket') return FontAwesomeIcons.bitbucket;
    if (providerName == 'discord') return FontAwesomeIcons.discord;
    if (providerName == 'facebook') return FontAwesomeIcons.facebook;
    if (providerName == 'github') return FontAwesomeIcons.github;
    if (providerName == 'gitlab') return FontAwesomeIcons.gitlab;
    if (providerName == 'google') return FontAwesomeIcons.google;
    if (providerName == 'slack') return FontAwesomeIcons.slack;
    if (providerName == 'spotify') return FontAwesomeIcons.spotify;
    if (providerName == 'twitch') return FontAwesomeIcons.twitch;
    if (providerName == 'twitter') return FontAwesomeIcons.twitter;
  }

  getBtnBgColor(String providerName) {
    if (providerName == 'apple') return Colors.black;
    if (providerName == 'azure') return Colors.blueAccent;
    if (providerName == 'bitbucket') return Colors.blue;
    if (providerName == 'discord') return Colors.purple;
    if (providerName == 'facebook') return Colors.blue;
    if (providerName == 'github') return Colors.black;
    if (providerName == 'gitlab') return Colors.deepOrange;
    if (providerName == 'google') return Colors.red;
    if (providerName == 'slack') return Colors.deepPurple;
    if (providerName == 'spotify') return Colors.green;
    if (providerName == 'twitch') return Colors.purpleAccent;
    if (providerName == 'twitter') return Colors.lightBlue;
  }

  @override
  Widget build(BuildContext context) {
    final providers = widget.socialProviders;
    final coloredBg = widget.colored == true;
    final emptyList = providers.isEmpty;
    return Expanded(
      child: emptyList
          ? ErrorWidget(Exception('Social provider list cannot be empty'))
          : ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: OutlinedButton.icon(
                  icon: Icon(
                    getIcon(providers[index].name),
                    // icon,
                    color: coloredBg ? Colors.white : Colors.black,
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 0),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all(coloredBg
                        ? getBtnBgColor(providers[index].name)
                        : null),
                  ),
                  onPressed: () {
                    SupabaseAuthUi().socialSignIn(providers[index].name);
                  },
                  label: Text(
                    'Sign In With ${capitalizeName(providers[index].name)}',
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
