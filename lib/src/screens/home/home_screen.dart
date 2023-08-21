import 'package:flutter/material.dart';
import 'package:flutternativetrapeze/main.dart';
import 'package:flutternativetrapeze/src/config/paths.dart' as Paths;
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics_history/device_scan_statistics_history_bloc.dart';
import 'package:flutternativetrapeze/src/widgets/device_scan_info/device_scan_info_widget.dart';

/// This [HomeScreen] class represents the "Home (a-x)", "Home (b-x)", "Profile (a-y)", "Profile (b-y)" screens
/// in "./release-info/v1.0.0-dummy/navigation/TRAPEZE-mobile[v1.0.0-dummy]_navigation.pdf".
class HomeScreen extends StatelessWidget {
  /// This field is the routeName under which this page is registered in the app.
  static const String routeName = '/';

  const HomeScreen({Key? key}) : super(key: key);

  /// This method builds the [AppBar] for the [Scaffold] and sets the title to the Trapeze logo.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Image.asset(Paths.PATH_TO_TRAPEZE_BANNER, fit: BoxFit.cover),
      // This code shows the name of the logged in user when logged in. Was replaced with the Trapeze Logo.
      // title: StreamBuilder(
      //   stream: userBloc.user,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       UserModel model = snapshot.data as UserModel;
      //       return Text(model.userName);
      //     } else {
      //       return Text("No logged in user found");
      //     }
      //   },
      // ),
      leading: StreamBuilder(
          stream: UserBloc.currentBloc.bloc,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel model = snapshot.data as UserModel;
              return model.isLoggedIn
                  ? IconButton(
                      icon: const Icon(Icons.account_circle),
                      iconSize: _toolbarIconSize,
                      onPressed: () {
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                      },
                    )
                  : Container();
            } else {
              return Text("No logged in user found");
            }
          }),
      actions: [
        // IconButton(
        //   icon: const Icon(Icons.settings),
        //   iconSize: _toolbarIconSize,
        //   onPressed: () {
        //     Navigator.pushNamed(context, SettingsRoute.routeName);
        //   },
        // ),
      ],
    );
  }

  String _pascalCaseToLowerCaseSentence(String str) {
    String nameInSentenceCase =
        str.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
    return nameInSentenceCase.toLowerCase();
  }

  StreamBuilder _buildFilterDropMenu(BuildContext context) {
    return StreamBuilder(
      stream: DeviceScanStatisticsHistoryBloc.currentBloc.bloc,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DeviceScanStatisticsHistoryModel model =
              snapshot.data as DeviceScanStatisticsHistoryModel;
          if (model.scans.length != 0) {
            return Row(
              children: [
                Text('show:  '),
                DropdownButton<Filter>(
                  value: model.filter,
                  items: <DropdownMenuItem<Filter>>[
                    ...Filter.values.map(
                      (e) {
                        return DropdownMenuItem(
                          child: Text(_pascalCaseToLowerCaseSentence(e.name)),
                          value: e,
                        );
                      },
                    )
                  ],
                  onChanged: (Filter? filter) => DeviceScanStatisticsHistoryBloc
                      .currentBloc
                      .updateScanFilter(filter!),
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }

  /// This build Method gets called to build the UI. This combines the
  /// components into a [Scaffold].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                _buildFilterDropMenu(context),
                Spacer(),
              ],
            ),
          ),

          StreamBuilder(
            stream: DeviceScanStatisticsHistoryBloc.currentBloc.bloc,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DeviceScanStatisticsHistoryModel model =
                    snapshot.data as DeviceScanStatisticsHistoryModel;
                if (model.scans.length != 0) {
                  return Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 5,
                      radius: Radius.circular(20),
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        scrollDirection: Axis.vertical,
                        itemCount: model.scans.length, // model.scans.length
                        itemBuilder: (context, index) {
                          return DeviceScanInfoWidget(
                            deviceScan: model.scans[index],
                          );
                        },
                      ),
                    ),
                  );
                }
              }
              return Expanded(
                  child: Container(
                margin: const EdgeInsets.only(top: 10, left: 10.0, right: 10.0),
                child: Text(
                  "You have not scanned your device yet",
                  style: const TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ));
            },
          ),

          SizedBox(
            height: 10,
          ),

          // Builds Scan Button.
          BaseElevatedButtonWidget(
            onPressed: () {
              // Navigator.pushNamed(context, DeviceScanScreen.routeName);
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text("Privacy Policy"),
                        content: Text(
                            "The TRAPEZE mobile app is about to scan your device. Do you want to scan your device for malware now?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Send and Scan"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, DeviceScanScreen.routeName);
                            },
                          )
                        ],
                      ),
                  barrierDismissible: false);
            },
            name: "Scan my Device",
          ),
          SizedBox(
            height: 23,
          ),
          // copyright
          const Text('Trapeze Mobile \u00a92021'),
          SizedBox(
            height: 13,
          ),
        ],
      ),
    );
  }

  /// Tweaking value for ToolbarIconSize
  final double _toolbarIconSize = 30.0;
}
