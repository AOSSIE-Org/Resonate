import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';
import 'package:resonate/utils/app_images.dart';

class AboutAppScreen extends StatelessWidget {
  AboutAppScreen({super.key});

  final AboutAppScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;
            
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLogoSection(isSmallScreen),
                  const SizedBox(height: 24),
                  _buildActionSection(),
                  const SizedBox(height: 32),
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),
                  _buildLinksSection(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoSection(bool isSmallScreen) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 1 : 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _LogoCard(
          image: AppImages.resonateLogoImage,
          title: "Resonate",
          subtitle: Obx(() => Text(
            "${controller.appVersion} | ${controller.appBuildNumber}",
            style: Theme.of(Get.context!).textTheme.bodySmall,
          )),
        ),
        _LogoCard(
          image: AppImages.aossieLogoImage,
          title: "AOSSIE",
          subtitle: Text(
            "Open Source Community",
            style: Theme.of(Get.context!).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Help us grow",
              style: Theme.of(Get.context!).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.share,
                  label: "Share",
                  onTap: () => Share.share(
                    'Check out Resonate - The voice-based social media app! '
                    'Download it now: https://play.google.com/store/apps/details?id=org.aossie.resonate',
                  ),
                ),
                _ActionButton(
                  icon: Icons.star,
                  label: "Rate",
                  onTap: () => _launchUrl('https://playstore.com/resonate'),
                ),
                _ActionButton(
                  icon: Icons.update,
                  label: "Check Update",
                  onTap: controller.checkForUpdate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: Theme.of(Get.context!).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          controller.fullDescription,
          maxLines: controller.showFullDescription.value ? null : 4,
          overflow: TextOverflow.fade,
        ),
        if (!controller.showFullDescription.value)
          TextButton(
            onPressed: controller.toggleDescription,
            child: const Text("Read More"),
          ),
      ],
    ));
  }

  Widget _buildLinksSection(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _LinkButton(
          text: "Privacy Policy",
          onPressed: () => _launchUrl('https://resonate.privacy'),
        ),
        _LinkButton(
          text: "Terms of Service",
          onPressed: () => _launchUrl('https://resonate.terms'),
        ),
        _LinkButton(
          text: "View Source Code",
          onPressed: () => _launchUrl('https://github.com/aossie/resonate'),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class _LogoCard extends StatelessWidget {
  final String image;
  final String title;
  final Widget subtitle;

  const _LogoCard({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                cacheWidth: 200,
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            subtitle,
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _LinkButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
