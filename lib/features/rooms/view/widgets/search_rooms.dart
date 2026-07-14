import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SearchOverlay extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onClose;
  final bool isSearching;
  final bool isVisible;

  const SearchOverlay({
    super.key,
    required this.onSearchChanged,
    required this.onClose,
    this.isSearching = false,
    required this.isVisible,
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  FocusNode? _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _searchController.addListener(() {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
      });
      widget.onSearchChanged(_searchController.text);
    });

    if (widget.isVisible) {
      _animationController.forward();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode?.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(SearchOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _focusNode?.requestFocus();
        });
      } else {
        _focusNode?.unfocus();
        _animationController.reverse();
        _searchController.clear();
        _hasText = false;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _closeOverlay() {
    _focusNode?.unfocus();
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _closeOverlay();
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value * 100),
              child: Container(
                margin: EdgeInsets.all(UiSizes.size_16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(UiSizes.size_12),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: UiSizes.height_8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _closeOverlay,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.searchRooms,
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: UiSizes.width_8,
                            vertical: UiSizes.height_12,
                          ),
                        ),
                        onChanged: (value) {
                          widget.onSearchChanged(value);
                        },
                        onSubmitted: (value) {
                          _focusNode?.unfocus();
                        },
                      ),
                    ),
                    if (widget.isSearching)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: UiSizes.width_10,
                        ),
                        child: SizedBox(
                          width: UiSizes.width_16,
                          height: UiSizes.height_16,
                          child: CircularProgressIndicator(
                            strokeWidth: UiSizes.width_2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    else if (_hasText)
                      IconButton(
                        onPressed: _clearSearch,
                        icon: Icon(
                          Icons.clear,
                          size: UiSizes.size_20,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        tooltip: AppLocalizations.of(context)!.clear,
                      )
                    else
                      SizedBox(width: UiSizes.width_56),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
