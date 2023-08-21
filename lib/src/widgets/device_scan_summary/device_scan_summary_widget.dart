import 'package:flutter/material.dart';
import 'package:flutternativetrapeze/src/screens/knowledgebase/knowledgebase_screen.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart';

/// This [DeviceScanSummaryWidget] class is used to display a scan log.
/// See for instance the "Scan - Log (b)" screen and there the card underneath the header showing three unknown threats
/// in "./release-info/v0.1.0/navigation/TRAPEZE-mobile[v0.1.0]_navigation.pdf".
///
///  ____________________________________________________________________________
/// |Row_________________________________________________________________________|
/// | Text A: knowledgeBaseThreat[verdictCategory]!['name']  | Spacer  | IconButton (i) |
/// |____________________________________________________________________________|
/// |Map_________________________________________________________________________|
/// ||  Text B: "-> " + groupedThreat[verdictCategory].virusName                       ||
/// ||__________________________________________________________________________||
///
///
class DeviceScanSummaryWidget extends StatelessWidget {
  /// [VerdictCategory] which should get displayed
  final VerdictCategory verdictCategory;

  /// GroupedThreats of all, the build method looks for the given [VerdictCategory].
  final Map<VerdictCategory, List<ThreatInfo>> groupedThreat;
  const DeviceScanSummaryWidget(
      {Key? key, required this.verdictCategory, required this.groupedThreat})
      : super(key: key);

  /// This method builds a [Column] with the title of the [VerdictCategory] and the Threats in a [Column] below.
  ///
  /// All threats are colored red and [VerdictCategory]s that don't occur are colored green
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Row(
            children: [
              Text(
                // Text A
                // get verdictCategory name in sentence case
                verdictCategory.name
                    .replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), r" "),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'RobotoMono',
                    // Checks if there are threats and adjust color accordingly
                    color: this.groupedThreat[verdictCategory]!.length > 0
                        ? Colors.blueGrey
                        : Colors.greenAccent),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      KnowledgebaseScreen.routeName,
                      arguments: {
                        'verdictCategories': [verdictCategory],
                        'showThreatInfo': true,
                        'showAllRecommendedActions': false
                      },
                    );
                  },
                  icon: Icon(Icons.info_outline)),
            ],
          ),
        ),
        // Adds all the threats this may need to be scrollable if there are more threats identified this needs to change later
        ...(this.groupedThreat[verdictCategory]!.map(
              (e) => Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  // Text B
                  "-> " + e.virusName,
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontStyle: FontStyle.italic),
                ),
              ),
            )),
      ],
    );
  }
}
