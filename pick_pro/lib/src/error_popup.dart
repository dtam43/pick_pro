import 'package:flutter/material.dart';
import 'package:pick_pro/src/styles.dart';

const Color foreground = Color.fromARGB(255, 0, 84, 181);

// Overlay Popup to display in case of errors
class ErrorPopup {
  static void show(BuildContext context, String message) {
    SizeManager size = SizeManager(context);

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: 1.0,
              child: Center(
                child: Container(
                  width: size.errorWidth,
                  height: size.errorHeight,
                  decoration: BoxDecoration(
                    color: foreground.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.errorFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      overlayEntry.remove();
    });
  }
}
