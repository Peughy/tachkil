import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/pages/login_page.dart';
import 'package:tachkil/src/pages/register_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeDarkThemeNotifier,
      builder: (context, activeDarkTheme, child) {
        return Scaffold(
          backgroundColor: activeDarkTheme ? dartColor : whiteColor,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(
                      activeDarkTheme
                          ? "assets/logo/logo-dart-no-bg.png"
                          : "assets/logo/logo-white-no-bg.png",
                    ),
                    width: 250,
                  ),
                  Column(
                    spacing: 18,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            navigatorBottomToTop(LoginPage(), context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            backgroundColor: activeDarkTheme
                                ? whiteColor
                                : dartColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(12),
                            ),
                          ),
                          child: Text(
                            "Connexion".toUpperCase(),
                            style: GoogleFonts.openSans(
                              fontSize: 22,
                              color: activeDarkTheme ? dartColor :  whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            navigatorBottomToTop(RegisterPage(), context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(12),
                            backgroundColor: mainColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(12),
                            ),
                          ),
                          child: Text(
                            "Inscription".toUpperCase(),
                            style: GoogleFonts.openSans(
                              fontSize: 22,
                              color: whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
