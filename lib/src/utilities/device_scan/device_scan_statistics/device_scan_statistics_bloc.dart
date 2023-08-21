import 'dart:io';

import 'package:flutternativetrapeze/src/interfaces/abstract_bloc.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics/device_scan_statistics_model.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics/device_scan_statistics_handler.dart';
import 'package:path_provider/path_provider.dart';

/// This [DeviceScanStatisticsBloc] class handles the state of the [DeviceScanStatisticsModel].
///
/// There are mutation functions ([updateStatistics],[resolve],[updateStatisticsfromModel]) to muta state of the current [DeviceScanStatisticsModel].
///```dart
/// DeviceScanStatisticsBloc.currentBloc.updateStatistics(10,8,2,DateTime.now(),Map());
/// ```
class DeviceScanStatisticsBloc extends AbstractBloc<DeviceScanStatisticsModel,
    DeviceScanStatisticsHandler> {
  /// The current instance of the Singleton.
  static final DeviceScanStatisticsBloc currentBloc =
      DeviceScanStatisticsBloc._();

  /// Initializes the [DeviceScanStatisticsHandler] which performs all the state changes on the [DeviceScanStatisticsModel].
  final handler = DeviceScanStatisticsHandler();

  /// Private Constructor for this BloC to make it a Singleton.
  DeviceScanStatisticsBloc._() {
    loadMostRecentScanIfExist();
  }

  void updateStatisticsFromDirectory(String dirPath) {
    DeviceScanStatisticsModel newModel =
        handler.updateStatisticsFromDirectory(dirPath);

    this.publisher.add(newModel);
  }

  /// Updates the the [DeviceScanStatisticsModel] by specific values which are given as paramters and publishes it to the stream.
  void updateStatistics(
      int identifiedThreats,
      int resolvedThreats,
      int unresolvedThreats,
      DateTime lastScanned,
      Map<VerdictCategory, List<ThreatInfo>> verdictCategoryMappedThreatInfo)
  //Map<VerdictCategory, List<String>> groupedThreats,
  //EasyResult easyResult)
  {
    DeviceScanStatisticsModel newStat = this.handler.updateStatistics(
        identifiedThreats,
        resolvedThreats,
        unresolvedThreats,
        lastScanned,
        verdictCategoryMappedThreatInfo
        //groupedThreats,
        //easyResult,
        );

    this.publisher.add(newStat);
  }

  /// Sets [DeviceScanStatisticsModel] to a deepcopy of the new [DeviceScanStatisticsModel].
  void updateStatisticsfromModel(DeviceScanStatisticsModel model) {
    DeviceScanStatisticsModel newStat =
        this.handler.updateStatisticsfromModel(model);
    this.publisher.add(newStat);
  }

  Future<String?> getMostRecentScanDirectoryPath() async {
    int mostRecentScanDateInMillisecondsSinceEpoch = 0;
    final Directory logRootDirectory = await getApplicationDocumentsDirectory();

    List<FileSystemEntity> entities =
        Directory('${logRootDirectory.path}/').listSync();
    final Iterable<Directory> directories = entities.whereType<Directory>();

    directories.where((element) {
      // getting directories that include scans
      return int.tryParse(element.path.split('/').last) != null;
    }).forEach((element) {
      //finding the date of the latest Scan
      int? scanDateInMillisecondsSinceEpoch =
          int.tryParse(element.path.split('/').last);
      if (scanDateInMillisecondsSinceEpoch! >
          mostRecentScanDateInMillisecondsSinceEpoch) {
        mostRecentScanDateInMillisecondsSinceEpoch =
            scanDateInMillisecondsSinceEpoch;
      }
    });

    if (mostRecentScanDateInMillisecondsSinceEpoch != 0) {
      return '${logRootDirectory.path}/$mostRecentScanDateInMillisecondsSinceEpoch';
    }
    return null;
  }

  Future<void> loadMostRecentScanIfExist() async {
    String? mostRecentScanDirectoryPath =
        await getMostRecentScanDirectoryPath();
    if (mostRecentScanDirectoryPath != null) {
      updateStatisticsFromDirectory(mostRecentScanDirectoryPath);
    }
  }
}
