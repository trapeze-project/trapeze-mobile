import 'dart:convert';
import 'package:flutternativetrapeze/src/utilities/knowledgebase/action_info.dart';
import 'package:flutternativetrapeze/src/utilities/knowledgebase/verdict_category_info.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:http/http.dart';

/// This class provides the name and the description of each [VerdictCategory], which is used as a mapping in [KnowledgebaseScreen]

class ThreatResolutionsActions {
  VerdictCategoryInfo verdictCategoryInfo;

  // these actions are sorted
  List<ActionInfo> actionsInfos = [];

  ThreatResolutionsActions._(
      {required this.verdictCategoryInfo, required this.actionsInfos}) {
    actionsInfos.sort((a, b) => a.priority.compareTo(b.priority));
  }

  static Future<ThreatResolutionsActions> create(
      VerdictCategory verdictCategory) async {
    /*
    The knowledge-base is a php-server that features an API. (see: https://github.com/trapeze-project/knowledge-base)
    The knowledge-based features an API that responds to a URL with a query like this:
        SEND:
        .../kb.php?action=threat&category[]=Adware&category[]=Unknown

        RETURN:
        [
          {
            "category": "Adware",
            "description": "Adware (advertisement software) is softwa[...]",
            "actions": [
              {
                "priority": 2,
                "description": "Install an Anti-Virus app, e.g. TotalAV[...]"
              },
              {
                "priority": 2,
                "description":"Do not download software from unknown[...]"},
              },
          [...]
          }
        ]

    The important part is the action=threat part that tells the API that we are querying knowledge on security threats.
    To provider further details on what security threats we are interested in, we specify "category[]=Adware" to query
    knowledge on Adware, and additionally (&) "category[]=Unknown", to query knowledge on an Unknown securty threat.

    The information that is queried from the knowledgebase is currently (March 2023) hardcoded.


    */
    // var url = Uri.http(
    //     'localhost:9999', '/kb.php', {'action': 'threat', 'category[]': verdictCategory.name});

    // for debugging: local endpoint: 'http://localhost:9999/kb.php?action=threat&category[]=${verdictCategory.name}');
    /* The endpoint is https://trapeze.imp.bg.ac.rs/knowledgebase and, as stated in the GitHub repository, 
       a simple user interface for querying the knowledge base is available by using ‘?action=debug’ as the 
       query and opening the URL in a browser (https://trapeze.imp.bg.ac.rs/knowledgebase/kb.php?action=debug).
    */

    var url = Uri.parse(
        'https://trapeze.imp.bg.ac.rs/knowledgebase/kb.php?action=threat&category[]=${verdictCategory.name}');

    Response response = await get(url);

    List<dynamic> data = json.decode(response.body) as List<dynamic>;

    String description = pick(data, 0, 'description').asStringOrThrow();

    VerdictCategoryInfo verdictCategoryInfo = VerdictCategoryInfo(
        verdictCategory: verdictCategory, description: description);

    List<ActionInfo> actionsInfo =
        pick(data, 0, 'actions').asListOrEmpty((pick) {
      return ActionInfo(
          description: pick('description').required().asString(),
          priority: pick('priority').required().asIntOrThrow());
    });

    return ThreatResolutionsActions._(
        verdictCategoryInfo: verdictCategoryInfo, actionsInfos: actionsInfo);
  }
}
