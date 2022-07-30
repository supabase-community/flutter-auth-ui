import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  @override
  Widget build(BuildContext context) {
    final coloredBg = widget.colored == true;
    final emptyList = widget.socialProviders.isEmpty;
    return Expanded(
      child: emptyList
          ? ErrorWidget(Exception('Social provider list cannot be empty'))
          : ListView.builder(
              itemCount: widget.socialProviders.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.youtube_searched_for,
                    color: coloredBg ? Colors.white : null,
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 0),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all(
                        coloredBg ? Colors.redAccent : null),
                  ),
                  onPressed: () {
                    SupabaseAuthUi().socialSignIn(widget.socialProviders[index].toString());
                  },
                  label: Text(
                    widget.socialProviders[index].toString(),
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
