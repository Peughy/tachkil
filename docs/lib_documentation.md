# Documentation du dossier lib

Ce document résume les fichiers présents dans le dossier `lib/` et décrit rapidement les classes, fonctions et responsabilités principales.

---

**Fichier :** [lib/main.dart](lib/main.dart)
- **Responsabilité :** Point d'entrée de l'application, initialisation des permissions et notifications, gestion du thème et de la navigation initiale.
- **Symboles principaux :** `MyApp` (StatefulWidget), `_MyAppState` (méthodes : `getIfConnected()`, `initState()`, `dispose()`, `build()`).

**Fichier :** [lib/src/models/user_model.dart](lib/src/models/user_model.dart)
- **Responsabilité :** Modèle utilisateur.
- **Symboles principaux :** `UserModel` (champs : `userId`, `username`, `password`; méthode : `toMap()`).

**Fichier :** [lib/src/models/task_model.dart](lib/src/models/task_model.dart)
- **Responsabilité :** Modèle tâche et utilitaires liés à la priorité.
- **Symboles principaux :** `Priority` (enum : `hight`, `medium`, `low`), `TaskModel` (champs : `taskId`, `title`, `description?`, `color`, `priority`, `statut`, `date`, `userId`; méthodes : `toMap()`, `getPriorityNumber()`).
- **Notes :** Valeurs de `statut` documentées dans le fichier (-1 = late, 0 = in progress, 1 = finish).

**Fichier :** [lib/src/models/action_button_model.dart](lib/src/models/action_button_model.dart)
- **Responsabilité :** Modèle pour boutons d'actions/filtre en UI.
- **Symboles principaux :** `ActionButtonModel` (champs : `text`, `isSelected`, `statut`).

**Fichier :** [lib/src/widgets/task_widget.dart](lib/src/widgets/task_widget.dart)
- **Responsabilité :** Widget d'affichage d'une tâche (ligne UI avec icône, titre, date).
- **Symboles principaux :** `TaskWidget` (StatefulWidget) — gère le basculement du statut via `TasksQueries.tooggleStatut()`.

**Fichier :** [lib/src/widgets/action_button_widget.dart](lib/src/widgets/action_button_widget.dart)
- **Responsabilité :** Widget pour un bouton de filtrage (visuel, état sélectionné).
- **Symboles principaux :** `ActionButtonWidget` (StatelessWidget).

**Fichier :** [lib/src/utils/queries/users_queries.dart](lib/src/utils/queries/users_queries.dart)
- **Responsabilité :** Requêtes SQLite liées aux utilisateurs.
- **Symboles principaux :** `UsersQueries` (méthodes : `insert()`, `update()`, `delete()`, `select()` — `select` supporte 3 modes: login, by id, by username).

**Fichier :** [lib/src/utils/queries/tasks_queries.dart](lib/src/utils/queries/tasks_queries.dart)
- **Responsabilité :** Requêtes SQLite liées aux tâches.
- **Symboles principaux :** `TasksQueries` (méthodes : `getPriority()`, `insert()`, `select(userId) -> List<TaskModel>`, `update()`, `delete()`, `tooggleStatut()`).

**Fichier :** [lib/src/utils/notifier.dart](lib/src/utils/notifier.dart)
- **Responsabilité :** Notifiers partagés pour l'état global.
- **Symboles principaux :** `activeDarkThemeNotifier`, `activeReminderNotifier`, `userIdNotifier`.

**Fichier :** [lib/src/utils/database_helper.dart](lib/src/utils/database_helper.dart)
- **Responsabilité :** Initialisation et gestion basique de la base SQLite (schéma, ouverture/fermeture).
- **Symboles principaux :** `DatabaseHelper` (méthodes : `_onCreate()`, `_initDb()`, `getDBInstance()`, `closeDb()`).

**Fichier :** [lib/src/utils/constant.dart](lib/src/utils/constant.dart)
- **Responsabilité :** Constantes de couleurs utilisées dans l'app.
- **Symboles principaux :** `mainColor`, `whiteColor`, `dartColor`.

**Fichier :** [lib/src/utils/common.dart](lib/src/utils/common.dart)
- **Responsabilité :** Fonctions utilitaires UI et stockage local.
- **Symboles principaux :** `addZeros()`, `displayMonth()`, `navigatorBottomToTop()`, `showMessage()`, `getUserId()`, `loadingWidget()`.

**Fichier :** [lib/src/services/local_notifications_service.dart](lib/src/services/local_notifications_service.dart)
- **Responsabilité :** Initialisation du plugin de notifications locales.
- **Symboles principaux :** `LocalNotificationsService.initialize()` (TODO: scheduling commenté dans le fichier).

---

**Pages (UI)**

- [lib/src/pages/welcome_page.dart](lib/src/pages/welcome_page.dart) — `WelcomePage` : écran d'entrée proposant Connexion / Inscription.
- [lib/src/pages/login_page.dart](lib/src/pages/login_page.dart) — `LoginPage` : formulaire de connexion, gestion du 'se souvenir de moi' et stockage `SharedPreferences`.
- [lib/src/pages/register_page.dart](lib/src/pages/register_page.dart) — `RegisterPage` : formulaire d'inscription et insertion en base via `UsersQueries`.
- [lib/src/pages/forget_password_page.dart](lib/src/pages/forget_password_page.dart) — `ForgetPasswordPage` : récupération / modification de mot de passe (recherche par username puis update).
- [lib/src/pages/home_page.dart](lib/src/pages/home_page.dart) — `HomePage` : liste des tâches, recherche, filtres par statut, navigation vers `AddTaskPage`, `AccountPage`, `ManageTask`.
- [lib/src/pages/add_task_page.dart](lib/src/pages/add_task_page.dart) — `AddTaskPage` : formulaire d'ajout de tâche (génération `taskId` aléatoire, insertion via `TasksQueries`).
- [lib/src/pages/manage_task.dart](lib/src/pages/manage_task.dart) — `ManageTask` : édition, suppression et marquage terminé/non terminé d'une tâche.
- [lib/src/pages/account_page.dart](lib/src/pages/account_page.dart) — `AccountPage` : affichage et modification des infos utilisateur, paramètres (thème, rappel), déconnexion.
- [lib/src/pages/delete_account_page.dart](lib/src/pages/delete_account_page.dart) — `DeleteAccountPage` : écran de suppression du compte (UI seulement, validation simple dans le fichier).

---

Remarques rapides et points d'attention
- Plusieurs actions d'insertion/mise à jour vers la DB utilisent des IDs générés aléatoirement (`Random().nextInt(...)`) — attention aux collisions possibles.
- Dans `DatabaseHelper._onCreate()` il y a des requêtes SQL et un trigger ; vérifier le SQL si des problèmes d'exécution apparaissent.
- Certaines fonctionnalités (ex. scheduling de notifications, champs `location` dans `TaskModel`) sont commentées / partiellement implémentées.

---

Fichier généré automatiquement le: 2026-01-02
