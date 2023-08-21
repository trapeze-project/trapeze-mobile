import 'package:test/test.dart';
import 'package:flutternativetrapeze/src/utilities/knowledgebase/mapping_service.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart';

void main() {
  group('map easy result to info types', () {
    test('Mapping multiple categories', () {
      ThreatInfo threatInfo = ThreatInfo(
        [VerdictCategory.Adware, VerdictCategory.Monitor],
        'fileFullPath',
        'objectName',
        'packageName',
        SeverityLevel.Medium,
        'virusName',
        false,
        false,
        false,
      );
      EasyResult easyResult = EasyResult(
        10,
        11,
        [threatInfo],
        20,
        21,
        [],
        true,
      );
      Map<ThreatInfo, List<InfoType>> map =
          MappingService.mapEasyResultToInfoTypes(easyResult);
      List<InfoType> infoTypes = map[threatInfo]!;
      expect(infoTypes.length, 1);
      expect(infoTypes.contains(InfoType.spyware), true);
    });
    test('Mapping one categories', () {
      ThreatInfo threatInfo = ThreatInfo(
        [VerdictCategory.Adware],
        'fileFullPath',
        'objectName',
        'packageName',
        SeverityLevel.Medium,
        'virusName',
        false,
        false,
        false,
      );
      EasyResult easyResult = EasyResult(
        10,
        11,
        [threatInfo],
        20,
        21,
        [],
        true,
      );
      Map<ThreatInfo, List<InfoType>> map =
          MappingService.mapEasyResultToInfoTypes(easyResult);
      List<InfoType> infoTypes = map[threatInfo]!;
      expect(infoTypes.length, 1);
      expect(infoTypes.contains(InfoType.spyware), true);
    });

    test('Empty verdical category list', () {
      ThreatInfo threatInfo = ThreatInfo([], 'fileFullPath', 'objectName',
          'packageName', SeverityLevel.Low, 'virusName', false, false, false);
      EasyResult easyResult = EasyResult(
        10,
        10,
        [threatInfo],
        9,
        0,
        [],
        false,
      );
      Map<ThreatInfo, List<InfoType>> map =
          MappingService.mapEasyResultToInfoTypes(easyResult);
      List<InfoType> infoTypes = map[threatInfo]!;
      expect(infoTypes.isEmpty, true);
    });

    test('Mapping does not contain duplicates - duplicate category', () {
      ThreatInfo threatInfo = ThreatInfo(
          [VerdictCategory.PswTool, VerdictCategory.PswTool],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Low,
          'virusName',
          false,
          false,
          false);
      EasyResult easyResult = EasyResult(
        10,
        10,
        [threatInfo],
        9,
        0,
        [],
        false,
      );
      Map<ThreatInfo, List<InfoType>> map =
          MappingService.mapEasyResultToInfoTypes(easyResult);
      List<InfoType> infoTypes = map[threatInfo]!;
      expect(infoTypes.length, 2);
      expect(infoTypes.contains(InfoType.keylogger), true);
      expect(infoTypes.contains(InfoType.spyware), true);
    });
    test('one threat info without category, one with category', () {
      ThreatInfo withoutVerdict = ThreatInfo([], 'fileFullPath', 'objectName',
          'packageName', SeverityLevel.Low, 'virusName', false, false, false);
      ThreatInfo withVerdict = ThreatInfo(
          [VerdictCategory.DestructiveMalware],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Low,
          'virusName',
          false,
          false,
          false);
      EasyResult easyResult =
          EasyResult(10, 10, [withoutVerdict, withVerdict], 9, 0, [], false);
      Map<ThreatInfo, List<InfoType>> map =
          MappingService.mapEasyResultToInfoTypes(easyResult);
      List<InfoType>? emptyInfoTypes = map[withoutVerdict];
      expect(emptyInfoTypes != null, true,
          reason:
              'list of into types for threat info without verdict category is null');
      expect(emptyInfoTypes!.isEmpty, true,
          reason:
              'list of into types for threat info without verdict category has elements');
      List<InfoType>? nonEmptyInfoTypes = map[withVerdict];
      expect(nonEmptyInfoTypes != null, true,
          reason:
              'list of into types for threat info with verdict category is null');
      expect(nonEmptyInfoTypes!.isNotEmpty, true,
          reason:
              'list of into types for threat info with verdict category has no elements');
    });
  });
  group('reverse dictionary tests', () {
    test('empty map', () {
      Map<InfoType, List<ThreatInfo>> map =
          MappingService.reverseDictionary({});
      expect(map.isEmpty, true, reason: 'empty map must result in empty map');
    });
    test('empty list', () {
      ThreatInfo threatInfo = ThreatInfo(
          [VerdictCategory.Adware],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Medium,
          'virusName',
          false,
          false,
          false);
      Map<ThreatInfo, List<InfoType>> threatInfoMap = {
        threatInfo: [],
      };
      Map<InfoType, List<ThreatInfo>> map =
          MappingService.reverseDictionary(threatInfoMap);
      expect(map.length, 0);
    });
    test('empty list and non-empty list', () {
      ThreatInfo threatInfo = ThreatInfo(
          [VerdictCategory.Adware],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Medium,
          'virusName',
          false,
          false,
          false);
      ThreatInfo threatInfo2 = ThreatInfo(
          [VerdictCategory.DestructiveMalware],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Medium,
          'virusName',
          false,
          false,
          false);
      Map<ThreatInfo, List<InfoType>> threatInfoMap = {
        threatInfo: [],
        threatInfo2: [InfoType.malware]
      };
      Map<InfoType, List<ThreatInfo>> map =
          MappingService.reverseDictionary(threatInfoMap);
      expect(map.length, 1);
      List<ThreatInfo>? threats = map[InfoType.malware];
      expect(threats == null, false);
      expect(threats!.length, 1);
      expect(threats[0], threatInfo2);
    });
    test('simple map', () {
      ThreatInfo threatInfo = ThreatInfo(
          [VerdictCategory.Adware],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Medium,
          'virusName',
          false,
          false,
          false);
      Map<ThreatInfo, List<InfoType>> threatInfoMap = {
        threatInfo: [InfoType.spyware],
      };
      Map<InfoType, List<ThreatInfo>> map =
          MappingService.reverseDictionary(threatInfoMap);
      expect(map.length, 1);
      List<ThreatInfo>? threats = map[InfoType.spyware];
      expect(threats == null, false);
      expect(threats!.length, 1);
      expect(threats[0], threatInfo);
    });
    test('map with duplicates', () {
      ThreatInfo threatInfo = ThreatInfo(
          [VerdictCategory.Adware],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Medium,
          'virusName',
          false,
          false,
          false);
      ThreatInfo threatInfo2 = ThreatInfo(
          [VerdictCategory.DestructiveMalware],
          'fileFullPath',
          'objectName',
          'packageName',
          SeverityLevel.Medium,
          'virusName',
          false,
          false,
          false);
      Map<ThreatInfo, List<InfoType>> threatInfoMap = {
        threatInfo: [InfoType.spyware],
        threatInfo2: [InfoType.spyware, InfoType.malware],
      };
      Map<InfoType, List<ThreatInfo>> map =
          MappingService.reverseDictionary(threatInfoMap);
      expect(map.length, 2);
      List<ThreatInfo>? threats = map[InfoType.spyware];
      expect(threats == null, false);
      expect(threats!.length, 2);
      expect(threats.contains(threatInfo), true);
      expect(threats.contains(threatInfo2), true);
      List<ThreatInfo>? threats2 = map[InfoType.malware];
      expect(threats2 == null, false);
      expect(threats2!.length, 1);
      expect(threats2[0], threatInfo2);
    });
  });
  group('map info types to solutions and actions', () {
    test('empty info types', () {
      List<InfoType> infoTypes = [];
      List<Actions> actions = MappingService.mapInfoTypesToActions(infoTypes);
      expect(actions.isEmpty, true);
    });
    test('single info type', () {
      List<InfoType> infoTypes = [InfoType.fakeapps];
      List<Actions> actions = MappingService.mapInfoTypesToActions(infoTypes);
      expect(actions.isNotEmpty, true);
    });
    test('duplicate info type', () {
      List<InfoType> infoTypes = [InfoType.fakeapps, InfoType.fakeapps];
      List<Actions> actions = MappingService.mapInfoTypesToActions(infoTypes);
      expect(actions.length == actions.toSet().length, true);
    });
    test('two info type with same solution', () {
      List<InfoType> infoTypes = [InfoType.fakeapps, InfoType.rootedphone];
      List<Actions> actions = MappingService.mapInfoTypesToActions(infoTypes);
      expect(actions.length == actions.toSet().length, true);
    });
    test('each info type has at least one solution', () {
      for (InfoType infoType in InfoType.values) {
        List<Actions> actions =
            MappingService.mapInfoTypesToActions([infoType]);
        expect(actions.isNotEmpty, true,
            reason: '$verdictCategory has no solutions / actions');
      }
    });
  });
}
