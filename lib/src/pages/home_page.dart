import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/pages/account_page.dart';
import 'package:tachkil/src/pages/add_task_page.dart';
import 'package:tachkil/src/pages/tasks_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// this param is used for filter the task statut
int tabSelectedIndex = 1;
late int userId;

DateTime datefilter = DateTime.now();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    userId = userIdNotifier.value!;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeDarkThemeNotifier,
      builder: (context, activeDarkTheme, child) {
        return Scaffold(
          backgroundColor: activeDarkTheme ? dartColor : whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: activeDarkTheme ? dartColor : whiteColor,
            surfaceTintColor: Colors.transparent,
            title: Text.rich(
              TextSpan(
                text: "tach",
                style: GoogleFonts.anton(
                  fontSize: 36,
                  color: activeDarkTheme ? Colors.white : dartColor,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: "kil",
                    style: GoogleFonts.anton(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 24),
                child: Row(
                  spacing: 12,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(8),
                      onPressed: () {
                        navigatorBottomToTop(AccountPage(), context);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black12,
                      ),
                      icon: FaIcon(FontAwesomeIcons.solidUser, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: tabSelectedIndex == 1
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        DateTime tempDate = datefilter;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                return AlertDialog(
                                  title: Text(
                                    'Filtrer les tâches',
                                    style: GoogleFonts.anton(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 14),
                                        // Quick select buttons (Hier, Aujourd'hui, Demain)
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  datefilter = DateTime.now()
                                                      .subtract(
                                                        Duration(days: 1),
                                                      );
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: activeDarkTheme
                                                      ? Colors.black54
                                                      : Colors.white54,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'Hier',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  datefilter = DateTime.now();
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: activeDarkTheme
                                                      ? Colors.black54
                                                      : Colors.white54,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),

                                                child: Text(
                                                  'Aujourd\'hui',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  datefilter = DateTime.now()
                                                      .add(Duration(days: 1));
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: activeDarkTheme
                                                      ? Colors.black54
                                                      : Colors.white54,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),

                                                child: Text(
                                                  'Demain',
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 32),
                                        Text(
                                          'Ou choisissez une date specifique.',
                                          style: GoogleFonts.openSans(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        // Date picker with scrollable day, month, year
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Day Picker
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Jour',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: ListWheelScrollView.useDelegate(
                                                      onSelectedItemChanged:
                                                          (index) {
                                                            setDialogState(() {
                                                              tempDate =
                                                                  DateTime(
                                                                    tempDate
                                                                        .year,
                                                                    tempDate
                                                                        .month,
                                                                    index + 1,
                                                                  );
                                                            });
                                                          },
                                                      itemExtent: 50,
                                                      childDelegate: ListWheelChildBuilderDelegate(
                                                        builder: (context, index) {
                                                          index =
                                                              tempDate.day - 1;
                                                          if (index > 30) {
                                                            return null;
                                                          }
                                                          return Center(
                                                            child: Text(
                                                              (index + 1)
                                                                  .toString()
                                                                  .padLeft(
                                                                    2,
                                                                    '0',
                                                                  ),
                                                              style: GoogleFonts.openSans(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        childCount: 31,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            // Month Picker
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Mois',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: ListWheelScrollView.useDelegate(
                                                      onSelectedItemChanged:
                                                          (index) {
                                                            setDialogState(() {
                                                              tempDate =
                                                                  DateTime(
                                                                    tempDate
                                                                        .year,
                                                                    index + 1,
                                                                    tempDate
                                                                        .day,
                                                                  );
                                                            });
                                                          },
                                                      itemExtent: 50,
                                                      childDelegate: ListWheelChildBuilderDelegate(
                                                        builder: (context, index) {
                                                          index =
                                                              tempDate.month -
                                                              1;
                                                          if (index > 11) {
                                                            return null;
                                                          }
                                                          return Center(
                                                            child: Text(
                                                              displayMonth(
                                                                index + 1,
                                                              ),
                                                              style: GoogleFonts.openSans(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        childCount: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            // Year Picker
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Année',
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: ListWheelScrollView.useDelegate(
                                                      onSelectedItemChanged:
                                                          (index) {
                                                            setDialogState(() {
                                                              tempDate =
                                                                  DateTime(
                                                                    1900 +
                                                                        index,
                                                                    tempDate
                                                                        .month,
                                                                    tempDate
                                                                        .day,
                                                                  );
                                                            });
                                                          },
                                                      itemExtent: 50,
                                                      childDelegate: ListWheelChildBuilderDelegate(
                                                        builder: (context, index) {
                                                          index =
                                                              tempDate.year -
                                                              1900;

                                                          return Center(
                                                            child: Text(
                                                              (1900 + index)
                                                                  .toString(),
                                                              style: GoogleFonts.openSans(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        childCount: 200,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 32),
                                        // Action buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 12,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Supprimer',
                                                style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  datefilter = DateTime.now();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: mainColor,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Valider',
                                                style: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  datefilter = tempDate;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      backgroundColor: activeDarkTheme
                          ? Colors.black
                          : Colors.white,
                      child: FaIcon(
                        FontAwesomeIcons.sliders,
                        size: 22,
                        color: activeDarkTheme ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    FloatingActionButton.extended(
                      onPressed: () {
                        navigatorBottomToTop(AddTaskPage(), context);
                      },
                      label: Text(
                        "Ajouter une tache",
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: whiteColor,
                        ),
                      ),
                      backgroundColor: mainColor,
                      icon: FaIcon(
                        FontAwesomeIcons.plus,
                        size: 18,
                        color: whiteColor,
                      ),
                    ),
                  ],
                )
              : null,
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                tabSelectedIndex = index;
              });
            },
            backgroundColor: activeDarkTheme ? Colors.black26 : Colors.white24,
            elevation: 12,
            indicatorColor: mainColor,
            surfaceTintColor: Colors.transparent,
            selectedIndex: tabSelectedIndex,
            labelTextStyle: WidgetStatePropertyAll(
              GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            destinations: [
              NavigationDestination(
                selectedIcon: FaIcon(
                  FontAwesomeIcons.bullseye,
                  color: whiteColor,
                ),
                icon: FaIcon(FontAwesomeIcons.bullseye),
                label: "Objectifs",
              ),
              NavigationDestination(
                selectedIcon: FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: whiteColor,
                ),
                icon: FaIcon(FontAwesomeIcons.listCheck),
                label: "Tâches",
              ),
            ],
          ),
          body: <Widget>[
            // GoalsPage(activeDarkTheme: activeDarkTheme),
            Center(
              child: Text(
                "Page des objectifs en cours de développement...",
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: activeDarkTheme ? Colors.white : dartColor,
                ),
              ),
            ),
            TasksPage(activeDarkTheme: activeDarkTheme),
          ][tabSelectedIndex],
        );
      },
    );
  }
}
