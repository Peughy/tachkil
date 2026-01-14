// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/priority_button_model.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/tasks_queries.dart';
import 'package:tachkil/src/widgets/priority_button_widget.dart';

class ManageTask extends StatefulWidget {
  final TaskModel taskModel;
  const ManageTask({super.key, required this.taskModel});

  @override
  State<ManageTask> createState() => _ManageTaskState();
}

class _ManageTaskState extends State<ManageTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Color> colorsLists = [
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
  ];

  // Priority buttons
  late List<PriorityButtonModel> priorityButtons;

  // selected color for task
  late Color selectedColor;
  late Priority selectedPriority;

  final _formKey = GlobalKey<FormState>();

  // variable for accept the editable
  bool isEditable = false;
  bool isEditLoading = false;
  bool isFinishLoading = false;

  TasksQueries tasksQueries = TasksQueries();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.taskModel.title;
    if (widget.taskModel.description != null) {
      descriptionController.text = widget.taskModel.description!;
    }

    selectedPriority = widget.taskModel.priority;
    priorityButtons = [
      PriorityButtonModel(
        text: "Haute",
        isSelected: widget.taskModel.priority == Priority.high ? true : false,
        priority: Priority.high,
      ),
      PriorityButtonModel(
        text: "Moyenne",
        isSelected: widget.taskModel.priority == Priority.medium ? true : false,
        priority: Priority.medium,
      ),
      PriorityButtonModel(
        text: "Basse",
        isSelected: widget.taskModel.priority == Priority.low ? true : false,
        priority: Priority.low,
      ),
    ];

    for (Color color in colorsLists) {
      if (color.toARGB32() == widget.taskModel.color) {
        selectedColor = color;
        break;
      }
    }
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: activeDarkTheme
                        ? Colors.white12
                        : Colors.black12,
                  ),
                  onPressed: () async {
                    TasksQueries tasksQueries = TasksQueries();

                    // generate the random number
                    Random rand = Random();
                    int taskId = rand.nextInt(9999) + 1111;

                    await tasksQueries.insert(
                      widget.taskModel.copyWithTask(
                        taskId: taskId,
                        date: DateTime.now(),
                        taskModel: widget.taskModel,
                      ),
                    );

                    showMessage(
                      context,
                      "La tache a bien été ajouté pour aujourd'hui",
                      's',
                    );

                    navigatorRemplacementBottomToTop(HomePage(), context);
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.calendarDay,
                    size: 22,
                    color: activeDarkTheme ? whiteColor : dartColor,
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: ListView(
                  children: [
                    Text(
                      widget.taskModel.title,
                      style: GoogleFonts.anton(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
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
                            readOnly: isEditable ? false : true,
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
                                borderRadius: isEditable
                                    ? BorderRadius.circular(24)
                                    : BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: isEditable
                                    ? BorderRadius.circular(24)
                                    : BorderRadius.circular(8),
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
                            readOnly: isEditable ? false : true,
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            controller: descriptionController,
                            minLines: isEditable ? 8 : 12,
                            maxLines: 15,
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
                                borderRadius: isEditable
                                    ? BorderRadius.circular(24)
                                    : BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: isEditable
                                    ? BorderRadius.circular(24)
                                    : BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: isEditable
                                    ? BorderRadius.circular(24)
                                    : BorderRadius.circular(8),
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
                                      if (isEditable) {
                                        setState(() {
                                          for (var priorityButton
                                              in priorityButtons) {
                                            priorityButton.isSelected = false;
                                          }
                                          priorityButtons[idx].isSelected =
                                              true;
                                          selectedPriority =
                                              priorityButtons[idx].priority;
                                        });
                                      }
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

                          isEditable
                              ? Column(
                                  children: [
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
                                      children: colorsLists.map((color) {
                                        final isSelected =
                                            color == selectedColor;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isEditable) {
                                                selectedColor = color;
                                              }
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
                                  ],
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 42),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: isEditable
                    ? Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditable = false;
                                });
                              },
                              child: Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.xmark,
                                    size: 24,
                                    color: mainColor,
                                  ),
                                  Text(
                                    "Annuler",
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.all(18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isEditLoading = true;
                                  });

                                  // initialiaze the data
                                  String title = titleController.text;
                                  String? description =
                                      descriptionController.text;

                                  try {
                                    TaskModel newTask = TaskModel(
                                      taskId: widget.taskModel.taskId,
                                      title: title,
                                      description: description,
                                      color: selectedColor.toARGB32(),
                                      priority: selectedPriority,
                                      date: widget.taskModel.date,
                                      statut: widget.taskModel.statut,
                                      userId: userId,
                                    );
                                    await tasksQueries.update(newTask);

                                    showMessage(
                                      context,
                                      "La tache a bien été modifié",
                                      's',
                                    );

                                    navigatorBottomToTop(HomePage(), context);
                                  } catch (e) {
                                    showMessage(
                                      context,
                                      "Nous avons rencontré une erreur",
                                      'e',
                                    );

                                    setState(() {
                                      isEditLoading = false;
                                    });

                                    debugPrint("[ERROR] $e");
                                  }
                                }
                              },
                              child: Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isEditLoading
                                      ? Transform.scale(
                                          scale: 0.5,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : FaIcon(
                                          FontAwesomeIcons.check,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                  Text(
                                    "Modifer",
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditable = true;
                                });
                              },
                              child: Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.pen,
                                    size: 24,
                                    color: mainColor,
                                  ),
                                  Text(
                                    "Modifier",
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // if the task is end (statut = 1) show de no finish button else (statut = 0) show the finish button
                          // if the task is late (statut -1) no display the finish btn
                          (widget.taskModel.statut == -1)
                              ? SizedBox.shrink()
                              : Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          (widget.taskModel.statut == 1)
                                          ? Colors.black
                                          : Colors.green,
                                      padding: EdgeInsets.all(18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (widget.taskModel.statut == 0) {
                                        await tasksQueries.tooggleStatut(
                                          widget.taskModel.taskId,
                                          1,
                                        );

                                        // when the task is updated, user is redirect in the home page
                                        navigatorBottomToTop(
                                          HomePage(),
                                          context,
                                        );
                                      } else {
                                        await tasksQueries.tooggleStatut(
                                          widget.taskModel.taskId,
                                          0,
                                        );

                                        // when the task is updated, user is redirect in the home page
                                        navigatorBottomToTop(
                                          HomePage(),
                                          context,
                                        );
                                      }
                                    },
                                    child: Column(
                                      spacing: 12,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        isFinishLoading
                                            ? Transform.scale(
                                                scale: 0.5,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : FaIcon(
                                                (widget.taskModel.statut == 1)
                                                    ? FontAwesomeIcons.ban
                                                    : FontAwesomeIcons.check,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                        FittedBox(
                                          child: Text(
                                            (widget.taskModel.statut == 1)
                                                ? "Non terminer"
                                                : "Terminer",
                                            style: GoogleFonts.openSans(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.all(18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await tasksQueries.delete(
                                    widget.taskModel.taskId,
                                  );

                                  showMessage(
                                    context,
                                    "La tache a bien été supprimé",
                                    's',
                                  );

                                  navigatorBottomToTop(HomePage(), context);
                                } catch (e) {
                                  showMessage(
                                    context,
                                    "Nous avons rencontré une erreur",
                                    'e',
                                  );

                                  debugPrint("[ERROR] $e");
                                }
                              },
                              child: Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.trash,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  FittedBox(
                                    child: Text(
                                      "Supprimer",
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
