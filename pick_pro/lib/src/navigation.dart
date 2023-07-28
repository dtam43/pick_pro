import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

const Color background = Color.fromARGB(255, 9, 11, 16);
const Color foreground = Color.fromARGB(255, 0, 84, 181);
const Color selectedItemColor = Color.fromARGB(93, 2, 25, 65);

// SideBar for Navigating between pages
class MyNavBar extends StatelessWidget {
  // Tracking the current page
  final int index;
  MyNavBar({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color.fromARGB(255, 86, 86, 86).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1))
      ], border: const Border(top: BorderSide(color: foreground, width: 1.0))),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.gauge, color: foreground),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.listMusic, color: foreground),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.music, color: foreground),
            label: '',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        iconSize: 25,
        elevation: 150,
        selectedItemColor: selectedItemColor,
        backgroundColor: background,
        onTap: (value) {
          Navigator.pop(context);
          switch (value) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/chords');
              break;
            case 2:
              Navigator.pushNamed(context, '/player');
              break;
            default:
          }
        },
      ),
    );
  }
}
