// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/tasks_queries.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  DateTime datetimeController = DateTime.now();
  TextEditingController dateTextController = TextEditingController();

  bool isLoading = false;
  late int userId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    dateTextController.text =
        "${addZeros(datetimeController.day)} ${displayMonth(datetimeController.month)} ${datetimeController.year} ${addZeros(datetimeController.hour)}:${addZeros(datetimeController.minute)}";
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
            automaticallyImplyLeading: false,
            backgroundColor: activeDarkTheme ? dartColor : whiteColor,
            surfaceTintColor: Colors.transparent,
            title: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 20),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: ListView(
              children: [
                Text(
                  "Ajouter une tache",
                  style: GoogleFonts.openSans(
                    fontSize: 22,
                    color: mainColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez ajouter un titre";
                          }
                          return null;
                        },
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        controller: titleController,
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.openSans(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          fillColor: Colors.black12,
                          filled: true,
                          hint: Text(
                            "Titre",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
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
                      SizedBox(height: 18),
                      TextFormField(
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          hint: Text(
                            "Description",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
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
                      SizedBox(height: 18),
                      TextFormField(
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        controller: locationController,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          hint: Row(
                            spacing: 8,
                            children: [
                              FaIcon(FontAwesomeIcons.locationDot, size: 20),
                              Text(
                                "Lieu",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
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
                        ),
                      ),
                      SizedBox(height: 18),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez choisir une date";
                          }
                          return null;
                        },
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        controller: dateTextController,
                        onTap: () {
                          DatePicker.showDateTimePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2030),
                            onConfirm: (date) {
                              setState(() {
                                datetimeController = date;
                                dateTextController.text =
                                    "${addZeros(datetimeController.day)} ${displayMonth(datetimeController.month)} ${datetimeController.year} ${addZeros(datetimeController.hour)}:${addZeros(datetimeController.minute)}";
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.fr,
                          );
                        },
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.openSans(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          fillColor: Colors.black12,
                          filled: true,
                          hint: Row(
                            spacing: 8,
                            children: [
                              FaIcon(FontAwesomeIcons.calendar, size: 20),
                              Text(
                                "Date",
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
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
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              // initialiaze the data
                              String title = titleController.text;
                              String? description = descriptionController.text;
                              String? location = locationController.text;

                              TasksQueries tasksQueries = TasksQueries();

                              // generate the random number
                              Random rand = Random();
                              int taskId = rand.nextInt(9999) + 1111;

                              try {
                                await tasksQueries.insert(
                                  TaskModel(
                                    taskId: taskId,
                                    title: title,
                                    description: description,
                                    location: location,
                                    date: datetimeController,
                                    statut: 0,
                                    userId: userId,
                                  ),
                                );

                                showMessage(
                                  context,
                                  "La tache a bien été ajouté",
                                  's',
                                );

                                navigatorBottomToTop(HomePage(), context);
                              } on DatabaseException catch (e) {
                                showMessage(
                                  context,
                                  "La tache existe déjà",
                                  'e',
                                );

                                setState(() {
                                  isLoading = false;
                                });

                                debugPrint("[ERROR] $e");
                              } catch (e) {
                                showMessage(
                                  context,
                                  "Nous avons rencontré une erreur",
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
                                  "AJOUTER",
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
