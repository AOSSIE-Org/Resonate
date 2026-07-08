import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/rooms/model/rooms_state.dart';
import 'package:resonate/features/rooms/view/widgets/live_room_tile.dart';
import 'package:resonate/features/rooms/view/widgets/no_room_view.dart';
import 'package:resonate/features/rooms/view/widgets/search_rooms.dart';
import 'package:resonate/features/rooms/view/widgets/upcoming_room_tile.dart';
import 'package:resonate/features/rooms/viewmodel/rooms_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/upcoming_rooms_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

bool isLiveSelected = true;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showSearchOverlay = false;
  String _upcomingQuery = '';

  Future<void> _pullToRefresh() async {
    await ref.read(upcomingRoomsProvider.notifier).refresh();
    await ref.read(roomsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(roomsProvider);
    final upcomingAsync = ref.watch(upcomingRoomsProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBarLiveRoom(
                    isLiveSelected: isLiveSelected,
                    onTabSelected: (selectedTab) {
                      setState(() {
                        isLiveSelected = selectedTab;
                        _showSearchOverlay = false;
                        _upcomingQuery = '';
                      });
                      ref.read(roomsProvider.notifier).clearLiveSearch();
                    },
                    onSearchTapped: () =>
                        setState(() => _showSearchOverlay = true),
                  ),
                  SizedBox(height: UiSizes.height_16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _pullToRefresh,
                      child: isLiveSelected
                          ? _LiveRoomsListView(
                              loading: roomsAsync.isLoading,
                              state: roomsAsync.value,
                              error: roomsAsync.hasError ? roomsAsync.error : null,
                            )
                          : _UpcomingRoomsListView(
                              loading: upcomingAsync.isLoading,
                              rooms: upcomingAsync.value ?? const [],
                              query: _upcomingQuery,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            SearchOverlay(
              isVisible: _showSearchOverlay,
              onSearchChanged: (query) {
                if (isLiveSelected) {
                  ref.read(roomsProvider.notifier).searchLiveRooms(query);
                } else {
                  setState(() => _upcomingQuery = query);
                }
              },
              onClose: () {
                setState(() {
                  _showSearchOverlay = false;
                  _upcomingQuery = '';
                });
                ref.read(roomsProvider.notifier).clearLiveSearch();
              },
              isSearching: false,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBarLiveRoom extends StatelessWidget {
  const CustomAppBarLiveRoom({
    super.key,
    required this.isLiveSelected,
    required this.onTabSelected,
    required this.onSearchTapped,
  });
  final Function(bool) onTabSelected;
  final VoidCallback onSearchTapped;
  final bool isLiveSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTabSelected(true),
          child: Text(
            AppLocalizations.of(context)!.live.toUpperCase(),
            style: TextStyle(
              color: isLiveSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: UiSizes.width_25),
        GestureDetector(
          onTap: () => onTabSelected(false),
          child: Text(
            AppLocalizations.of(context)!.upcoming.toUpperCase(),
            style: TextStyle(
              color: !isLiveSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onSearchTapped,
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
            size: UiSizes.size_24,
          ),
          tooltip: AppLocalizations.of(context)!.search,
        ),
      ],
    );
  }
}

class _LiveRoomsListView extends StatelessWidget {
  const _LiveRoomsListView({
    required this.loading,
    required this.state,
    required this.error,
  });
  final bool loading;
  final RoomsState? state;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    if (loading && state == null) {
      return Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Theme.of(context).colorScheme.primary,
          size: MediaQuery.of(context).devicePixelRatio * 20,
        ),
      );
    }
    if (state is! RoomsStateReady) {
      // Falls through here on error too — show the empty state instead of
      // rendering blank or a noisy error UI.
      return const NoRoomView(isRoom: true);
    }
    final ready = state as RoomsStateReady;
    final roomsToShow = ready.searchBarIsEmpty ? ready.rooms : ready.filteredRooms;

    if (roomsToShow.isNotEmpty) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: roomsToShow.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: UiSizes.height_8),
            child: CustomLiveRoomTile(appwriteRoom: roomsToShow[index]),
          );
        },
      );
    }
    return ready.searchBarIsEmpty
        ? const NoRoomView(isRoom: true)
        : _NoSearchResults();
  }
}

class _UpcomingRoomsListView extends StatelessWidget {
  const _UpcomingRoomsListView({
    required this.loading,
    required this.rooms,
    required this.query,
  });
  final bool loading;
  final List<AppwriteUpcomingRoom> rooms;
  final String query;

  List<AppwriteUpcomingRoom> _filtered() {
    if (query.isEmpty) return rooms;
    final lower = query.toLowerCase();
    return rooms.where((r) {
      return r.name.toLowerCase().contains(lower) ||
          r.description.toLowerCase().contains(lower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Theme.of(context).colorScheme.primary,
          size: MediaQuery.of(context).devicePixelRatio * 20,
        ),
      );
    }
    final roomsToShow = _filtered();

    if (roomsToShow.isNotEmpty) {
      return ListView.builder(
        itemCount: roomsToShow.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: UiSizes.height_8),
            child: UpcomingListTile(appwriteUpcomingRoom: roomsToShow[index]),
          );
        },
      );
    }
    return rooms.isEmpty && query.isEmpty
        ? const NoRoomView(isRoom: false)
        : _NoSearchResults();
  }
}

class _NoSearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: UiSizes.size_65,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: UiSizes.height_16),
          Text(
            AppLocalizations.of(context)!.noSearchResults,
            style: TextStyle(
              fontSize: UiSizes.size_16,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: UiSizes.height_8),
          Text(
            AppLocalizations.of(context)!.clearSearch,
            style: TextStyle(
              fontSize: UiSizes.size_14,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
