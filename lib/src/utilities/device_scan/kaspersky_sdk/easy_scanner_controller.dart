import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_log_controller/device_scan_log_controller.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/kaspersky_sdk/interface/sdk_component_controller.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart';
import 'dart:developer';

class EasyScannerController extends SdkComponentController {
  /// This component controller class handles device scans as per the EasyScanner component of the Kaspersky Mobile Security SDK (KMS-SDK), simply referred to as 'Easy Scanner' (see (*)).
  /// REMARK: Make sure that the app has permissions to READ-access all files on the device.
  ///         See for instance the 'READ-access' permissions in './android/app/src/main/AndroidManifest.xml'.
  final DeviceScanController controller;
  EasyResult? _result;

  EasyScannerController(this.controller);

  @override
  String get name => 'Easy Scanner'; // (*)

  @override
  void run() async {
    print(
        './lib/src/utilities/device_scan/kaspersky_sdk/easy_scanner_controller.dart: START DEVICE SCAN TASK: Easy Scanner');
    EasyScanner().scan(EasyMode.Full, _MyEasyListener(controller, this));
    double taskProgress = 0;
    controller.reportProgressOnCurrentTask(taskProgress, 'Easy Scanner');
  }

  @override
  getResult() {
    return _result;
  }
}

// ----------------------------------------------------------------------------

class _MyEasyListener extends EasyListener {
  final DeviceScanController controller;
  final EasyScannerController _scanController;
  late DeviceScanLogController logController;

  _MyEasyListener(this.controller, this._scanController) {
    this.logController = DeviceScanLogController.logger;
  }

  @override
  void onFilesCountCalculated(int fileCount) async {
    print('[EasyScanner] counted $fileCount files');
    controller.reportProgressOnCurrentTask(
        0.2, 'Found $fileCount files to scan');
  }

  @override
  void onFinished(EasyResult result) async {
    print('[EasyScanner] finished $result');
    _scanController._result = result;
    controller.reportProgressOnCurrentTask(1, 'Running Easy Scanner DONE');
    controller.runNextTask();
    log("DEBUG - RESULTS: ${result.toString()}"); // log for controlling
  }

  @override
  void onMalwareDetected(EasyObject object, ThreatInfo threat) async {
    print('[EasyScanner] malware detected $object $threat');
    // TODO: implement onMalwareDetected
  }

  @override
  void onObjectBegin(EasyObject object) async {
    // print('[EasyScanner] begin object $object');
    // TODO: implement onObjectBegin
  }

  @override
  void onObjectEnd(EasyObject object, EasyStatus status) async {
    // print('[EasyScanner] end object $object $status');
    // TODO: implement onObjectEnd
  }

  @override
  void onRiskwareDetected(EasyObject object, ThreatInfo threat) async {
    print('[EasyScanner] riskware detected $object $threat');
    // TODO: implement onRiskwareDetected
  }

  @override
  void onRooted() async {
    print('[EasyScanner] rooted');
    // TODO: implement onRooted
  }

  @override
  void onError(String message) {
    print('[Easy Scanner] error: $message');
    // TODO: implement onError
  }
}
