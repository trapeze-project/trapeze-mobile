import 'dart:core';
import 'package:flutternativetrapeze/src/utilities/knowledgebase/threat_resolution_actions.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart'
    show EasyResult, ThreatInfo, VerdictCategory;

enum ThreatResolutionAction {
  antivirus,
  backupData,
  vpn,
  thirdpartyDownload,
  securitySoftware,
  updatePermission,
  avoidUnsecureWifi,
  updatePhoneVersion,
  randomPassword,
  avoidLinks,
  uninstallApps,
  googlePlayProtect,
  savedPassword,
  factoryReset,
  clearStorage,
  unknown,
}

class MappingService {
  /// The [MappingService] class handles mapping information on threats identifies by the Kaspersky Mobile Security SDK (e.g. instances of [EasyResult])
  /// into an output format that the app will display in the "Device Scan Log Screen" (see for instance: './release-info/v0.1.0/TRAPEZE-mobile[v0.1.0]_navigation.pdf').
  /// The output format is a VerdictCategoryToThreatInfosMap (Map<VerdictCategory, List<ThreatInfo>>). Here, a verdict category
  /// is one of a fixed list of threat categories (this is defined by the Kaspersky Mobile Security SDK (see for instance: file:///Users/snet/Documents/H2020%20Projekte/2021/TRAPEZE/work%20packages/work%20package%204/TUB/mobile-app/Kaspersky%20SDK/android/5.13.0.136/KL_Mobile_SDK_Android_5.13.0.136_Release_Trapeze_(EuroComission)/manuals/Kaspersky%20Mobile%20Security%20SDK/javadoc/com/kavsdk/antivirus/VerdictCategory.html))
  /// VerdictCategories:
  /// ##################
  ///   * Adware
  ///   * DestructiveMalware
  ///   * Monitor
  ///   * PswTool
  ///   * RemoteAdmin
  ///   * Unknown
  ///
  /// Every malware/riskware threat identified by the Kaspersky Mobile Security SDK is associated to a file, we will call this the threat file.
  /// Every threat file is associated to a ThreatInfo that contains information on the specific threat file such as the path to the file and a
  /// list of VerdictCategories associated.
  ///
  /// EXAMPLE:
  /// #########
  /// Consider for example that an EasyResult contains information on a single malicious file we call "ThreatFile1".
  /// "ThreatFile1" is associated to the VerdictCategories 'Adware' and 'DestructiveMalware'.
  /// The UI in the "Device Scan Log Screen" would display this information in the following fashion:
  ///
  /// UI:
  ///
  /// Threats:
  ///   Adware
  ///     -> ThreatFile1
  ///   DestructiveMalware
  ///     -> ThreatFile1
  ///
  /// Data:
  ///
  /// Threats:
  ///   VerdictCategory1:
  ///     -> ThreatFiles that have VerdictCategory1
  ///   VerdictCategory2:
  ///     -> ThreatFiles that have VerdictCategory2
  ///
  /// The UI thus requires a Map<VerdictCategory:ThreatFiles>. This Map is produced by the method (I.) in the below.
  ///
  /// This class provides the following functionality:
  /// (I.) Map information from an [EasyResult] into a VerdictCatgegoryToThreatInfosMap
  ///
  /// private methods
  /// (_II.) Convert an [EasyResult] instance into a Map<ThreatInfo, List<VerdictCategory>>
  /// (_III.) Reverse a Map<ThreatInfo, List<VerdictCategory>> into a Map<VerdictCategory, List<ThreatInfo>>

  // (I.) Convert an [EasyResult] instance into a VertictCategoryToThreatInfosMap
  static Map<VerdictCategory, List<ThreatInfo>>
      getVerdictCategoryToThreatInfosMap(EasyResult easyResult) {
    // (_II.) Convert an [EasyResult] instance into a Map<ThreatInfo, List<VerdictCategory>>
    Map<ThreatInfo, List<VerdictCategory>> threatInfoToVerdictCategoriesMap =
        getThreatInfoToVerdictCategoriesMap(easyResult);
    // (_III.) Reverse a Map<ThreatInfo, List<VerdictCategory>> into a Map<VerdictCategory, List<ThreatInfo>>
    return _reverseMap(threatInfoToVerdictCategoriesMap);
  }

  // (_II.) Convert an [EasyResult] instance into a Map<ThreatInfo, List<VerdictCategory>>
  static Map<ThreatInfo, List<VerdictCategory>>
      getThreatInfoToVerdictCategoriesMap(EasyResult easyResult) {
    // This function takes an EasyResult object and extracts a map of ThreatInfo to List<VerdictCategory>.
    // See the kaspersky_sdk package for details. Roughly, every ThreatInfo describes a category of a security threat such as "virus"
    // and a verdict category denotes
    // input:
    //  * EasyResult easyResult:
    // output:
    //  * Map<> result:

    // initialize resultMap
    Map<ThreatInfo, List<VerdictCategory>> resultMap = new Map();
    // concatenate the lists of detected malware and riskware to a list of threatInfos
    List<ThreatInfo> threatInfos =
        easyResult.malwareList.followedBy(easyResult.riskwareList).toList();
    // for every threatInfo in threatInfos
    for (ThreatInfo threatInfo in threatInfos) {
      List<VerdictCategory> verdictCategoriesForThreatInfo;
      // select its corresponding verdictCategories
      if (threatInfo.categories.isEmpty) {
        verdictCategoriesForThreatInfo = <VerdictCategory>[];
      } else {
        verdictCategoriesForThreatInfo = threatInfo.categories;
      }
      // and append (threatInfo: unique verdictCategoriesForThreatInfo) to the resultMap
      if (verdictCategoriesForThreatInfo.isNotEmpty) {
        resultMap[threatInfo] =
            verdictCategoriesForThreatInfo.toSet().toList(); //.toList();
      }
    }
    return resultMap;
  }

  // (_III.) Reverse a Map<ThreatInfo, List<VerdictCategory>> into a Map<VerdictCategory, List<ThreatInfo>>
  static Map<VerdictCategory, List<ThreatInfo>> _reverseMap(
      Map<ThreatInfo, List<VerdictCategory>> map) {
    // Example:
    //  * input :  {a: [1, 2], b: [2, 3]}   (map)
    //  * output: {1:[a], 2:[a,b], 3: [b]}  (reversedMap)

    // select unique values of the input map
    var mapValues = map.values.expand((i) => i).toSet();
    // construct the reversedMap (see Example)
    Map<VerdictCategory, List<ThreatInfo>> reversedMap = new Map.fromIterable(
        mapValues,
        key: (mapValue) => mapValue,
        value: (mapValue) => map.keys
            .where((i) => map[i]?.contains(mapValue) ?? false)
            .toList());

    return reversedMap;
  }

  static Future<List<ThreatResolutionsActions>>
      knowledgeBaseThreatResolutionsActions(
          {required List<VerdictCategory> verdictCategories}) async {
    return await Future.wait(verdictCategories.map((verdictCategory) async =>
        await ThreatResolutionsActions.create(verdictCategory)));
  }

  // static Future<ActionInfo> knowledgeBaseActionInfo(
  //     ThreatResolutionAction threatResolutionAction) async {
  //   return await ActionInfo.create(threatResolutionAction);
  // }

  // static Future<VerdictCategoryInfo> knowledgeBaseVerdictCategoryInfo(
  //     {required VerdictCategory verdictCategory}) async {
  //   return await VerdictCategoryInfo.create(verdictCategory);
  // }
}
