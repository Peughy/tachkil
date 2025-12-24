import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/utils/constant.dart';

// this function is used to add 0 on number when the number < 10
// input 9 -> output 09
// input 11 -> output 11
String addZeros(int nbr) {
  return nbr < 10 ? '0$nbr' : "$nbr";
}

// this function for search the month
String displayMonth(int month) {
  List<String> months = [
    'Jan',
    'Fev',
    'Mar',
    'Avr',
    'Mai',
    'Jui',
    'Juil',
    'Au',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

void navigatorBottomToTop(Widget page, BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnnimation, child: child);
      },
    ),
  );
}

/*

  code for message intention
  - w : warning (orange)
  - s : succes (green)
  - e : error (red)

*/

void showMessage(BuildContext context, String message, String intention) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: (intention == 'w')
          ? Colors.amber
          : (intention == 's')
          ? Colors.green
          : Colors.red,
      duration: Duration(seconds: 3),
      content: Text(
        message,
        style: GoogleFonts.openSans(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: (intention == 'w') ? dartColor : whiteColor,
        ),
      ),
    ),
  );
}

// fin user id

Future<int?> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int? userId = preferences.getInt("userId");
  return userId;
}

Widget loadingWidget(bool activeDarkTheme) {
  return Padding(
    padding: const EdgeInsets.only(top: 48.0),
    child: Column(
      spacing: 12,
      children: [
        Image(
          image: AssetImage(
            activeDarkTheme
                ? "assets/logo/logo-dart-no-bg.png"
                : "assets/logo/logo-white-no-bg.png",
          ),
          width: 100,
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              "Chargement",
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Transform.scale(
              scale: 0.5,
              child: CircularProgressIndicator(
                color: activeDarkTheme ? whiteColor : dartColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
