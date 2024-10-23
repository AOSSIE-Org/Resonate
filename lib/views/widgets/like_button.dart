import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final Color tintColor;
  final bool isLikedByUser;
  final Function(bool isFavorite) onLiked;

  const LikeButton(
      {Key? key,
      required this.tintColor,
      required this.onLiked,
      required this.isLikedByUser})
      : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isLikedByUser;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        _controller.reverse().then((value) => _controller.forward());
        await widget.onLiked(_isFavorite);
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
