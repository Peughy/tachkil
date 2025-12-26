/*

  This file is used for defined the notifer variable

 */

/*

  For sharepreferences

  activeReminderNotifier -> isReminder
  connectedNotifier -> isConnected

 */

import 'package:flutter/material.dart';

ValueNotifier<bool> activeDarkThemeNotifier = ValueNotifier(false); 
ValueNotifier<bool> activeReminderNotifier = ValueNotifier(true); 
ValueNotifier<int?> userIdNotifier = ValueNotifier(null);