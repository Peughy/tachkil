import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/pages/login_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mdpController = TextEditingController();
  TextEditingController confirmMdpController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Inscription.",
              style: GoogleFonts.anton(
                fontSize: 36,
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez ajouter un nom d'utilisateur";
                      }
                      return null;
                    },
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    controller: usernameController,
                    decoration: InputDecoration(
                      errorStyle: GoogleFonts.openSans(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      fillColor: Colors.black12,
                      filled: true,
                      hint: Row(
                        spacing: 12,
                        children: [
                          FaIcon(FontAwesomeIcons.solidUser, size: 20),
                          Text(
                            "Nom d'utilisateur",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
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
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez ajouter un mot de passe";
                      }
                      return null;
                    },
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    controller: mdpController,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      errorStyle: GoogleFonts.openSans(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      fillColor: Colors.black12,
                      filled: true,
                      hint: Row(
                        spacing: 12,
                        children: [
                          FaIcon(FontAwesomeIcons.lock, size: 22),
                          Text(
                            "Mot de passe",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
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
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez ajouter un mot de passe";
                      }
                      return null;
                    },
                    style: GoogleFonts.openSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    controller: confirmMdpController,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      errorStyle: GoogleFonts.openSans(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                      fillColor: Colors.black12,
                      filled: true,
                      hint: Row(
                        spacing: 12,
                        children: [
                          FaIcon(FontAwesomeIcons.lock, size: 22),
                          Text(
                            "Confirmation",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
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
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(24),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
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
                              "Inscription",
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      navigatorBottomToTop(LoginPage(), context);
                    },
                    child: Text(
                      "Connexion",
                      style: GoogleFonts.openSans(
                        color: dartColor,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
