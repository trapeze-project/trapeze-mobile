import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternativetrapeze/main.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_controller/device_scan_progress_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics_history/device_scan_statistics_history_bloc.dart';
import 'package:flutternativetrapeze/src/widgets/device_scan/device_scan_progress_widget.dart';

/// This [DeviceScanScreen] class is a [StatefulWidget] with the corresponding [_ScanRouteState] class for the UI and represents the "Scan - Pending" screen in
/// "./release-info/v0.1.0/navigation/TRAPEZE-mobile[v0.1.0]_navigation.pdf".
class DeviceScanScreen extends StatelessWidget {
  /// This field is the routeName under which this page is registered in the app.
  static const String routeName = '/device_scan';

  const DeviceScanScreen({Key? key}) : super(key: key);

  /// This build Method gets called to build the UI. This combines the
  /// components into a [Scaffold].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.only(top: 80, bottom: 50),
          child: BlocConsumer<DeviceScanProgressBloc, ScanProgressState>(
            bloc: DeviceScanProgressBloc(),
            listener: (context, state) {
              if (state is AbortScanState) {
                Navigator.pop(context);
              } else if (state is FinishScanState) {
                DeviceScanStatisticsHistoryBloc.currentBloc.refreshScanHistory();
                DeviceScanStatisticsBloc.currentBloc.updateStatisticsFromDirectory(state.dir.path);
                Navigator.popAndPushNamed(context, DeviceScanLogScreen.routeName);
              }
            },
            buildWhen: (previous, current) {
              if (previous.runtimeType != current.runtimeType) return true;
              if (previous is UpdateScanState && current is UpdateScanState) {
                return previous.progress != current.progress ||
                    previous.currentTask != current.currentTask;
              }
              return true;
            },
            builder: (context, state) {
              double progress = 0;
              String currentTask = '';
              if (state is StartScanState) {
                currentTask = 'Start Scan';
              } else if (state is UpdateScanState) {
                progress = state.progress;
                currentTask = state.currentTask;
              } else if (state is FinishScanState) {
                progress = 1;
                currentTask = 'Finished Scan';
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Scanning Device...",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Spacer(),
                  Container(
                      alignment: Alignment.center,
                      child: DeviceScanProgressWidget(
                        progress: progress,
                        currentTask: currentTask,
                      )),
                  Spacer(),
                  BaseElevatedButtonWidget(
                    onPressed: () {
                      BlocProvider.of<DeviceScanProgressBloc>(context, listen: false)
                          .add(AbortScanEvent());
                    },
                    name: "Abort",
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
