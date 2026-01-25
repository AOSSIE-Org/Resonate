import 'package:flutter/material.dart';
import 'dart:math';

class ReactionFloater extends StatefulWidget {
  final String emoji;
  final VoidCallback onComplete;

  const ReactionFloater({
    super.key,
    required this.emoji,
    required this.onComplete,
  });

  @override
  State<ReactionFloater> createState() => _ReactionFloaterState();
}

class _ReactionFloaterState extends State<ReactionFloater>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;
  late double _randomX;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _randomX = (Random().nextDouble() * 100) - 50; // Random X offset (-50 to 50)

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );
    
    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: Offset(_randomX * 0.01, -2.5), // Float up significantly
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _positionAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Text(
            widget.emoji,
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
