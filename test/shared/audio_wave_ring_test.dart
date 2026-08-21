import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/shared/widgets/audio_wave_ring.dart';

const _voice = <double>[
  0.10, 0.08, 0.07, 0.06, 0.055, 0.05, 0.048, 0.046, 0.045, 0.044,
];

void main() {
  Widget host(double level, {Color? color, List<double> bands = _voice}) =>
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AudioWaveRing(
              level: level,
              radius: 32,
              color: color,
              bands: bands,
              child: const SizedBox(width: 64, height: 64),
            ),
          ),
        ),
      );

  Future<int> alphaAtRadius(WidgetTester tester, double distance) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.descendant(
        of: find.byType(AudioWaveRing),
        matching: find.byType(RepaintBoundary),
      ),
    );
    ByteData? pixels;
    late int width;
    late int height;
    await tester.runAsync(() async {
      final image = await boundary.toImage();
      width = image.width;
      height = image.height;
      pixels = await image.toByteData();
    });

    final centre = Offset(width / 2, height / 2);
    var maxAlpha = 0;
    const samples = 64;
    for (var i = 0; i < samples; i++) {
      final angle = i / samples * 2 * math.pi;
      var strongest = 0;
      for (var d = -2; d <= 2; d++) {
        final x = (centre.dx + math.cos(angle) * (distance + d)).round();
        final y = (centre.dy + math.sin(angle) * (distance + d)).round();
        if (x < 0 || y < 0 || x >= width || y >= height) continue;
        strongest = math.max(strongest, pixels!.getUint8((y * width + x) * 4 + 3));
      }
      maxAlpha = math.max(maxAlpha, strongest);
    }
    return maxAlpha;
  }

  Future<List<double>> ringProfile(WidgetTester tester) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.descendant(
        of: find.byType(AudioWaveRing),
        matching: find.byType(RepaintBoundary),
      ),
    );
    ByteData? pixels;
    late int width;
    late int height;
    await tester.runAsync(() async {
      final image = await boundary.toImage();
      width = image.width;
      height = image.height;
      pixels = await image.toByteData();
    });

    final centre = Offset(width / 2, height / 2);
    int alphaAt(double x, double y) {
      final px = x.round();
      final py = y.round();
      if (px < 0 || py < 0 || px >= width || py >= height) return 0;
      return pixels!.getUint8((py * width + px) * 4 + 3);
    }

    const samples = 144;
    final profile = <double>[];
    for (var i = 0; i < samples; i++) {
      final angle = i / samples * 2 * math.pi;
      var reach = 0.0;
      for (var d = 56.0; d >= 20; d -= 0.5) {
        final alpha = alphaAt(
          centre.dx + math.cos(angle) * d,
          centre.dy + math.sin(angle) * d,
        );
        if (alpha > 150) {
          reach = d;
          break;
        }
      }
      profile.add(reach);
    }
    return profile;
  }

  Future<int> anglesAtFullHeight(WidgetTester tester) async {
    final profile = await ringProfile(tester);
    final tallest = profile.reduce(math.max);
    return profile.where((reach) => reach >= tallest - 1.5).length;
  }

  testWidgets('renders its child', (tester) async {
    await tester.pumpWidget(host(0));
    await tester.pumpAndSettle();

    expect(find.byType(SizedBox), findsWidgets);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('is isolated behind a RepaintBoundary', (tester) async {
    await tester.pumpWidget(host(0.7));
    await tester.pump(const Duration(milliseconds: 200));

    expect(
      find.ancestor(
        of: find.byType(SizedBox).first,
        matching: find.byType(RepaintBoundary),
      ),
      findsWidgets,
    );
  });

  group('geometry', () {
    testWidgets('paints a ring outside the avatar while speaking', (
      tester,
    ) async {
      await tester.pumpWidget(host(1, color: const Color(0xFFFFEB3B)));
      await tester.pump(const Duration(milliseconds: 250));

      // The wave sits outside the 32px avatar
      expect(await alphaAtRadius(tester, 37), greaterThan(0));
      expect(await alphaAtRadius(tester, 12), 0);
    });

    testWidgets('paints nothing at all while silent', (tester) async {
      await tester.pumpWidget(host(0, color: const Color(0xFFFFEB3B)));
      await tester.pumpAndSettle();

      expect(await alphaAtRadius(tester, 37), 0);
    });

    testWidgets('keeps its layout footprint at the avatar size', (tester) async {
      await tester.pumpWidget(host(1));
      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.getSize(find.byType(AudioWaveRing)), const Size(64, 64));
    });
  });

  group('frequency bands', () {
    const uniform = <double>[0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4];
    const rolloff = <double>[1, 0.5, 0.25, 0.12, 0.06, 0.03, 0.02, 0.02, 0.01, 0.01];

    testWidgets('peak heights follow the band magnitudes', (tester) async {
      await tester.pumpWidget(
        host(1, color: const Color(0xFFFFEB3B), bands: uniform),
      );
      await tester.pump(const Duration(milliseconds: 250));
      final uniformPeaks = await anglesAtFullHeight(tester);

      await tester.pumpWidget(
        host(1, color: const Color(0xFFFFEB3B), bands: rolloff),
      );
      // Long enough for the blend between the two band sets to finish.
      await tester.pump(const Duration(milliseconds: 250));
      final rolloffPeaks = await anglesAtFullHeight(tester);

      expect(uniformPeaks, greaterThan(rolloffPeaks * 3));
    });

    testWidgets('stretches a squashed spectrum back into varied peaks', (
      tester,
    ) async {
      const squashed = <double>[
        0.10, 0.08, 0.07, 0.06, 0.055, 0.05, 0.048, 0.046, 0.045, 0.044,
      ];

      await tester.pumpWidget(
        host(1, color: const Color(0xFFFFEB3B), bands: uniform),
      );
      await tester.pump(const Duration(milliseconds: 250));
      final flatPeaks = await anglesAtFullHeight(tester);

      await tester.pumpWidget(
        host(1, color: const Color(0xFFFFEB3B), bands: squashed),
      );
      await tester.pump(const Duration(milliseconds: 250));
      final squashedPeaks = await anglesAtFullHeight(tester);

      expect(flatPeaks, greaterThan(squashedPeaks * 3));
    });
    group('no wave without real audio', () {
      testWidgets('draws nothing with no bands at all', (tester) async {
        await tester.pumpWidget(
          host(1, color: const Color(0xFFFFEB3B), bands: const []),
        );
        await tester.pump(const Duration(milliseconds: 250));

        expect(await alphaAtRadius(tester, 37), 0);
        expect(await alphaAtRadius(tester, 43), 0);
      });

      testWidgets('draws nothing when every band is silent', (tester) async {
        await tester.pumpWidget(
          host(
            1,
            color: const Color(0xFFFFEB3B),
            bands: const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ),
        );
        await tester.pump(const Duration(milliseconds: 250));

        expect(await alphaAtRadius(tester, 37), 0);
      });

      testWidgets('draws nothing for a band list too short to shape a wave', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(1, color: const Color(0xFFFFEB3B), bands: const [0.5, 0.5]),
        );
        await tester.pump(const Duration(milliseconds: 250));

        expect(await alphaAtRadius(tester, 37), 0);
      });

      testWidgets('draws nothing with bands but no level', (tester) async {
        await tester.pumpWidget(
          host(0, color: const Color(0xFFFFEB3B), bands: uniform),
        );
        await tester.pumpAndSettle();

        // Bands shape the wave; they never decide that there is one.
        expect(await alphaAtRadius(tester, 43), 0);
      });
    });

    testWidgets('every band stays clear of the avatar', (tester) async {
      await tester.pumpWidget(
        host(1, color: const Color(0xFFFFEB3B), bands: rolloff),
      );
      await tester.pump(const Duration(milliseconds: 250));
      final profile = await ringProfile(tester);
      expect(profile.where((reach) => reach == 0), isEmpty);
      expect(profile.reduce(math.min), greaterThan(32));
    });

    testWidgets('switching bands mid-animation does not throw', (tester) async {
      await tester.pumpWidget(host(1, bands: uniform));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpWidget(
        host(1, bands: const [0.9, 0.1, 0.7, 0.2, 0.6, 0.3, 0.5, 0.4, 0.8, 0.2]),
      );
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpWidget(host(1, bands: const []));
      await tester.pump(const Duration(milliseconds: 60));

      expect(tester.takeException(), isNull);
    });
  });

  group('ticker cost', () {
    testWidgets('a silent avatar schedules no frames', (tester) async {
      await tester.pumpWidget(host(0));
      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('a speaking avatar keeps animating', (tester) async {
      await tester.pumpWidget(host(0.8));
      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('starts animating when a silent avatar starts speaking', (
      tester,
    ) async {
      await tester.pumpWidget(host(0));
      await tester.pumpAndSettle();
      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pumpWidget(host(0.6));
      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('stops animating once the avatar goes quiet', (tester) async {
      await tester.pumpWidget(host(0.8));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.pumpWidget(host(0));
      // Long enough for the release to run out.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });

  testWidgets('disposing mid-animation does not throw', (tester) async {
    await tester.pumpWidget(host(0.8));
    await tester.pump(const Duration(milliseconds: 60));

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
