import 'package:flutternativetrapeze/src/interfaces/abstract_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/user_management/user_model.dart';
import 'package:flutternativetrapeze/src/utilities/user_management/user_handler.dart';

/// This [UserBloc] class handles the state of the [UserModel].
///
/// There are mutation functions ([login],[logout]) to mutate the state of the current [UserModel].
///```dart
/// UserBloc.currentBloc.login("TestUser");
/// ```
class UserBloc extends AbstractBloc<UserModel, UserHandler> {
  /// Initializes the [UserHandler] which performs all the state changes on the [UserModel].
  final handler = UserHandler();

  /// The current instance of the Singleton.
  static final UserBloc currentBloc = UserBloc._();

  /// The private [UserBloc] constructor initializes the bloc Singleton with a dummy empty user model.
  UserBloc._() {
    /// To get a default user on app launch
    this.publisher.add(UserModel.dummyUserModelFactory());
  }

  /// Authenticates a new user by username (Dummy Implemetation no login is being performed).
  ///
  /// Creates a new [UserModel] and adds it to the [publisher].
  void login(String username) {
    UserModel newUser = this.handler.login(username);
    this.publisher.add(newUser);
  }

  /// Logs the current user out and replaces the [UserModel] with a empty one.
  ///
  /// Creates a new empty [UserModel] and adds it to the [publisher].
  void logout() {
    UserModel newUser = this.handler.logout();
    this.publisher.add(newUser);
  }
}
