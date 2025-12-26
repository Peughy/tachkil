// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/user_model.dart';
import 'package:tachkil/src/pages/login_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/users_queries.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mdpController = TextEditingController();
  TextEditingController confirmMdpController = TextEditingController();
  bool isLoading = false;

  bool usernameFind = false;
  UsersQueries usersQueries = UsersQueries();

  final _formKeyUsername = GlobalKey<FormState>();
  final _formKeyMdp = GlobalKey<FormState>();

  late UserModel userModel;

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
            padding: EdgeInsets.all(24),
            child: ListView(
              children: [
                Text(
                  "Recupération du compte",
                  style: GoogleFonts.anton(fontSize: 36, color: mainColor),
                ),
                SizedBox(height: 42),
                !usernameFind
                    ? Form(
                        key: _formKeyUsername,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Entrez nom d'utilisateur",
                              style: GoogleFonts.openSans(fontSize: 18),
                            ),
                            SizedBox(height: 12),
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
                                    FaIcon(
                                      FontAwesomeIcons.solidUser,
                                      size: 20,
                                    ),
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
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
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
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  if (_formKeyUsername.currentState!
                                      .validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    String username = usernameController.text;

                                    try {
                                      /*

                                      for mode
                                      1 -> for login by username and password
                                      2 -> for select user by userId
                                      3 -> for select by username

                                      */

                                      userModel = await usersQueries.select(
                                        username,
                                        null,
                                        null,
                                        3,
                                      );

                                      setState(() {
                                        usernameFind = true;
                                        isLoading = false;
                                      });
                                    } catch (e) {
                                      showMessage(
                                        context,
                                        "Aucun compte assoié avec ce nom d'utilisateur",
                                        'e',
                                      );

                                      setState(() {
                                        isLoading = false;
                                      });

                                      debugPrint("[ERROR] $e");
                                    }
                                  }
                                },
                                child: isLoading
                                    ? Row(
                                        spacing: 12,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                        "Connexion",
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
                      )
                    :
                      // if the username is find display the mdp textfield
                      Form(
                        key: _formKeyMdp,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nouveau mot de passe",
                              style: GoogleFonts.openSans(fontSize: 18),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez ajouter un mot de passe";
                                }
                                if (value.length < 4) {
                                  return "Le mot de pase doit avoir au moins 4 caracters!";
                                }
                                if (value != confirmMdpController.text) {
                                  return "Les mots de passent de correspondent pas";
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
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              "Confirmation",
                              style: GoogleFonts.openSans(fontSize: 18),
                            ),
                            SizedBox(height: 24),
                            TextFormField(
                              enableInteractiveSelection: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Veuillez ajouter un mot de passe";
                                }

                                if (value != mdpController.text) {
                                  return "Les mots de passent de correspondent pas";
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
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
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
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  if (_formKeyMdp.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    String password = mdpController.text;
                                    try {
                                      await usersQueries.update(
                                        userModel.userId,
                                        userModel.username,
                                        password,
                                      );

                                      showMessage(
                                        context,
                                        "Le mot de passe a bien été modifé",
                                        's',
                                      );

                                      navigatorBottomToTop(
                                        LoginPage(),
                                        context,
                                      );
                                    } catch (e) {
                                      showMessage(
                                        context,
                                        "Nous avons rencontré une erreur",
                                        'e',
                                      );

                                      setState(() {
                                        isLoading = true;
                                      });
                                    }
                                  }
                                },
                                child: isLoading
                                    ? Row(
                                        spacing: 12,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                        "Modifier",
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
              ],
            ),
          ),
        );
      },
    );
  }
}
