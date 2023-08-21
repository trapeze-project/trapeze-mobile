import 'package:flutter/material.dart';

/// This [DeviceScanProgressWidget] class displays a donut which is used as an indicator for the scanprogress in [DeviceScanScreen] and [ThreatResolutionScreen].
/// See for instance the "Scan-Pending" screen in "./release-info/v0.1.0/navigation/TRAPEZE-mobile[v0.1.0]_navigation.pdf".
///
///  ______________________________________________
/// |Stack_________________________________________|
/// ||CircularProgressIndicator                   ||
/// ||                  ______._______            ||
/// ||                /   TextA:       \          ||
/// ||               | progressString  |          ||
/// ||                \ ______._______/           ||
/// ||____________________________________________||
/// |                Text B: currentTask           |
/// |______________________________________________|
///
///
class DeviceScanProgressWidget extends StatelessWidget {
  /// Progress value form 0 to 100 as [double].
  final double progress;

  final String currentTask;

  DeviceScanProgressWidget({this.progress = 0, this.currentTask = '...'});

  /// This method builds a [SizedBox] with the [_radius] as width and height and places the Circle inside.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(alignment: Alignment.center, children: [
          SizedBox(
            width: _radius,
            height: _radius,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: _strokeWidth,
            ),
          ),
          Text( //Text A
            progressString,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: _fontSize),
          ),
        ]),
        Text( // Text B
          currentTask,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: _fontSize),
        ),
      ],
    );
  }

  /// This getter turns the progress into a procent [String].
  String get progressString => ((this.progress * 100).toInt()).toString() + "%";

  /// Tweak for the StrokeWidth
  final double _strokeWidth = 12.0;

  /// Tweak for the Radius
  final double _radius = 200.0;

  /// Tweak for the Fontsize of the procent [String].
  final double _fontSize = 40.0;
}
