// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/tasks_queries.dart';

class ManageTask extends StatefulWidget {
  final TaskModel taskModel;
  const ManageTask({super.key, required this.taskModel});

  @override
  State<ManageTask> createState() => _ManageTaskState();
}

class _ManageTaskState extends State<ManageTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  late DateTime datetimeController;
  TextEditingController dateTextController = TextEditingController();

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
    datetimeController = widget.taskModel.date;
    dateTextController.text =
        "${addZeros(datetimeController.day)} ${displayMonth(datetimeController.month)} ${datetimeController.year} ${addZeros(datetimeController.hour)}:${addZeros(datetimeController.minute)}";

    if (widget.taskModel.description != null) {
      descriptionController.text = widget.taskModel.description!;
    }

    if (widget.taskModel.location != null) {
      locationController.text = widget.taskModel.location!;
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
                            readOnly: isEditable ? false : true,
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
                            readOnly: isEditable ? false : true,
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
                                  FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 20,
                                  ),
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
                            readOnly: isEditable ? false : true,
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
                                  String? location = locationController.text;

                                  try {
                                    TaskModel newTask = TaskModel(
                                      taskId: widget.taskModel.taskId,
                                      title: title,
                                      description: description,
                                      location: location,
                                      date: datetimeController,
                                      statut: 0,
                                      userId: widget.taskModel.userId,
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
