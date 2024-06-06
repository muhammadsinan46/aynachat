import 'package:aynachat/model/models.dart';
import 'package:hive_flutter/adapters.dart';

class AuthServices {
  final Box<User> _userBox;

  AuthServices(this._userBox);

  registerUser(String username, String password) {
    final user = User(username: username, password: password);

    _userBox.put(username, user);
  }

  User? authentication(String username, String password) {
    print("calling");
    final user = _userBox.get(username);
    print(user?.username);

    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  bool isUserExist(String username) {
    return _userBox.containsKey(username);
  }
}
