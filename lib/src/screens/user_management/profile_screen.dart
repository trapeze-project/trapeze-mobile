import 'package:flutter/material.dart';
import 'package:flutternativetrapeze/src/utilities/user_management/user_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/user_management/user_model.dart';
import 'package:flutternativetrapeze/src/screens/home/home_screen.dart';
import 'package:flutternativetrapeze/src/widgets/base_widgets/base_card_widget.dart';
import 'package:flutternativetrapeze/src/widgets/base_widgets/base_elevated_button_widget.dart';

/// This [ProfileScreen] class represents the "Profile(b)" screen in "./release-info/v1.0.0-dummy/navigation/TRAPEZE-mobile[v1.0.0-dummy]_navigation.pdf".
class ProfileScreen extends StatelessWidget {
  /// This field is the routeName under which this page is registered in the app.
  static const String routeName = '/profile';

  const ProfileScreen ({Key? key}) : super(key: key);

  /// This method builds the [AppBar] for the [Scaffold] and sets the title to the "Scan Log".
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("User", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  /// This method builds the user card displaying the the username of the logged in user.
  StreamBuilder _buildUserCard(BuildContext context) {
    return StreamBuilder(
        stream: UserBloc.currentBloc.bloc,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel model = snapshot.data as UserModel;
            return BaseCardWidget(
              elevation: _elevation,
              padding: _padding,
              title: Text("Logged in as:", style: _textStyle),
              child: Text(
                model.userName,
              ),
            );
          } else {
            return Text("No user logged in...");
          }
        });
  }

  /// This build Method gets called to build the UI. This combines the
  /// components into a [Scaffold].
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          _buildUserCard(context),
          Spacer(),
          BaseElevatedButtonWidget(
            width: 215,
            onPressed: () {
              UserBloc.currentBloc.logout();
              Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
            },
            name: "Logout",
          ),
          SizedBox(
            height: 4,
          ),
          BaseElevatedButtonWidget(
            onPressed: () {},
            width: 215,
            height: 50,
            name: "Privacy Dashboard",
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }

  /// Tweak for the elevation of the [BaseCardWidget].
  final double _elevation = 6;

  /// Tweak for the Title of the [BaseCardWidget].
  static final TextStyle _textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  /// Tweak for the padding of the UserInfo.
  static final EdgeInsets _padding = EdgeInsets.all(15);
}
