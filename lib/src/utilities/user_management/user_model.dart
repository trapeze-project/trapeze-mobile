/// This [UserModel] class represents the current logged in user.
class UserModel {
  // Currently only a username is rquired to be considered logged In
  final String _userName;

  UserModel(this._userName);

  String get userName => this._userName;

  /// Check weather a user is logged in, but in this cases only looks for a username unequal to "".
  bool get isLoggedIn => this._userName.length > 0;

  /// This dummy user factory method generates a user with an empty username.
  /// This is considered not logged in.
  static UserModel dummyUserModelFactory() {
    return UserModel("");
  }
}
