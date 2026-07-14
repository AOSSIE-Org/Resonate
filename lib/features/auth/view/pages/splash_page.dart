import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/viewmodel/app_bootstrap_notifier.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    ref.read(appBootstrapProvider);

    Timer(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });

    await Future<void>.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    AuthState authState;
    try {
      authState = await ref.read(authSessionProvider.future);
    } catch (_) {
      authState = const AuthState.unauthenticated();
    }
    if (!mounted) return;

    final landingShown =
        ref.read(getStorageBoxProvider).read<bool>('landingScreenShown') ??
            false;

    final destination = switch (authState) {
      AuthStateAuthenticated() => RoutePaths.tabview,
      AuthStateNeedsOnboarding() => RoutePaths.onboarding,
      AuthStateBlocked() => RoutePaths.userBlocked,
      _ => landingShown ? RoutePaths.welcome : RoutePaths.landing,
    };
    if (context.mounted) context.go(destination);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgBlackColor,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: UiSizes.height_200,
                  width: UiSizes.width_140,
                  child: Image.asset(
                    AppImages.resonateLogoImage,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: UiSizes.width_5),
                SizedBox(
                  height: UiSizes.height_140,
                  width: UiSizes.width_20,
                  child: VerticalDivider(
                    width: UiSizes.width_20,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                SizedBox(width: UiSizes.width_10),
                SizedBox(
                  height: UiSizes.height_200,
                  width: UiSizes.width_140,
                  child: Image.asset(
                    AppImages.aossieLogoImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
