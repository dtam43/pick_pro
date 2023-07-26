import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// SideBar for Navigating between pages
class MyDrawer extends StatelessWidget {
  // Tracking the current page
  final int index;
  MyDrawer({required this.index});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 89, 152, 129),
      width: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 65,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 0 ? 1 : 0.6,
                child: const Icon(
                  LucideIcons.home,
                  size: 30,
                  color: Colors.white,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 1 ? 1 : 0.6,
                child: const Icon(
                  LucideIcons.gauge,
                  size: 30,
                  color: Colors.white,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/metronome');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 2 ? 1 : 0.6,
                child: const Icon(
                  LucideIcons.listMusic,
                  size: 30,
                  color: Colors.white,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chords');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Opacity(
                opacity: index == 3 ? 1 : 0.6,
                child: const Icon(
                  LucideIcons.music,
                  size: 30,
                  color: Colors.white,
                )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/player');
            },
          ),
        ],
      ),
    );
  }
}
