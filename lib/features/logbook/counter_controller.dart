import 'package:shared_preferences/shared_preferences.dart';

class CounterController {
  int _counter = 0;
  int _step = 1;

  final List<String> _history = [];

  int get value => _counter;
  int get step => _step;

  List<String> get history => List.unmodifiable(_history);

  void setStep(int newStep) {
    if (newStep >= 1) {
      _step = newStep;
    }
  }

  void increment() {
    _counter += _step;
    _addToHistory("User menambah nilai sebesar $_step");
  }

  void decrement() {
    if (_counter >= _step) {
      _counter -= _step;
      _addToHistory("User mengurangi nilai sebesar $_step");
    } else {
      _counter = 0;
      _addToHistory("User mencoba kurang tapi sudah 0");
    }
  }

  void reset() {
    _counter = 0;
    _addToHistory("User mereset counter ke 0");
  }

  void _addToHistory(String action) {
    String time = DateTime.now().toString().substring(11, 19);
    String entry = "$action pada jam $time";
    _history.insert(0, entry);
    if (_history.length > 5) {
      _history.removeLast();
    }
  }

  Future<void> load(String username) async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter_$username') ?? 0;
    final saved = prefs.getStringList('history_$username') ?? [];
    _history.clear();
    _history.addAll(saved);
  }

  Future<void> save(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter_$username', _counter);
    await prefs.setStringList('history_$username', _history);
  }
}