import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/action_button_model.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/pages/add_task_page.dart';
import 'package:tachkil/src/pages/manage_task.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/tasks_queries.dart';
import 'package:tachkil/src/widgets/action_button_widget.dart';
import 'package:tachkil/src/widgets/task_widget.dart';

class TasksPage extends StatefulWidget {
  final bool activeDarkTheme;
  const TasksPage({super.key, required this.activeDarkTheme});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

List<ActionButtonModel> actionButtonModels = [
  ActionButtonModel(text: "Toutes", isSelected: false, statut: null),
  ActionButtonModel(text: "En cours", isSelected: true, statut: 0),
  ActionButtonModel(text: "Terminés", isSelected: false, statut: 1),
];

// this variable is used for filter the task with the search bar
String filterTaskName = "";
TextEditingController searchTaskController = TextEditingController();
TasksQueries tasksQueries = TasksQueries();

DateTime datefilter = DateTime.now();

class _TasksPageState extends State<TasksPage> {
  
  // this param is used for filter the task statut
  int? statutSelected;
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = userIdNotifier.value!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          TextFormField(
            onChanged: (value) {
              setState(() {
                filterTaskName = value;
              });
            },
            controller: searchTaskController,
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              fillColor: Colors.black12,
              filled: true,
              hint: Text(
                "Recherchez une tache",
                style: GoogleFonts.openSans(
                  fontSize: 18,
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
            ),
          ),
          SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(actionButtonModels.length, (index) {
                return Padding(
                  padding: EdgeInsetsGeometry.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        for (ActionButtonModel actionButtonModel
                            in actionButtonModels) {
                          actionButtonModel.isSelected = false;
                        }

                        actionButtonModels[index].isSelected = true;
                        statutSelected = actionButtonModels[index].statut;
                      });
                    },
                    child: ActionButtonWidget(
                      actionButtonModel: actionButtonModels[index],
                      activeDarkTheme: widget.activeDarkTheme,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 42),
          FutureBuilder(
            future: tasksQueries.select(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingWidget(widget.activeDarkTheme);
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image(
                        image: AssetImage("assets/res/oups.png"),
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Erreur...",
                        style: GoogleFonts.openSans(
                          fontSize: 17,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<TaskModel> tasksModels = snapshot.data!;

              if (tasksModels.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image(
                        image: AssetImage("assets/res/oups.png"),
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Oops! Aucune de tache...",
                        style: GoogleFonts.openSans(
                          fontSize: 17,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 18),
                      GestureDetector(
                        onTap: () {
                          navigatorBottomToTop(AddTaskPage(), context);
                        },
                        child: Text(
                          "Ajouter une tache",
                          style: GoogleFonts.openSans(
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<TaskModel> taskModelsFiltered = (filterTaskName != "")
                  ? tasksModels
                        .where(
                          (TaskModel taskModel) => taskModel.title
                              .toLowerCase()
                              .contains(filterTaskName.toLowerCase()),
                        )
                        .toList()
                  : tasksModels;

              List<TaskModel> taskModelsDateFiltered = taskModelsFiltered
                  .where(
                    (TaskModel taskModel) =>
                        taskModel.date.year == datefilter.year &&
                        taskModel.date.month == datefilter.month &&
                        taskModel.date.day == datefilter.day,
                  )
                  .toList();

              if (taskModelsDateFiltered.isEmpty) {
                return Column(
                  spacing: 16,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 24),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        displayStringDate(datefilter),
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image(
                            image: AssetImage("assets/res/oups.png"),
                            width: 150,
                            height: 150,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Aucune tache enregistrée le ${displayStringDate(datefilter)}",
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section date
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 24),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      displayStringDate(datefilter),
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Tâches pour cette date
                  ...taskModelsDateFiltered.map((taskModel) {
                    return (statutSelected == null ||
                            statutSelected == taskModel.statut)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                navigatorBottomToTop(
                                  ManageTask(taskModel: taskModel),
                                  context,
                                );
                              },
                              child: TaskWidget(
                                activeDarkTheme: widget.activeDarkTheme,
                                taskModel: taskModel,
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
