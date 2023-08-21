import 'package:flutter/material.dart';
import 'package:flutternativetrapeze/main.dart';

/// Rounded card widget.
///  ________________
/// | title          |
/// | _______________|
/// | child          |
/// |________________|
class DeviceScanInfoWidget extends StatelessWidget {
  final double elevation = 6;

  final EdgeInsets padding = const EdgeInsets.all(10);

  final TextStyle titleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  /// Tweaks the ThreatTextSize of the [BaseCardWidget]
  final double _threatTextSize = 16;

  /// Tweaks the color of the resoved threats of the [BaseCardWidget]

  final DeviceScanStatisticsModel deviceScan;

  const DeviceScanInfoWidget({Key? key, required this.deviceScan})
      : super(key: key);

  Widget _buildConditionalShowDetailsTextButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          DeviceScanStatisticsBloc.currentBloc
              .updateStatisticsfromModel(deviceScan);
          // Navigator.pushNamed(context, ThreatResolutionConfigurationScreen.routeName);
          Navigator.pushNamed(context, DeviceScanLogScreen.routeName);
        },
        child: const Text(
          'show scan log',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  /// Build method
  @override
  Widget build(BuildContext context) {
    return BaseCardWidget(
      elevation: elevation,
      padding: padding,
      title: Text(
        "Scan: " + deviceScan.lastScanned.toString().split(".")[0],
        style: titleStyle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Threats identified: " + deviceScan.identifiedThreats.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _threatTextSize,
              color: deviceScan.identifiedThreats == 0
                  ? Colors.black
                  : Colors.green,
            ),
          ),
          _buildConditionalShowDetailsTextButton(context),
        ],
      ),
    );
  }
}
