abstract class BottomNavigationEvent {}

class BottomNavigationItemTapped extends BottomNavigationEvent {
  final int index;
  BottomNavigationItemTapped(this.index);
}