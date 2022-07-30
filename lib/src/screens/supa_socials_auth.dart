import 'package:flutter/material.dart';

enum SocialProviders { google, twitter }

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
    return Expanded(
      child: ListView.builder(
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
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              backgroundColor: MaterialStateProperty.all(
                  coloredBg ? Colors.redAccent : null),
            ),
            onPressed: () {},
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
