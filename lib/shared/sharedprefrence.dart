import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_app/shared/components/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockableDefaultButton extends StatefulWidget {
  final String text;
  final double radius;
  final VoidCallback? onPressed;

  const LockableDefaultButton({
    Key? key,
    required this.text,
    this.radius = 0.0,
    this.onPressed,
  }) : super(key: key);

  @override
  State<LockableDefaultButton> createState() => _LockableDefaultButtonState();
}

class _LockableDefaultButtonState extends State<LockableDefaultButton> {
  bool isLocked = false;
  DateTime? lastPressedTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadLockState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadLockState() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPressedTimestamp = prefs.getInt('lockableButtonLastPressed');

    if (lastPressedTimestamp != null) {
      lastPressedTime = DateTime.fromMillisecondsSinceEpoch(
        lastPressedTimestamp,
      );
      final now = DateTime.now();
      final diff = now.difference(lastPressedTime!);
      if (diff.inSeconds < 5) {
        setState(() {
          isLocked = true;
        });
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (isLocked && lastPressedTime != null) {
        final now = DateTime.now();
        final diff = now.difference(lastPressedTime!);
        if (diff.inSeconds >= 5) {
          setState(() {
            isLocked = false;
            lastPressedTime = null;
          });
        }
      }
    });
  }

  Future<void> handlePress() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setInt('lockableButtonLastPressed', now.millisecondsSinceEpoch);
    setState(() {
      isLocked = true;
      lastPressedTime = now;
    });

    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLocked) {
      return SizedBox(
        width: double.infinity,
        child: ButtonTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 14.0),
            ),
            child: Text(
              'You have only one order per day!',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
      );
    }
    return defaultButton(
      background: secondryColor,
      function: isLocked ? () {} : handlePress,
      text: widget.text,
      radius: widget.radius,
      isDisabled: false,
    );
  }
}
