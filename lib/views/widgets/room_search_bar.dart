import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RoomSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String)? onSearchSubmit;
  final VoidCallback? onClear;
  final bool isSearching;

  const RoomSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onSearchSubmit,
    this.onClear,
    this.isSearching = false,
  });

  @override
  State<RoomSearchBar> createState() => RoomSearchBarState();
}

class RoomSearchBarState extends State<RoomSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  FocusNode? _focusNode;
  bool _isExpanded = false;
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
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _searchController.addListener(() {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
      });
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        _focusNode?.requestFocus();
      });
    } else {
      _animationController.reverse();
      _focusNode?.unfocus();
      _searchController.clear();
      widget.onSearchChanged('');
      if (widget.onClear != null) {
        widget.onClear!();
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasText = false;
    });
    widget.onSearchChanged('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  void clearSearch() {
    _clearSearch();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty && widget.onSearchSubmit != null) {
      _focusNode?.unfocus();
      widget.onSearchSubmit!(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isExpanded,
      onPopInvokedWithResult: (didPop, result) {
        if (_isExpanded && !didPop) {
          _toggleSearch();
        }
      },
      child: GestureDetector(
        onTap: () {
          if (!_isExpanded) {
            _toggleSearch();
          }
        },
        child: Container(
          height: UiSizes.height_60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiSizes.size_25),
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: UiSizes.width_56,
                height: UiSizes.height_56,
                child: _isExpanded
                    ? IconButton(
                        onPressed: _toggleSearch,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),

              Expanded(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return _isExpanded
                        ? Opacity(
                            opacity: _fadeAnimation.value,
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              autofocus: false,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(
                                  context,
                                )!.searchRooms,
                                hintStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
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
                                _performSearch();
                              },
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: UiSizes.width_56),
                            child: Text(
                              AppLocalizations.of(context)!.searchRooms,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          );
                  },
                ),
              ),
              if (_isExpanded)
                widget.isSearching
                    ? Padding(
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
                    : _hasText
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: _performSearch,
                            icon: Icon(
                              Icons.search,
                              size: UiSizes.size_20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            tooltip: AppLocalizations.of(context)!.search,
                          ),
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
                          ),
                        ],
                      )
                    : SizedBox(width: UiSizes.width_56),
            ],
          ),
        ),
      ),
    );
  }
}
