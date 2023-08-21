import 'package:flutter/material.dart';
import 'package:flutternativetrapeze/src/screens/knowledgebase/knowledgebase_screen.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics/device_scan_statistics_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_statistics/device_scan_statistics_model.dart';
import 'package:flutternativetrapeze/src/widgets/base_widgets/base_card_widget.dart';
import 'package:flutternativetrapeze/src/widgets/base_widgets/base_elevated_button_widget.dart';
import 'package:flutternativetrapeze/src/widgets/device_scan_summary/device_scan_summary_widget.dart';
import 'package:kaspersky_sdk/kaspersky_sdk.dart';

/// This [DeviceScanLogScreen] class represents the "Scan - Log" screen in "./release-info/v1.0.0-dummy/navigation/TRAPEZE-mobile[v1.0.0-dummy]_navigation.pdf".
class DeviceScanLogScreen extends StatelessWidget {
  /// This field is the routeName under which this page is registered in the app.
  static const String routeName = '/device_scan_log';

  /// This method builds the [AppBar] for the [Scaffold] and sets the title to the "Scan Log".
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Scan Log",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
    );
  }

  /// This method builds the Threats based on the [DeviceScanStatisticsModel] and puts them into a [Column].
  Widget _buildThreatView(
      BuildContext context, DeviceScanStatisticsModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 8, top: 6, bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...model.verdictCategoryToThreatInfosMap.keys.map((e) =>
              DeviceScanSummaryWidget(
                  verdictCategory: e,
                  groupedThreat: model.verdictCategoryToThreatInfosMap))
        ],
      ),
    );
  }

  Widget _buildWhatToDoButton(
      BuildContext context, List<VerdictCategory> verdictCategories) {
    return Center(
      child: BaseElevatedButtonWidget(
        onPressed: () {
          Navigator.pushNamed(
            context,
            KnowledgebaseScreen.routeName,
            arguments: {
              'verdictCategories': verdictCategories,
              'showThreatInfo': false,
              'showAllRecommendedActions': true
            },
          );
        },
        name: "What can I do?",
      ),
    );
  }

  /// This build Method gets called to build the UI. This combines the
  /// components into a [Scaffold].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: StreamBuilder(
          stream: DeviceScanStatisticsBloc.currentBloc.bloc,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              DeviceScanStatisticsModel model =
                  (snapshot.data as DeviceScanStatisticsModel);
              if (model.identifiedThreats > 0) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 5,
                        radius: Radius.circular(20),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 10),
                          children: [
                            BaseCardWidget(
                              padding: _padding,
                              elevation: _elevation,
                              title: Text(
                                "Scan: " +
                                    model.lastScanned.toString().split(".")[0],
                                style: _titleStyle,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Threats:", style: _listTitleTextStyle),
                                  _buildThreatView(context,
                                      model) // render the detected threats into the BaseCardWidget; this includes the small info icon to the right of every detected threat
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    _buildWhatToDoButton(context,
                        model.verdictCategoryToThreatInfosMap.keys.toList()),
                    SizedBox(
                      height: 40,
                    )
                  ],
                );
              } else {
                return Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'No security threats have been identified.',
                        style: const TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Text("Error");
            }
          },
        ),
      ),
    );
  }

  /// Tweak for the Title of the [BaseCardWidget]
  final TextStyle _titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  final TextStyle _listTitleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 18,
  );

  /// Tweak for the elevation of the [BaseCardWidget]
  final double _elevation = 6;

  /// Tweak for the padding of the threats
  final EdgeInsets _padding = EdgeInsets.all(5);
}
