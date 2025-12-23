import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool activeDark = activeDarkThemeNotifier.value;
    return Scaffold(
      backgroundColor: activeDark ? dartColor : whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            Image.asset(
              activeDark
                  ? "assets/logo/logo-dart-no-bg.png"
                  : "assets/logo/logo-white-no-bg.png",
              width: 200,
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                Text("Chargement", style: GoogleFonts.openSans(fontSize: 22)),
                Transform.scale(
                  scale: 0.5,
                  child: CircularProgressIndicator(
                    color: activeDark ? whiteColor : dartColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
