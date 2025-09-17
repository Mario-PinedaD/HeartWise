class NavigationController {
  int _currentIndex = 0;
  int _previousIndex = 0;

  int get currentIndex => _currentIndex;
  int get previousIndex => _previousIndex;

  void select(int index) {
    _previousIndex = _currentIndex;
    _currentIndex = index;
  }
}
