import 'package:flutter/material.dart';

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
