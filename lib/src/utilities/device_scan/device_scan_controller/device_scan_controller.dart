import 'dart:io';

import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_controller/device_scan_progress_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/kaspersky_sdk/easy_scanner_controller.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_log_controller/device_scan_log_controller.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/kaspersky_sdk/interface/sdk_component_controller.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/kaspersky_sdk/sdk_initialization_controller.dart';

class DeviceScanController {
  /// This controller class handles device scans as triggered for instance by pushing the "Scan my Device" Button on the
  /// "Home(x)", "Home(y)", and "Home(z)" screens in "./release-info/v0.1.0/navigation/TRAPEZE-mobile[v0.1.0]_navigation.pdf".
  /// Scans represent a list of <_tasks>, where every task is associated with an index <_taskIndex> (first task -> 0; second task -> 1; ..)
  /// This controller class provides the following functionality:
  ///
  /// (I.) Set the tasks to perform in a device scan
  /// (II.) Control device scans
  /// (II.a) Start a device scan
  /// (II.b) Report the progress of the device scan
  /// (II.c) Run the next task of a device scan, unless the device scan is (i) aborted or (ii) finished.
  /// (II.d) Finish the device scan
  /// (II.e) Abort the device scan (non-error; e.g. user-triggered)
  /// (II.f) Abort the device scan (error)
  /// (III.) Retrieve a list of task results
  ///     EXAMPLE: for the _tasks list [SdkInitializationController(this), EasyScannerController(this)]
  ///     results could be the list [true, EasyResult[filesCount=11600, filesScanned=11267, objectsScanned=10798, objectsSkipped=601, malwareCount=1, riskwareCount=0, isRooted=false]]
  ///     true -> SDK Initialization was successful
  ///     EasyResult[...] -> EasyScanner scanned successfully
  /// (*): The progress of a device scan is defined as the number of finished tasks <_taskIndex> divided by the total number of tasks <_tasks.length>.
  final DeviceScanProgressBloc bloc;
  late List<SdkComponentController> _tasks;
  int _taskIndex = 0;
  bool _isAborted = false;

  // (I.) Set tasks to perform in a device scan
  DeviceScanController(this.bloc) {
    _tasks = [
      SdkInitializationController(this),
      EasyScannerController(this),
    ];
  }

  // (II.) Control device scans

  // (II.a) Start a device scan
  void startScan() async {
    print(
        './lib/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart: (II.a) START DEVICE SCAN: ${_tasks.length} tasks scheduled.');
    // Reset <_isAborted> to default value: false
    _isAborted = false; // default

    // if SDK is initialized
    if (_tasks[_taskIndex].getResult()) {
      print('(II.a) SDK already initialized, skipping SDK initialization.');
      // skip SDK initialization by setting
      _taskIndex = 0;
    } else {
      // start the device scan with SDK Initialization by setting
      _taskIndex = -1;
    }
    // Start the device scan
    runNextTask();
  }

  // (II.b) Report the progress(*) of the device scan and the description of the current task
  void reportProgressOnCurrentTask(
      double taskProgress, String description) async {
    var scanProgress =
        _taskIndex / _tasks.length + taskProgress / _tasks.length;
    print(
        './lib/src/utilities/device_scan/device_scan_controller/device_scan_controller/device_scan_controller.dart: (II.b) REPORT DEVICE SCAN PROGRESS (${scanProgress * 100} %/ 100%) on current task  "$description"');
    // Add device scan progress and the description to (ScanProgressBloc) bloc
    // NOTE that the device scan progress is split into the sum of (i) fully finished tasks and (ii) partially finished tasks
    bloc.add(UpdateScanEvent(scanProgress, description));
  }

  // (II.c) Run the next task of a device scan, unless the device scan is (i) aborted or (ii) finished.
  void runNextTask() async {
    // (i) Check if Scan aborted
    if (_isAborted) return;
    // (ii) Check if Scan finished (last task finished)
    if (_taskIndex + 1 == _tasks.length) {
      finishScan();
      return;
    }

    print(
        './lib/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart: (II.c) RUN NEXT DEVICE SCAN TASK');
    // Increment _taskIndex
    _taskIndex = _taskIndex + 1;
    // Run next task
    _tasks[_taskIndex].run();
  }

  // (II.d) Finish the device scan: Reset task counter <_taskIndex> and persist result log
  void finishScan() async {
    print(
        './lib/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart: (II.d) FINISH DEVICE SCAN');
    _taskIndex = 0;
    List<dynamic> results = getResults();
    File file = await DeviceScanLogController.logger.writeLog(results);
    // Add error string to (ScanProgressBloc) bloc
    bloc.add(FinishScanEvent(file.parent));
  }

  // (II.e) Abort the device scan (non-error; e.g. user-triggered)
  void abortScan() async {
    print(
        './lib/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart: (II.e) ABORT DEVICE SCAN (user-triggered)');
    // Reset <_taskIndex> and <_isAborted> to default values
    _taskIndex = 0;
    _isAborted = true;
  }

  /// (II.f) Abort the device scan (error)
  void errorScan(String reason) async {
    print(
        './lib/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart: (II.f) ABORT DEVICE SCAN (error)');

    /// Reset <_taskIndex> and <_isAborted> to default values
    _isAborted = true;
    _taskIndex = 0;

    /// Add error string to (ScanProgressBloc) bloc
    bloc.add(ErrorScanEvent(reason));
  }

  /// (III.) Retrieve a list of task results
  List<dynamic> getResults() {
    return _tasks.map((t) => t.getResult()).toList();
  }
}
