import 'package:kaspersky_sdk/kaspersky_sdk.dart';

/// This class provides the name and the description of each [VerdictCategory], which is used as a mapping in [KnowledgebaseScreen]

class VerdictCategoryInfo {
  VerdictCategory verdictCategory = VerdictCategory.Unknown;
  String description = '';

  String get name {
    String nameInPascalCase = verdictCategory.name;
    String nameInSentenceCase =
        nameInPascalCase.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" ");
    return nameInSentenceCase;
  }

  VerdictCategoryInfo(
      {required this.verdictCategory, required this.description});
}
