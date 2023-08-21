import 'package:flutter/material.dart';
import 'package:flutternativetrapeze/src/utilities/user_management/user_bloc.dart';
import 'package:flutternativetrapeze/src/screens/home/home_screen.dart';

/// This [LoginScreen] class is a [StatefulWidget] with the corresponding [_LoginRouteState] class for the UI and represents the "Profile(a)" screen
/// in "./release-info/v1.0.0-dummy/navigation/TRAPEZE-mobile[v1.0.0-dummy]_navigation.pdf".
class LoginScreen extends StatefulWidget {
  /// This field is the routeName under which this page is registered in the app.
  static const String routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginRouteState createState() => _LoginRouteState();
}

/// This [_LoginRouteState] class stores the state of the [username] and [password] and implements the [build] method.
class _LoginRouteState extends State<LoginScreen> {
  /// State username variable (needs to be redone just for demo purpose).
  String username = "";

  /// State username variable (needs to be redone just for demo purpose).
  String password = "";

  /// This method returns a [AppBar] with "Login" as title.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Login",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// This method returns a InputField with a given label and a provided onChangeMethod.
  Widget _buildInputField(BuildContext context, String labelText,
      String hintText, ValueChanged<String>? onChanged) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            hintText: hintText),
        onChanged: onChanged,
      ),
    );
  }

  /// This method returns a [TextButton] which handels the forgott password behaviour.
  Widget _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        //TODO FORGOT PASSWORD SCREEN GOES HERE
      },
      child: Text(
        'Forgot Password',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
      ),
    );
  }

  /// This method returns a [Container]-button which handels the login behaviour.
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () {
          if (this.username.length > 0 && this.password.length > 0) {
            UserBloc.currentBloc.login(this.username);
            Navigator.pushNamed(context, HomeScreen.routeName);
          }
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
    );
  }

  /// This build Method gets called to build the UI. This combines the
  /// components into a [Scaffold].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInputField(
            context,
            'Username',
            'Enter valid username',
            (String value) {
              setState(() {
                this.username = value;
              });
            },
          ),
          _buildInputField(
            context,
            'Password',
            'Enter your secure password',
            (String value) {
              setState(() {
                this.password = value;
              });
            },
          ),
          _buildForgotPasswordButton(context),
          _buildLoginButton(context)
        ],
      ),
    );
  }
}
