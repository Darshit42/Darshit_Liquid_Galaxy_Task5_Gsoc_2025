import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../pages/Chat.dart';
import '../pages/Profile.dart';
import '../pages/Setting.dart';
import '../pages/search.dart';
import './rive/items.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final List<GlobalKey> _navKeys = List.generate(4, (index) => GlobalKey());

  final List<Widget> _screens = [
    HomePage(),
    Search(),
    Profile(),
    Notifications(),
  ];

  void _onRiveInit(Artboard artboard, int index) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      bottomNavs[index].stateMachineName,
    );

    if (controller != null) {
      artboard.addController(controller);
      bottomNavs[index].input = controller.findInput<bool>("active") as SMIBool;
    }
  }

  void _onNavItemTap(int index) {
    if (_selectedIndex != index) {
      if (bottomNavs[index].input != null) {
        bottomNavs[index].input!.change(true);
        Future.delayed(const Duration(milliseconds: 800), () {
          bottomNavs[index].input?.change(false);
        });
      }

      setState(() {
        _selectedIndex = index;
      });
    }
  }

  double _getIndicatorPosition(int index) {
    if (_navKeys[index].currentContext != null) {
      final RenderBox container = context.findRenderObject() as RenderBox;
      final RenderBox icon =
      _navKeys[index].currentContext!.findRenderObject() as RenderBox;
      final containerPosition = container.localToGlobal(Offset.zero);
      final iconPosition = icon.localToGlobal(Offset.zero);
      return iconPosition.dx - containerPosition.dx;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Color.fromRGBO(18, 18, 18, 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                bottomNavs.length,
                    (index) => GestureDetector(
                  key: _navKeys[index],
                  onTap: () => _onNavItemTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Color.fromRGBO(56, 36,56, 1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RiveAnimation.asset(
                          "assets/animated_icon_set.riv",
                          artboard: bottomNavs[index].artboard,
                          onInit: (artboard) => _onRiveInit(artboard, index),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bottomNavs[index].title,
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.white
                              : Color.fromRGBO(130, 130, 130, 1),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              bottom: -5,
              left: _getIndicatorPosition(_selectedIndex) - 15,
              child: Container(
                width: 30,
                height: 3.5,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.6),
                      blurRadius: 18,
                      spreadRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var nav in bottomNavs) {
      nav.input?.controller.dispose();
    }
    super.dispose();
  }
}