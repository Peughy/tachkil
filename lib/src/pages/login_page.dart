// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/models/user_model.dart';
import 'package:tachkil/src/pages/forget_password_page.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/pages/register_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/users_queries.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mdpController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  late bool activeReminder;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    activeReminder = activeReminderNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeDarkThemeNotifier,
      builder: (context, activeDarkTheme, child) {
        return Scaffold(
          backgroundColor: activeDarkTheme ? dartColor : whiteColor,
          appBar: AppBar(
            backgroundColor: activeDarkTheme ? dartColor : whiteColor,
            leading: AppBar(
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
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Connexion.",
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
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
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
                        obscureText: !showPassword,
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            icon: FaIcon(
                              showPassword
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 20,
                              color: activeDarkTheme ? whiteColor : dartColor,
                            ),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            navigatorBottomToTop(ForgetPasswordPage(), context);
                          },
                          child: Text(
                            "Mot de passe oublié",
                            style: GoogleFonts.openSans(
                              color: activeDarkTheme ? whiteColor : dartColor,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: whiteColor,
                            activeColor: mainColor,
                            value: activeReminder,
                            onChanged: (value) {
                              setState(() {
                                activeReminder = value ?? false;
                              });
                              activeReminderNotifier.value = activeReminder;
                            },
                          ),
                          Text(
                            "Se souvenir de moi",
                            style: GoogleFonts.openSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              // find user data
                              String username = usernameController.text;
                              String password = mdpController.text;

                              UsersQueries usersQueries = UsersQueries();

                              /*
                                  for mode
                                  1 -> for login by username and password
                                  2 -> for select user by userId
                              */

                              try {
                                UserModel userModel = await usersQueries.select(
                                  username,
                                  password,
                                  null,
                                  1,
                                );

                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();

                                // if the user not active the reminder case all the time he must connected
                                if (activeReminder) {
                                  preferences.setBool("isReminder", true);
                                  activeReminderNotifier.value = true;
                                }

                                // partialy stock the information
                                preferences.setBool("isConnected", true);
                                preferences.setInt("userId", userModel.userId);
                                userIdNotifier.value = userModel.userId;
                                activeReminderNotifier.value = false;

                                // redirect
                                navigatorBottomToTop(HomePage(), context);
                              } catch (e) {
                                if (e.toString().contains(
                                  "Null check operator",
                                )) {
                                  showMessage(
                                    context,
                                    "Identifiants incorrects, aucun compte touvé",
                                    'w',
                                  );

                                  setState(() {
                                    isLoading = false;
                                  });
                                } else {
                                  showMessage(
                                    context,
                                    "Une erreur est survenue, veuillez réessayer",
                                    'e',
                                  );

                                  setState(() {
                                    isLoading = false;
                                  });
                                }

                                debugPrint("[ERROR] $e");
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
                                  "Connexion",
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
                          navigatorBottomToTop(RegisterPage(), context);
                        },
                        child: Text(
                          "Inscription",
                          style: GoogleFonts.openSans(
                            color: activeDarkTheme ? whiteColor : dartColor,
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
      },
    );
  }
}
