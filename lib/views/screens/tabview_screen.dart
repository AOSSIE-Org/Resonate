import 'dart:developer';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/auth/viewmodel/email_verify_notifier.dart';
import 'package:resonate/features/rooms/view/pages/create_room_page.dart';
import 'package:resonate/features/rooms/view/pages/room_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/utils/utils.dart';
import 'package:resonate/views/screens/explore_screen.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/widgets/pair_chat_dialog.dart';
import 'package:resonate/views/widgets/profile_avatar.dart';

class TabViewScreen extends ConsumerStatefulWidget {
  const TabViewScreen({super.key});

  @override
  ConsumerState<TabViewScreen> createState() => _TabViewScreenState();
}

class _TabViewScreenState extends ConsumerState<TabViewScreen> {
  final TabViewController _tabController = Get.find<TabViewController>();
  bool _isRoomCreating = false;

  Future<void> _onDonePressed(BuildContext context) async {
    final index = _tabController.getIndex();
    if (index == 2) {
      if (_isRoomCreating) return;
      setState(() => _isRoomCreating = true);
      try {
        final room = await createRoomFormKey.currentState?.submit();
        if (!context.mounted) return;
        if (room != null) {
          await openRoomSheet(context, room);
        }
        _tabController.setIndex(0);
        if (createRoomFormKey.currentState?.isScheduled ?? false) {
          isLiveSelected = false;
        }
      } catch (e) {
        log('Room creation error: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create room: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isRoomCreating = false);
      }
    } else {
      context.push(RoutePaths.createStoryScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: UiSizes.size_56,
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context)!.title,
            style: TextStyle(
              fontSize: UiSizes.size_26,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          centerTitle: false,
          actions: [profileAvatar(context)],
        ),
        floatingActionButton: (_tabController.getIndex() == 0)
            ? SpeedDial(
                icon: Icons.add_call,
                childrenButtonSize: Size(UiSizes.width_56, UiSizes.height_56),
                activeIcon: Icons.close,
                elevation: 8.0,
                spacing: 10,
                spaceBetweenChildren: 6,
                animationCurve: Curves.elasticInOut,
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.multitrack_audio, size: UiSizes.size_24),
                    label: AppLocalizations.of(context)!.audioRoom,
                    labelStyle: TextStyle(fontSize: UiSizes.size_14),
                    onTap: () async {
                      final user = currentAuthUser;
                      if (user == null) return;
                      if (user.isEmailVerified) {
                        _tabController.setIndex(2);
                        return;
                      }
                      AppUtils.showDialog(
                        context: context,
                        title: AppLocalizations.of(
                          context,
                        )!.emailVerificationRequired,
                        middleText: AppLocalizations.of(
                          context,
                        )!.emailVerificationMessage,
                        onFirstBtnPressed: () async {
                          final navigator = Navigator.of(
                            context,
                            rootNavigator: true,
                          );
                          final router = GoRouter.of(context);
                          Navigator.of(context).pop();
                          AppUtils.showBlurredLoaderDialog(context);
                          final result = await rootContainer
                              .read(emailVerifyProvider.notifier)
                              .sendOtp(email: user.email);
                          navigator.pop();

                          if (result.sent) {
                            router.push(RoutePaths.emailVerification);
                          }
                        },
                        onSecondBtnPressed: () => Navigator.of(context).pop(),
                        firstBtnText: AppLocalizations.of(context)!.verify,
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(
                      Icons.people_alt_rounded,
                      size: UiSizes.size_24,
                    ),
                    label: AppLocalizations.of(context)!.pairChat,
                    labelStyle: TextStyle(fontSize: UiSizes.size_14),
                    onTap: () {
                      Get.put<PairChatController>(PairChatController());
                      buildPairChatDialog(context);
                    },
                  ),
                ],
              )
            : FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: _isRoomCreating ? null : () => _onDonePressed(context),
                child: _isRoomCreating
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        _tabController.getIndex() == 2
                            ? Icons.done
                            : Icons.audiotrack_rounded,
                        size: UiSizes.size_24,
                      ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          height: UiSizes.size_56,
          activeColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withAlpha(30)
              : Colors.white.withAlpha(30),
          splashRadius: 0,
          shadow: const Shadow(color: Colors.transparent),
          iconSize: UiSizes.size_30,
          icons: const [Icons.home_rounded, Icons.search],
          leftCornerRadius: 30.0,
          rightCornerRadius: 30.0,
          notchMargin: UiSizes.size_8,
          activeIndex: _tabController.getIndex(),
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.defaultEdge,
          borderWidth: 0.0,
          borderColor: Colors.transparent,
          onTap: (index) => _tabController.setIndex(index),
        ),
        body: (_tabController.getIndex() == 0)
            ? const HomeScreen()
            : (_tabController.getIndex() == 2)
                ? CreateRoomPage()
                : const ExploreScreen(),
      ),
    );
  }
}
