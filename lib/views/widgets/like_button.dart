import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final Color tintColor;
  final bool isLikedByUser;
  final Function(bool isFavorite) onLiked;

  const LikeButton({
    super.key,
    required this.tintColor,
    required this.onLiked,
    required this.isLikedByUser,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isLikedByUser;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Bounce animation sequence
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.2),
        weight: 40,
      ), // Scale up
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 0.9),
        weight: 30,
      ), // Overshoot
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0),
        weight: 30,
      ), // Settle back
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Color transition animation
    _colorAnimation = ColorTween(begin: Colors.grey, end: widget.tintColor)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(
              0.0,
              0.5,
            ), // Color change happens in first half
          ),
        );

    // Initialize animation state based on initial favorite status
    if (_isFavorite) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLikedByUser != oldWidget.isLikedByUser) {
      setState(() {
        _isFavorite = widget.isLikedByUser;
      });
      if (_isFavorite) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() => _isFavorite = !_isFavorite);

        if (_isFavorite) {
          await _controller.forward(from: 0.0);
        } else {
          await _controller.reverse();
        }

        widget.onLiked(_isFavorite);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 40,
              color: _colorAnimation.value,
            ),
          );
        },
      ),
    );
  }
}
