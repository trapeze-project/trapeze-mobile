import 'package:flutter/material.dart';

import 'package:flutternativetrapeze/src/config/theme.dart';

import 'package:flutternativetrapeze/src/screens/home/home_screen.dart';
import 'package:flutternativetrapeze/src/screens/device_scan/device_scan_screen.dart';
import 'package:flutternativetrapeze/src/screens/device_scan/device_scan_log_screen.dart';
import 'package:flutternativetrapeze/src/screens/knowledgebase/knowledgebase_screen.dart';
import 'package:flutternativetrapeze/src/screens/user_management/login_screen.dart';
import 'package:flutternativetrapeze/src/screens/user_management/profile_screen.dart';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';

/// This [App] class is the main entry to the app.
///
/// Here are the routes and the themes.
class App extends StatelessWidget {
  /// Primary swatch; official TRAPEZE yellow
  static const MaterialColor _primarySwatch = AppColors.PRIMARY_SWATCH;

  /// Fitting secondary swatch; TODO: Add inverted TRAPEZE color palette
  static const MaterialColor _secondarySwatch = AppColors.SECONDARY_SWATCH;

  /// This method configures the [MaterialApp] and the routes are set here.
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: MaterialApp(
        theme: ThemeData(
            fontFamily: 'Arial',
            brightness: Brightness.light,
            colorScheme:
                ColorScheme.fromSwatch(primarySwatch: App._primarySwatch)
                    .copyWith(secondary: App._secondarySwatch)),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.light,

        // internet connection checker with dialog
        builder: (buildContext, widget) {
          return ConnectivityWidgetWrapper(
            child: widget!,
            disableInteraction: true,
            height: 70,
            message:
                'Please connect to the internet. \nwe need to fetch various informations about virsues and actions against them from the internet.',
          );
        },

        initialRoute: HomeScreen.routeName,
        routes: <String, WidgetBuilder>{
          HomeScreen.routeName: (BuildContext context) => HomeScreen(), // home
          LoginScreen.routeName: (BuildContext context) =>
              LoginScreen(), // user_management
          ProfileScreen.routeName: (BuildContext context) =>
              ProfileScreen(), // user_management
          DeviceScanScreen.routeName: (BuildContext context) =>
              DeviceScanScreen(), // device_scan
          DeviceScanLogScreen.routeName: (BuildContext context) =>
              DeviceScanLogScreen(), // device_scan
          // DeviceScanConfigurationScreen.routeName: (BuildContext context) => DeviceScanConfigurationScreen(), // device_scan

          KnowledgebaseScreen.routeName: (BuildContext context) =>
              KnowledgebaseScreen(), // threat_resolution
        },
      ),
    );
  }
}
