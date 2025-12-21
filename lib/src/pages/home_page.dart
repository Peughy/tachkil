import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tachkil/src/models/action_button_model.dart';
import 'package:tachkil/src/models/task_model.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/widgets/action_button_widget.dart';
import 'package:tachkil/src/widgets/task_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// this param is used for filter the task statut
int? statutSelected;

List<ActionButtonModel> actionButtonModels = [
  ActionButtonModel(text: "Toutes", isSelected: true, statut: null),
  ActionButtonModel(text: "En cours", isSelected: false, statut: 0),
  ActionButtonModel(text: "Retard", isSelected: false, statut: -1),
  ActionButtonModel(text: "Termine", isSelected: false, statut: 1),
];

List<TaskModel> taskModels = [
  TaskModel(title: "Un titre", time: DateTime(2025, 9, 23, 8, 30), statut: 0),
  TaskModel(
    title: "Un titre 1",
    time: DateTime(2025, 9, 23, 8, 30),
    statut: -1,
  ),
  TaskModel(title: "Un titre 2", time: DateTime(2025, 9, 23, 8, 30), statut: 1),
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        title: Text.rich(
          TextSpan(
            text: "tach",
            style: GoogleFonts.anton(
              fontSize: 36,
              color: dartColor,
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
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.solidUser,
                    size: 20,
                    color: dartColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.gear,
                    size: 20,
                    color: dartColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: mainColor,
        child: FaIcon(FontAwesomeIcons.plus, size: 28, color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextFormField(
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
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 42),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: taskModels.length,
              itemBuilder: (context, index) {
                // ignore: unnecessary_null_comparison
                return (statutSelected == null ||
                        statutSelected == taskModels[index].statut)
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TaskWidget(taskModel: taskModels[index]),
                      )
                    : SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
