import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget defaultButton({
  required VoidCallback function,
  required String text,
  double radius = 0.0,
  bool isDisabled = false,
}) => ElevatedButton(
  onPressed: isDisabled ? null : function,
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
  ),
  child: Text(text),
);

// StatefulWidget يطبق قفل 24 ساعة على الزر
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadLockState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadLockState() async {
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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (isLocked && lastPressedTime != null) {
        final now = DateTime.now();
        final diff = now.difference(lastPressedTime!);
        if (diff.inHours >= 24) {
          setState(() {
            isLocked = false;
            lastPressedTime = null;
          });
        }
      }
    });
  }

  Future<void> _handlePress() async {
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
    return defaultButton(
      function: isLocked ? () {} : _handlePress,
      text: isLocked ? 'You have only one order per day! ' : widget.text,
      radius: widget.radius,
      isDisabled: false,
    );
  }
}
