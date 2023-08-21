abstract class SdkComponentController {
  /// Abstract class for making available components of the Kaspersky Mobile Security SDK (KMS-SDK).
  /// Every component controller has a:
  ///  * name; to identify the component controller
  ///  * <run> method; e.g. run a device scan (see for instance './lib/src/utilities/device_scan/kaspersky_sdk/easy_scanner_controller.dart')
  ///  * <getResult> method; to retrieve tha results derived by the <run> method
  String get name;
  void run();
  dynamic getResult();
}
