import 'package:flutter/material.dart' hide Actions;
import 'package:flutternativetrapeze/src/utilities/knowledgebase/action_info.dart';
import 'package:flutternativetrapeze/src/utilities/knowledgebase/mapping_service.dart';
import 'package:readmore/readmore.dart';
import 'package:flutternativetrapeze/src/utilities/knowledgebase/threat_resolution_actions.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart' show VerdictCategory;

/// This [KnowledgebaseScreen] class represents the "KnowledgeBase" page in the drawio sketch v4.
class KnowledgebaseScreen extends StatelessWidget {
  /// This field is the routName under which this page is registered in the app.
  static const String routeName = "/knowledgebase";

  /// This method returns a [AppBar] with "Knowledgebase" as title.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Knowledgebase",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  /// This method returns a [Widget] with the knowledegbase-threat-type.
  Widget _buildTitleCardThreatInfo(BuildContext context, String verdictName) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Threat-Type: " + verdictName,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        elevation: 4);
  }

  /// This method creates the readmore cards with the description or the actions text from the knowledge base.
  ///
  /// title ["Description","Actions"] and text is the corresponding text.
  Widget _buildTextCardThreatInfo(
      BuildContext context, ThreatResolutionsActions threatResolutionsActions) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.deepPurple,
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            SizedBox(
              height: 10,
            ),
            ReadMoreText(
              threatResolutionsActions.verdictCategoryInfo.description,
              trimLines: 8,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: ' show less',
              delimiter: " ",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Recommended Actions',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.deepPurple,
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            SizedBox(
              height: 10,
            ),
            //     return actionInfoList.asMap().entries.map((entry) => Text('${entry.key + 1}- ' + entry.value.description)).toList();

            ...(threatResolutionsActions.actionsInfos.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      '${entry.key + 1}- ' + entry.value.description + '\n',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildThreatInfoComponent(
      BuildContext context, ThreatResolutionsActions threatResolutionsActions) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 5,
      radius: Radius.circular(20),
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        children: [
          _buildTitleCardThreatInfo(
              context, threatResolutionsActions.verdictCategoryInfo.name),
          _buildTextCardThreatInfo(context, threatResolutionsActions),
        ],
      ),
    );
  }

  Widget _buildTitleCardRecommendedActions(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Recommended Actions",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        elevation: 4);
  }

  Widget _buildTextCardRecommendedActions(BuildContext context,
      List<ThreatResolutionsActions> threatResolutionsActions) {
    List<ActionInfo> recommendedActions = (threatResolutionsActions
        .map((e) => e.actionsInfos)
        .expand((i) => i)
        .toList());
    // sort actions
    recommendedActions.sort((a, b) => a.priority.compareTo(b.priority));
    List<String> recommendedActionsDescriptions = recommendedActions
        .map((e) => e.description)
        .toList()
        .toSet()
        .toList(); // .toSet().toList() deleted duplicates

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              'Summary',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Colors.deepPurple,
              ),
            ),
            Divider(
              thickness: 1.2,
            ),
            SizedBox(
              height: 10,
            ),
            ...recommendedActionsDescriptions.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      '${entry.key + 1}- ' + entry.value + '\n',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedActionsComponent(BuildContext context,
      List<ThreatResolutionsActions> threatResolutionsActions) {
    return Scrollbar(
      thumbVisibility: true,
      thickness: 5,
      radius: Radius.circular(20),
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        children: [
          _buildTitleCardRecommendedActions(context),
          _buildTextCardRecommendedActions(context, threatResolutionsActions)
        ],
      ),
    );
  }

  /// This build Method gets called to build the UI. This combines the
  /// components into a [Scaffold]. Espescially parses the knowledge base and puts all information from it
  /// into a [ListView].
  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final verdictCategories =
        routes['verdictCategories'] as List<VerdictCategory>;

    final showThreatInfo = routes['showThreatInfo'] as bool;
    final showAllRecommendedActions =
        routes['showAllRecommendedActions'] as bool;
    print(verdictCategories);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<ThreatResolutionsActions>>(
          future: MappingService.knowledgeBaseThreatResolutionsActions(
              verdictCategories: verdictCategories),
          builder: (context,
              AsyncSnapshot<List<ThreatResolutionsActions>> snapshot) {
            if (snapshot.hasData) {
              if (showThreatInfo) {
                return _buildThreatInfoComponent(context, snapshot.data!.first);
              } else if (showAllRecommendedActions) {
                return _buildRecommendedActionsComponent(
                    context, snapshot.data!);
              } else {
                return Text("Knowledgebase screen is unavailable");
              }
            } else {
              return Text("Knowledgebase screen is unavailable");
            }
          }),
    );
  }
}
