import 'dart:convert';
import 'dart:io';

import 'package:kaspersky_sdk/kaspersky_sdk.dart';

import 'package:flutternativetrapeze/main.dart';
import 'package:flutternativetrapeze/src/config/constants.dart' as Constants;
import 'package:flutternativetrapeze/src/utilities/knowledgebase/mapping_service.dart';

/// This [DeviceScanStatisticsHandler] class has the implementation for all the mutations in the [DeviceScanStatisticsBloc].
///
/// - with the follwing mutations [updateStatistics], [updateStatisticsfromModel], [updateStatisticsfromResolveModel]
class DeviceScanStatisticsHandler {
  static final String _logFileName = Constants.LOG_FILE_NAME;

  DeviceScanStatisticsModel updateStatisticsFromDirectory(String dirPath) {
    DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(int.parse(dirPath.split('/').last));
    File resultsFile =
        File('$dirPath${dirPath.endsWith('/') ? '' : '/'}$_logFileName');
    String json = resultsFile.readAsStringSync();
    dynamic decodedJson = jsonDecode(json);
    EasyResult easyResult = EasyResult.fromJson(decodedJson['EasyResult']);
    Map<VerdictCategory, List<ThreatInfo>> map =
        MappingService.getVerdictCategoryToThreatInfosMap(easyResult);

    int numOfIdentifiedThreats =
        easyResult.malwareList.length + easyResult.riskwareList.length;
    int numOfResolvedThreats = 0;
    int numOfUnresolvedThreats =
        easyResult.malwareList.length + easyResult.riskwareList.length;

    // if some of the threats are resolved then read from ModifiedEasyResult
    // EasyResult contains the original scan
    // ModifiedEasyResult contains all unresolved threats
    // ModifiedEasyResult is created after ThreadResolution process
    if (decodedJson['ModifiedEasyResult'] != null) {
      EasyResult modifiedEasyResult =
          EasyResult.fromJson(decodedJson['ModifiedEasyResult']);
      map =
          MappingService.getVerdictCategoryToThreatInfosMap(modifiedEasyResult);

      numOfUnresolvedThreats = modifiedEasyResult.malwareList.length +
          modifiedEasyResult.riskwareList.length;

      numOfResolvedThreats = numOfIdentifiedThreats - numOfResolvedThreats;
    }

    return DeviceScanStatisticsModel(numOfIdentifiedThreats,
        numOfResolvedThreats, numOfUnresolvedThreats, timestamp, map);
  }

  /// This method just creates a new [DeviceScanStatisticsModel] from the given parameters.
  DeviceScanStatisticsModel updateStatistics(
    int identifiedThreats,
    int resolvedThreats,
    int unresolvedThreats,
    DateTime lastScanned,
    Map<VerdictCategory, List<ThreatInfo>> verdictCategoryMappedThreatInfo,
  ) {
    return DeviceScanStatisticsModel(
      identifiedThreats,
      resolvedThreats,
      unresolvedThreats,
      lastScanned,
      verdictCategoryMappedThreatInfo,
    );
  }

  /// This method just creates a deepcopy of a [DeviceScanStatisticsModel] and returns it.
  DeviceScanStatisticsModel updateStatisticsfromModel(
      DeviceScanStatisticsModel model) {
    return DeviceScanStatisticsModel(
      model.identifiedThreats,
      model.resolvedThreats,
      model.unresolvedThreats,
      model.lastScanned,
      model.verdictCategoryToThreatInfosMap,
    );
  }
}
