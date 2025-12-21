import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/action_button_model.dart';
import 'package:tachkil/src/utils/constant.dart';

class ActionButtonWidget extends StatelessWidget {
  final ActionButtonModel actionButtonModel;
  const ActionButtonWidget({super.key, required this.actionButtonModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: dartColor,
          width: actionButtonModel.isSelected ? 1.5 : 1,
        ),
        color: actionButtonModel.isSelected
            ? Colors.red[200]
            : Colors.transparent,
      ),
      child: Text(
        actionButtonModel.text,
        style: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: actionButtonModel.isSelected
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }
}
