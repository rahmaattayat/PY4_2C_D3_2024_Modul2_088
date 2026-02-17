class LoginController {
  final Map<String, String> _users = {
    'admin': '123',
    'amaw': '456',
    'rahma': '789',  
  };

  int _failedAttempts = 0;
  bool _isBlocked = false;

  bool get isBlocked => _isBlocked;

  bool login(String username, String password) {
    if (username.trim().isEmpty || password.isEmpty) {
      return false;
    }

    if (_users.containsKey(username) && _users[username] == password) {
      _failedAttempts = 0; 
      return true;
    } else {
      _failedAttempts++;
      if (_failedAttempts >= 3) {
        _isBlocked = true;
        Future.delayed(const Duration(seconds: 10), () {
          _failedAttempts = 0;
          _isBlocked = false;
        });
      }
      return false;
    }
  }
}