abstract class BottomNavigationState {
  final int selectedIndex;
  BottomNavigationState(this.selectedIndex);
}

class BottomNavigationInitial extends BottomNavigationState {
  BottomNavigationInitial() : super(0); // Default to Home (index 0)
}

class BottomNavigationUpdated extends BottomNavigationState {
  BottomNavigationUpdated(super.selectedIndex);
}