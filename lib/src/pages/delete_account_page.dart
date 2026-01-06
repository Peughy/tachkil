// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/models/user_model.dart';
import 'package:tachkil/src/pages/welcome_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/users_queries.dart';

class DeleteAccountPage extends StatefulWidget {
  final UserModel userModel;
  const DeleteAccountPage({super.key, required this.userModel});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeDarkThemeNotifier,
      builder: (context, activeDarkTheme, child) {
        return Scaffold(
          backgroundColor: activeDarkTheme ? dartColor : whiteColor,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: activeDarkTheme ? dartColor : whiteColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
                size: 22,
                color: activeDarkTheme ? whiteColor : dartColor,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsetsGeometry.all(24),
            child: ListView(
              children: [
                Text(
                  "Suppression compte",
                  style: GoogleFonts.anton(
                    color: mainColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FaIcon(FontAwesomeIcons.circleInfo, size: 18),
                    Expanded(
                      child: Text(
                        "La suppression du compte est irrévocable, une fois supprimé vous ne pouvez plus le récupérer et toutes vos données seront perdues",
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                Text(
                  "Veuillez entrer votre nom d'utilisateur tel qu'il est écrit",
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    enableInteractiveSelection: false,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != widget.userModel.username) {
                        return "Mauvais nom d'utilisateur";
                      }
                      return null;
                    },
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      fillColor: Colors.black12,
                      filled: true,
                      hint: Text(
                        "Saisissez \"${widget.userModel.username}\"",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      errorStyle: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.red,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(width: 1.5, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: EdgeInsets.all(12),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        UsersQueries userQueries = UsersQueries();
                        int userId = widget.userModel.userId;

                        try {
                          await userQueries.delete(userId);

                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.remove("isConnected");
                          preferences.remove("userId");

                          setState(() {
                            isLoading = false;
                          });

                          navigatorRemplacementBottomToTop(
                            WelcomePage(),
                            context,
                          );
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });

                          showMessage(
                            context,
                            "Une erreur est survenue lors de la suppression du compte",
                            'e',
                          );
                        }
                      }
                    },
                    child: isLoading
                        ? Row(
                            spacing: 12,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Chargement",
                                style: GoogleFonts.openSans(
                                  color: whiteColor,
                                  fontSize: 20,
                                ),
                              ),
                              Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "SUPPRIMER MON COMPTE",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
