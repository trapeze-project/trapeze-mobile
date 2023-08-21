import 'dart:core';

import 'package:kaspersky_sdk/kaspersky_sdk.dart';

/// This [DeviceScanStatisticsModel] class represents a scanlog with all the information that a supposed scan could deliver.
class DeviceScanStatisticsModel {
  /// Result of Easy Scanner
  // final EasyResult easyResult;

  /// Amount of Identified Threats equals the sum of the reslovedThreats and the unresolvedThreat
  final int identifiedThreats;

  /// Amount of already resolved Threats
  final int resolvedThreats;

  /// Amount of open Threats
  final int unresolvedThreats;

  /// [DateTime] of the last Scan.
  final DateTime lastScanned;

  /// GroupedThreats is a Map of Threats corresponing to a ThreatType
  final Map<VerdictCategory, List<ThreatInfo>> verdictCategoryToThreatInfosMap;

  DeviceScanStatisticsModel(
    this.identifiedThreats,
    this.resolvedThreats,
    this.unresolvedThreats,
    this.lastScanned,
    this.verdictCategoryToThreatInfosMap,
  );
}
