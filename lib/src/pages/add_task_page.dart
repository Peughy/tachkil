// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tachkil/src/models/priority_button_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/tasks_queries.dart';
import 'package:tachkil/src/widgets/priority_button_widget.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Priority buttons
  List<PriorityButtonModel> priorityButtons = [
    PriorityButtonModel(
      text: "Élevé",
      isSelected: true,
      priority: Priority.high,
    ),
    PriorityButtonModel(
      text: "Moyenne",
      isSelected: false,
      priority: Priority.medium,
    ),
    PriorityButtonModel(
      text: "Basse",
      isSelected: false,
      priority: Priority.low,
    ),
  ];

  // selected color for task
  Color selectedColor = Colors.blue;
  Priority selectedPriority = Priority.high;

  bool isLoading = false;
  late int userId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
                        maxLines: 3,
                        minLines: 2,
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
                        minLines: 10,
                        maxLines: 15,
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        controller: descriptionController,
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
                      Text(
                        "Priorité",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(priorityButtons.length, (
                            idx,
                          ) {
                            return Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (var priorityButton
                                        in priorityButtons) {
                                      priorityButton.isSelected = false;
                                    }
                                    priorityButtons[idx].isSelected = true;
                                    selectedPriority =
                                        priorityButtons[idx].priority;
                                  });
                                },
                                child: PriorityButtonWidget(
                                  priorityButtonModel: priorityButtons[idx],
                                  activeDarkTheme: activeDarkTheme,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: 24),
                      Text(
                        "Couleur",
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            [
                              Colors.red,
                              Colors.orange,
                              Colors.amber,
                              Colors.yellow,
                              Colors.lime,
                              Colors.green,
                              Colors.lightGreen,
                              Colors.teal,
                              Colors.cyan,
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.indigo,
                              Colors.indigoAccent,
                              Colors.deepPurple,
                              Colors.purple,
                              Colors.pink,
                              Colors.deepOrange,
                              Colors.brown,
                              Colors.grey,
                              Colors.blueGrey,
                            ].map((color) {
                              final isSelected = color == selectedColor;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColor = color;
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: activeDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                            width: 5,
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 42),
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

                              // initialize the data
                              String title = titleController.text;
                              String? description = descriptionController.text;

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
                                    color: selectedColor.toARGB32(),
                                    priority: selectedPriority,
                                    date: DateTime.now(),
                                    statut: 0,
                                    userId: userId,
                                  ),
                                );

                                showMessage(
                                  context,
                                  "La tache a bien été ajouté",
                                  's',
                                );

                                navigatorRemplacementBottomToTop(HomePage(), context);
                              } on DatabaseException catch (e) {
                                if (e.toString().contains(
                                  "UNIQUE constraint failed",
                                )) {
                                  showMessage(
                                    context,
                                    "La tache existe déjà",
                                    'e',
                                  );
                                } else {
                                  showMessage(
                                    context,
                                    "Nous avons rencontré une erreur",
                                    'e',
                                  );
                                }

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
