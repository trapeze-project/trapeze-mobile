import 'package:flutter/material.dart';
import './src/app.dart';

// This is for the doc generation
//  - INTERFACES
export './src/interfaces/abstract_bloc.dart';

//  - UTILITIES
export './src/utilities/device_scan/device_scan_statistics/device_scan_statistics_bloc.dart';
export './src/utilities/device_scan/device_scan_statistics/device_scan_statistics_handler.dart';
export './src/utilities/device_scan/device_scan_statistics/device_scan_statistics_model.dart';
export './src/utilities/user_management/user_bloc.dart';
export './src/utilities/user_management/user_handler.dart';
export './src/utilities/user_management/user_model.dart';

//  - SCREENS
export './src/screens/home/home_screen.dart';
export './src/screens/device_scan/device_scan_screen.dart';
export './src/screens/device_scan/device_scan_log_screen.dart';
export './src/screens/knowledgebase/knowledgebase_screen.dart';

export './src/screens/user_management/login_screen.dart';
export './src/screens/user_management/profile_screen.dart';

//  - WIDGETS
export './src/widgets/base_widgets/base_card_widget.dart';
export './src/widgets/base_widgets/base_elevated_button_widget.dart';
export './src/widgets/device_scan_summary/device_scan_summary_widget.dart';
export './src/widgets/device_scan/device_scan_progress_widget.dart';

//  - APP
export './src/app.dart';

void main() {
  runApp(App());
}
