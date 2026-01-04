import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/action_button_model.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/pages/account_page.dart';
import 'package:tachkil/src/pages/add_task_page.dart';
import 'package:tachkil/src/pages/manage_task.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/utils/queries/tasks_queries.dart';
import 'package:tachkil/src/widgets/action_button_widget.dart';
import 'package:tachkil/src/widgets/task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// this param is used for filter the task statut
int? statutSelected;
late int userId;

List<ActionButtonModel> actionButtonModels = [
  ActionButtonModel(text: "Toutes", isSelected: true, statut: null),
  ActionButtonModel(text: "En cours", isSelected: false, statut: 0),
  ActionButtonModel(text: "Retard", isSelected: false, statut: -1),
  ActionButtonModel(text: "Terminés", isSelected: false, statut: 1),
];

// this variable is used for filter the task with the search bar
String filterTaskName = "";
TextEditingController searchTaskController = TextEditingController();
TasksQueries tasksQueries = TasksQueries();

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

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigatorBottomToTop(AddTaskPage(), context);
            },
            backgroundColor: mainColor,
            child: FaIcon(FontAwesomeIcons.plus, size: 28, color: whiteColor),
          ),
          body: Padding(
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
                            activeDarkTheme: activeDarkTheme,
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
                      return SizedBox.shrink();
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

                    // Grouper les tâches par date
                    Map<String, List<TaskModel>> groupedTasks = {};
                    for (TaskModel task in taskModelsFiltered) {
                      String dateKey =
                          "${addZeros(task.date.day)} ${displayMonth(task.date.month)} ${task.date.year}";
                      if (!groupedTasks.containsKey(dateKey)) {
                        groupedTasks[dateKey] = [];
                      }
                      groupedTasks[dateKey]!.add(task);
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: groupedTasks.length,
                      itemBuilder: (context, dateIndex) {
                        String dateKey = groupedTasks.keys.elementAt(dateIndex);
                        List<TaskModel> tasksForDate = groupedTasks[dateKey]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section date
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
                                dateKey,
                                style: GoogleFonts.openSans(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // Tâches pour cette date
                            ...tasksForDate.map((taskModel) {
                              return (statutSelected == null ||
                                      statutSelected == taskModel.statut)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          navigatorBottomToTop(
                                            ManageTask(taskModel: taskModel),
                                            context,
                                          );
                                        },
                                        child: TaskWidget(
                                          activeDarkTheme: activeDarkTheme,
                                          taskModel: taskModel,
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink();
                            }),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
