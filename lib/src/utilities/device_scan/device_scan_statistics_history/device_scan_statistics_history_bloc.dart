import 'package:flutternativetrapeze/src/interfaces/abstract_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics/device_scan_statistics_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics/device_scan_statistics_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Filter { Latest, LatestThree, All }

class DeviceScanStatisticsHistoryModel {
  final List<DeviceScanStatisticsModel> scans;
  final Filter filter;

  DeviceScanStatisticsHistoryModel(this.scans, this.filter);
}

class DeviceScanStatisticsHistoryHandler {
  Future<List<String>> getAllScansDirectories() async {
    final Directory logRootDirectory = await getApplicationDocumentsDirectory();

    List<FileSystemEntity> entities = Directory('${logRootDirectory.path}/').listSync();
    final Iterable<Directory> directories = entities.whereType<Directory>();

    List<int> scansDate = directories.where((element) {
      // getting directories that include scans
      return int.tryParse(element.path.split('/').last) != null;
    }).map((element) {
      //finding the date of the latest Scan
      return int.tryParse(element.path.split('/').last)!;
    }).toList();
    scansDate.sort();
    List<int> scansDateSortedDec = scansDate.reversed.toList();

    List<String> scansPaths = scansDateSortedDec.map((e) {
      return '${logRootDirectory.path}/$e';
    }).toList();
    return scansPaths;
  }

  Future<DeviceScanStatisticsHistoryModel> getScans() async {
    List<DeviceScanStatisticsModel> filteredDeviceScans = [];
    List<String> scansDirectories = await getAllScansDirectories();
    Filter filter = await loadFilterFromSharedPrefernces();

    switch (filter) {
      case Filter.Latest:
        // do something
        if (scansDirectories.length >= 1) {
          scansDirectories.sublist(0, 1).forEach((element) {
            filteredDeviceScans.add(DeviceScanStatisticsBloc.currentBloc.handler
                .updateStatisticsFromDirectory(scansDirectories[0]));
          });
        }
        break;
      case Filter.LatestThree:
        if (scansDirectories.length >= 3) {
          scansDirectories.sublist(0, 3).forEach((element) {
            filteredDeviceScans.add(DeviceScanStatisticsBloc.currentBloc.handler
                .updateStatisticsFromDirectory(element));
          });
        } else {
          continue addAllScans;
        }
        break;
      addAllScans:
      case Filter.All:
        // do something else
        scansDirectories.forEach((element) {
          filteredDeviceScans.add(
              DeviceScanStatisticsBloc.currentBloc.handler.updateStatisticsFromDirectory(element));
        });
        break;
    }

    return DeviceScanStatisticsHistoryModel(filteredDeviceScans, filter);
  }

  Future<DeviceScanStatisticsHistoryModel> updateScanFilter(Filter filter) async {
    await saveFilterInSharedPrefernces(filter);
    return getScans();
  }

  Future<Filter> loadFilterFromSharedPrefernces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('filter');
    switch (prefs.getString('filter')) {
      case 'Latest':
        return Filter.Latest;
      case 'LatestThree':
        return Filter.LatestThree;
      case 'All':
        return Filter.All;
      default:
        return Filter.All;
    }
  }

  Future<void> saveFilterInSharedPrefernces(Filter filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('filter', filter.name);
  }
}

class DeviceScanStatisticsHistoryBloc
    extends AbstractBloc<DeviceScanStatisticsHistoryModel, DeviceScanStatisticsHistoryHandler> {
  /// The current instance of the Singleton.
  static final DeviceScanStatisticsHistoryBloc currentBloc = DeviceScanStatisticsHistoryBloc._();

  final handler = DeviceScanStatisticsHistoryHandler();

  /// Private Constructor for this BloC to make it a Singleton.
  DeviceScanStatisticsHistoryBloc._() {
    // call init
    loadScanHistory();
  }

  Future<void> updateScanFilter(Filter filter) async {
    DeviceScanStatisticsHistoryModel newState = await this.handler.updateScanFilter(filter);
    this.publisher.add(newState);
  }

  Future<void> loadScanHistory() async {
    DeviceScanStatisticsHistoryModel newState = await this.handler.getScans();
    this.publisher.add(newState);
  }

  Future<void> refreshScanHistory() async {
    await loadScanHistory();
  }
}
