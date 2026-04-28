import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/settings_providers.dart';
import 'settings_widgets.dart';

class PrivacyDataScreen extends ConsumerWidget {
  const PrivacyDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pinterestSettingsProvider);
    final controller = ref.read(settingsControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          children: [
            const PinterestBackHeader(title: 'Privacy and data'),
            const SizedBox(height: 28),
            const Text(
              'Manage the data Pinterest shares with advertisers and uses to improve the ads and recommendations we show you. Learn more',
              style: TextStyle(
                color: pinterestTextGrey,
                fontSize: 20,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Device settings take precedence over the settings below. To learn more, visit our Help Center or Privacy Policy.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 32),
            const _Section('Ads personalization'),
            _PrivacySwitch(
              title: 'Use info from sites you visit',
              subtitle:
                  'Allow Pinterest to use data from sites you visit to improve ads on Pinterest. Learn more',
              value: settings.useInfoFromSites,
              onChanged: (value) =>
                  controller.setPrivacyToggle('useInfoFromSites', value),
            ),
            _PrivacySwitch(
              title: 'Use of partner info',
              subtitle:
                  'Allow Pinterest to use information from our partners to improve ads you see on Pinterest. Learn more',
              value: settings.usePartnerInfo,
              onChanged: (value) =>
                  controller.setPrivacyToggle('usePartnerInfo', value),
            ),
            _PrivacySwitch(
              title: 'Ads about Pinterest',
              subtitle:
                  'Allow Pinterest to use your activity to improve the ads about Pinterest you’re shown on other sites or apps. Learn more',
              value: settings.adsAboutPinterest,
              onChanged: (value) =>
                  controller.setPrivacyToggle('adsAboutPinterest', value),
            ),
            _PrivacySwitch(
              title: 'Activity for ads reporting',
              subtitle:
                  'Allow Pinterest to share your activity for ads performance reporting. Learn more',
              value: settings.activityForAdsReporting,
              onChanged: (value) =>
                  controller.setPrivacyToggle('activityForAdsReporting', value),
            ),
            _PrivacySwitch(
              title: 'Sharing info with partners',
              subtitle:
                  'Allow Pinterest to share your information and Pinterest activity with partners to improve the third-party ads you’re shown on Pinterest. Learn more',
              value: settings.sharingInfoWithPartners,
              onChanged: (value) =>
                  controller.setPrivacyToggle('sharingInfoWithPartners', value),
            ),
            _PrivacySwitch(
              title: 'Ads off Pinterest',
              subtitle:
                  'Allow Pinterest to use or share your information with partners to improve the ads you’re shown on other apps and sites. Learn more',
              value: settings.adsOffPinterest,
              onChanged: (value) =>
                  controller.setPrivacyToggle('adsOffPinterest', value),
            ),
            const SizedBox(height: 24),
            const _Section('GenAI'),
            _PrivacySwitch(
              title: 'Use your data to train Pinterest Canvas',
              subtitle:
                  'Allow your data to be used to help train Pinterest Canvas. Learn more',
              value: settings.useDataToTrainCanvas,
              onChanged: (value) =>
                  controller.setPrivacyToggle('useDataToTrainCanvas', value),
            ),
            const SizedBox(height: 24),
            const _Section('Manage your data'),
            SettingsRow(
              title: 'Delete your data and account',
              subtitle: 'Delete your data and account',
              onTap: () => context.push('/profile/settings/delete-account'),
            ),
            SettingsRow(
              title: 'Request your data',
              subtitle:
                  'Request a copy of the info Pinterest collects about you. Learn more',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data request is a demo action')),
              ),
            ),
            const SizedBox(height: 24),
            const _Section('Cached data'),
            SettingsRow(
              title: 'Clear app cache',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App cache cleared in demo')),
              ),
            ),
            SettingsSwitchRow(
              title: 'Autoplay videos on cellular data',
              value: settings.autoplayVideosOnCellular,
              onChanged: (value) => controller.setPrivacyToggle(
                'autoplayVideosOnCellular',
                value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacySwitch extends StatelessWidget {
  const _PrivacySwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsSwitchRow(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 21),
    );
  }
}
