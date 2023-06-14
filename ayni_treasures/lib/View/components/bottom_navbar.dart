import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles.dart';
import 'singleton_envVar.dart';
class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});
  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/Home.svg'),
            activeIcon: SvgPicture.asset('assets/icons/HomeActive.svg'),
            label: 'Inicio',
            backgroundColor: customWhite,
          ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/Shop.svg'),
            activeIcon: SvgPicture.asset('assets/icons/ShopActive.svg'),
            label: 'Tienda',
            backgroundColor: customWhite,
          ),
        
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/LocationTick.svg'),
            activeIcon: SvgPicture.asset('assets/icons/LocationTickActive.svg'),
            label: 'Prensa',
            backgroundColor: customWhite,
          ),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/School.svg'),
            activeIcon: SvgPicture.asset('assets/icons/SchoolActive.svg'),
            label: 'Escuela',
            backgroundColor: customWhite,
          ),
      ],
      selectedItemColor: customSecondary,
      unselectedItemColor: customDarkGray,
      selectedLabelStyle: const TextStyle(fontSize:16),
      unselectedLabelStyle: const TextStyle(fontSize:16),
      currentIndex: appData.singletonIndex,
      onTap: (int index) {
          switch (index) {
            case 0:
              // only scroll to top when current index is selected.
              /*if (_selectedIndex == index) {
                
              }*/
              _showFirstPage(context);
            break;
            case 1:
              _showSecondPage(context);
            break;
            case 2:
              _showThirdPage (context);
            break;
          }
          setState(
            () {
              appData.singletonIndex=index;
              //_selectedIndex = appData.singletonIndex;
            },
          );
        },
    );
  }

  void _showFirstPage(BuildContext context){
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/home');
  }
  void _showSecondPage(BuildContext context){
    //Navigator.pop(context);
    Navigator.of(context).pushNamed('/store');
  }
  void _showThirdPage(BuildContext context){
    //Navigator.pop(context);
    Navigator.of(context).pushNamed('/press');
  }
}