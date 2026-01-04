// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/models/user_model.dart';
import 'package:tachkil/src/pages/delete_account_page.dart';
import 'package:tachkil/src/pages/login_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/users_queries.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController mdpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPassword = false;
  late bool activeReminder;
  late int userId;

  Future<UserModel> getUserInformations(int userId) async {
    UsersQueries usersQueries = UsersQueries();
    UserModel userModel = await usersQueries.select(null, null, userId, 2);
    return userModel;
  }

  @override
  void initState() {
    activeReminder = activeReminderNotifier.value;
    userId = userIdNotifier.value!;
    super.initState();
  }

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
          body: FutureBuilder(
            future: getUserInformations(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingWidget(activeDarkTheme);
              }

              UserModel userModel = snapshot.data!;
              usernameController.text = userModel.username;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                child: ListView(
                  children: [
                    Text(
                      "Mon compte",
                      style: GoogleFonts.anton(
                        color: mainColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),

                    SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nom d'utilisateur",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez renseigner un nom d'utilisateur";
                              }
                              return null;
                            },
                            controller: usernameController,
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              fillColor: Colors.black12,
                              filled: true,
                              hint: Text(
                                "Nom d'utilisateur",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              errorStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Mot de passe",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez renseigner un mot de passe";
                              }
                              return null;
                            },
                            obscureText: !showPassword,
                            obscuringCharacter: '*',
                            controller: mdpController,
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              errorStyle: GoogleFonts.openSans(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              fillColor: Colors.black12,
                              filled: true,
                              hint: Text(
                                "Mot de passe",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
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
                                if (_formKey.currentState!.validate()) {
                                  String username = usernameController.text;
                                  String password = mdpController.text;
                                  UsersQueries usersQueries = UsersQueries();
                                  try {
                                    await usersQueries.update(
                                      userId,
                                      username,
                                      password,
                                    );

                                    showMessage(
                                      context,
                                      "Vos données ont bien été modifiées",
                                      's',
                                    );

                                    navigatorBottomToTop(LoginPage(), context);
                                  } catch (e) {
                                    showMessage(
                                      context,
                                      "Nous avons rencontré une erreur",
                                      'e',
                                    );

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
                                      "Modifer",
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
                    SizedBox(height: 48),
                    Text(
                      "Paramétres",
                      style: GoogleFonts.anton(
                        color: mainColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Thème sombre",
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Switch(
                          activeThumbColor: whiteColor,
                          activeTrackColor: mainColor,
                          inactiveThumbColor: dartColor,
                          inactiveTrackColor: whiteColor,
                          value: activeDarkTheme,
                          onChanged: (value) async {
                            setState(() {
                              activeDarkTheme = value;
                            });
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.setBool("isDarkTheme", activeDarkTheme);
                            activeDarkThemeNotifier.value = activeDarkTheme;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Se souvenir de moi",
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Switch(
                          activeThumbColor: whiteColor,
                          activeTrackColor: mainColor,
                          inactiveThumbColor: activeDarkTheme
                              ? whiteColor
                              : dartColor,
                          inactiveTrackColor: activeDarkTheme
                              ? Colors.black12
                              : whiteColor,
                          value: activeReminder,
                          onChanged: (value) {
                            setState(() {
                              activeReminder = value;
                            });
                            activeReminderNotifier.value = activeReminder;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Divider(
                      thickness: 5,
                      radius: BorderRadius.circular(24),
                      color: mainColor,
                    ),
                    SizedBox(height: 24),
                    TextButton(
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.remove("isConnected");
                        preferences.remove("userId");

                        navigatorBottomToTop(LoginPage(), context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeDarkTheme
                            ? Colors.black12
                            : dartColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(24),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "DECONNEXION",
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        navigatorBottomToTop(DeleteAccountPage(), context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(24),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "SUPPRIMER LE COMPTE",
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
