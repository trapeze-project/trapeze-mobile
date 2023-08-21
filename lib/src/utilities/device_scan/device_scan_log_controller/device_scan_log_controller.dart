import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutternativetrapeze/src/config/constants.dart' as Constants;

class DeviceScanLogController {
  /// This controller class handles logging the results of device scans (see './lib/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart').
  /// Device scan results are converted into a string in JSON-format (see the Example below).
  ///
  /// Log files are stored as *.json files in the following directory structure:
  /// logRootDir
  ///     |
  ///     |_ logDir1
  ///     |     |
  ///     |     |_ logFile1.json
  ///     |
  ///     |_ logDir2
  ///     |     |
  ///     |     |_ logFile2.json
  ///     |
  ///     ...
  ///
  /// Methods:
  ///  (I.) Write a log file
  ///  (II.) Read a log file
  ///
  /// Example
  /// * log file path:
  ///     '/data/user/0/com.example.flutternativetrapeze/app_flutter/1653915014704/device_scan_log.json'.
  /// * log file:
  ///   {
  ///     "bool":true,
  ///     "EasyResult":
  ///      {
  ///        "filesCount":11501,
  ///        "filesScanned":11168,
  ///        "malwareList":
  ///          [
  ///            {
  ///            "categories":["Unknown"],
  ///            "fileFullPath":"/data/app/~~T6s6bq18HbqZzkNJCH5pjw==/com.amtso.mobiletestfile-x8ssZCq_cnJRIhwVrw94PQ==/base.apk",
  ///            "objectName":"/data/app/~~T6s6bq18HbqZzkNJCH5pjw==/com.amtso.mobiletestfile-x8ssZCq_cnJRIhwVrw94PQ==/base.apk",
  ///            "packageName":"com.amtso.mobiletestfile",
  ///            "severityLevel":"High",
  ///            "virusName":"AMTSO-test-file",
  ///            "isApplication":true,
  ///            "isCloudCheckFailed":false,
  ///            "isDeviceAdminThreat":false
  ///            }
  ///          ],
  ///        "objectsScanned":10676,
  ///        "objectsSkipped":601,
  ///        "riskwareList":[],
  ///        "isRooted":false
  ///      }
  ///   }
  DeviceScanLogController._privateConstructor();
  static final String _logFileName = Constants.LOG_FILE_NAME;
  static final DeviceScanLogController _logger =
      DeviceScanLogController._privateConstructor();

  static DeviceScanLogController get logger => _logger;

  /// Get path to the on-device directory <_logRootDir> that holds (a) app-specific and (b) user-generated data.
  /// Returns:
  Future<String> get _logRootDir async {
    final Directory logRootDirectory = await getApplicationDocumentsDirectory();
    return logRootDirectory.path;
  }

  /// Create a log directory in the log root directory <_logRootDir> to persist a log file in (format: './<_logRootDir>/$logDirectoryName').
  /// NOTE the <logDirectoryName>s are chosen as the current time stamp.
  /// Returns: <Directory>
  Future<Directory> _createLogDirectory(String logDirectoryName) async {
    final String logRootDir = await _logRootDir;
    final Directory logDir = await Directory('$logRootDir/$logDirectoryName/')
        .create(recursive: true);
    print(
        "./lib/src/utilities/persistence/log_controller.dart: CREATE LOG DIRECTORY: '$logDir'.");
    return logDir;
  }

  /// Create a log file 'device_scan_log.json' in a log directory <$logDir>
  Future<File> _createLogFile(Directory logDir) {
    File file = File(
        '${logDir.path}${logDir.path.endsWith('/') ? '' : '/'}$_logFileName');
    print(
        "./lib/src/utilities/log_controller.dart: CREATE LOG FILE: '${logDir.path}${logDir.path.endsWith('/') ? '' : '/'}$_logFileName'.");
    return file.create();
  }

  /// (I.) Write a log file for a list of <$deviceScanResults>.
  Future<File> writeLog(List<dynamic> deviceScanResults) async {
    // Fetch the current date time (format: UNIX timestamp)
    DateTime now = DateTime.now();
    // Initialize an empty key-value map <resultsJson>
    Map<String, dynamic> deviceScanResultsMap = {};

    // Convert the list of <$deviceScanResults> into a stringified JSON
    for (dynamic res in deviceScanResults) {
      deviceScanResultsMap[res.runtimeType.toString()] = res;
    }
    String deviceScanResultsJsonString = jsonEncode(deviceScanResultsMap);

    // Create the log directory
    Directory logDir =
        await _createLogDirectory(now.millisecondsSinceEpoch.toString());
    // Create the log file
    File file = await _createLogFile(logDir);
    // Write <$deviceScanResultsJSON> into log file
    return await file.writeAsString(deviceScanResultsJsonString);
  }

  /// (II.) Read a log file identified by a UNIX timestamp.
  Future<String> readLog(DateTime time) async {
    try {
      String lp = await _logRootDir;
      File readFile = File(
          '$lp${lp.endsWith('/') ? '' : '/'}${time.millisecondsSinceEpoch}/$_logFileName');
      String log = await readFile.readAsString();
      return jsonDecode(log);
    } catch (e) {
      return "We are very sorry, we could not find any scan."; //TODO TEXT? 1/0? int.parse(log)
    }
    // write into a log/ file but not on the phone "creating the log"
    // solution controller -> save the map threat:solution, add the solution to the log --> to save it.
  }
}
