import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/kaspersky_sdk/interface/sdk_component_controller.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart';

class SdkInitializationController extends SdkComponentController {
  /// This component controller class handles the initialization of the Kaspersky Mobile Security SDK (KMS-SDK), simply referred to as 'SDK Initialization' (see (*)).
  /// Once the KMS--SDK is initialized, its security components such as EasyScanner (see for instance "./lib/src/utilities/device_scan/kaspersky_sdk/easy_scanner_controller.dart")
  /// can be used.
  ///
  /// Sdk Initialization is the initial task of a device scan (see for instance "./lib/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart").
  /// As a device scan task, it is associated with a taskProgress in the interval [0,1] (corresponding to 0% and 100% completion respectively).
  ///
  final DeviceScanController controller;
  static bool success = false;

  SdkInitializationController(this.controller);

  @override
  String get name => 'SDK Initialization'; // (*)

  @override
  void run() async {
    print(
        './lib/src/utilities/device_scan/kaspersky_sdk/sdk_initialization_controller.dart: START DEVICE SCAN TASK: SDK Initialization');
    KavSdk.init(_MyKavSdkListener(controller, this));
    double taskProgress = 0;
    controller.reportProgressOnCurrentTask(taskProgress, 'SDK Initialization');
  }

  @override
  getResult() {
    return success;
  }

  setResult(result) {
    success = result;
  }
}

// ----------------------------------------------------------------------------

class _MyKavSdkListener extends KavSdkInitListener {
  final DeviceScanController controller;
  final SdkInitializationController initController;

  _MyKavSdkListener(this.controller, this.initController);

  @override
  void onInitializationFailed(String result) {
    controller.errorScan('SDK Initialization (FAILURE): $result');
  }

  @override
  void onSdkInitialized() {
    initController.setResult(true);
    controller.reportProgressOnCurrentTask(1, 'SDK Initialization (SUCCESS)');
    controller.runNextTask();
  }
}
