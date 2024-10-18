import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final Color tintColor;
  const LikeButton({Key? key, required this.tintColor}) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  bool _isFavorite = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        _controller.reverse().then((value) => _controller.forward());
      },
      child: ScaleTransition(
        scale: Tween(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: _isFavorite
            ? Icon(
                Icons.favorite,
                size: 40,
                color: widget.tintColor,
              )
            : const Icon(
                Icons.favorite_border,
                size: 40,
              ),
      ),
    );
  }
}
