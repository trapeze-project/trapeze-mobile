import 'package:flutternativetrapeze/src/utilities/user_management/user_model.dart';

/// This [UserHandler] class has the implementation for all the mutations in the [UserBloc].
///
/// - with the follwing mutations [login],[logout]
class UserHandler {
  /// This method returns a new [UserModel] with a given username.
  UserModel login(String username) {
    return UserModel(username);
  }

  /// This method returns a new [UserModel] with a empty username (which simulates the logout).
  UserModel logout() {
    return UserModel("");
  }
}
