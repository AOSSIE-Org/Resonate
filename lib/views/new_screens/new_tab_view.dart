import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:resonate/views/new_screens/new_create_no_room_screen.dart';
import 'package:resonate/views/new_screens/new_create_room_screen.dart';
import 'package:resonate/views/new_screens/new_home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _bottomNavBarController = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PersistentTabView(
        context,
        margin: const EdgeInsets.symmetric(horizontal: 7),
        controller: _bottomNavBarController,
        screens: _buildScreens(),
        items: _navBarsItems(context),
        // confineInSafeArea: true,
        bottomScreenMargin: 30, //! very important
        backgroundColor: Theme.of(context).colorScheme.secondary,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(30.0),
          colorBehindNavBar: Colors.transparent,
          border: Border.all(
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
        ),
        navBarStyle:
            NavBarStyle.style16, // Choose the nav bar style with this property.
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [
    // NewNoRoomScreen(),
    const NewHomeScreen(),
    Container(), // empty screen
    NewNoRoomScreen(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems(context) {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: ("Home"),
      //! check it in ui
      activeColorPrimary: Theme.of(context).colorScheme.primary,
      inactiveColorPrimary: Theme.of(context).colorScheme.onTertiary,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(
        Icons.add,
        //! check it in ui
        color: Colors.white,
      ),
      onPressed: (context) {
        showStartRoomBottomSheet(context!);
      },
      //! check it in ui
      activeColorPrimary: Theme.of(context).colorScheme.primary,
      opacity: .5,
      inactiveColorPrimary: Theme.of(context).colorScheme.onTertiary,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.profile_circled),
      title: ("Profile"),
      //! check it in ui
      inactiveColorPrimary: Theme.of(context).colorScheme.onTertiary,
      activeColorPrimary: Theme.of(context).colorScheme.primary,
    ),
  ];
}
