class AuthService {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String username, String password) {

    if (username == 'admin' && password == 'password') {
      _isLoggedIn = true;
      print('Logged in');
    }
  }

  void logout() {
    _isLoggedIn = false;
  }
}