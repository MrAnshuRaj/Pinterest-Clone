import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class CountryRegionScreen extends ConsumerStatefulWidget {
  const CountryRegionScreen({super.key});

  @override
  ConsumerState<CountryRegionScreen> createState() =>
      _CountryRegionScreenState();
}

class _CountryRegionScreenState extends ConsumerState<CountryRegionScreen> {
  final _controller = ScrollController();

  static const _countries = [
    'Afghanistan (افغانستان)',
    'Aland Islands',
    'Albania (Shqipëria)',
    'Algeria (الجزائر)',
    'American Samoa',
    'Andorra',
    'Angola',
    'Anguilla',
    'Antarctica',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia (Հայաստան)',
    'Aruba',
    'Australia',
    'Austria (Österreich)',
    'Azerbaijan (Azərbaycan)',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Belgium',
    'Brazil',
    'Canada',
    'China',
    'France',
    'Germany',
    'India',
    'Italy',
    'Japan',
    'United Kingdom',
    'United States',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 18, 22, 0),
                  child: PinterestBackHeader(title: 'Country/Region'),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.fromLTRB(22, 22, 48, 28),
                    itemCount: _countries.length,
                    itemBuilder: (context, index) {
                      final country = _countries[index];
                      return InkWell(
                        onTap: () {
                          ref
                              .read(profileProvider.notifier)
                              .setCountry(country.split(' (').first);
                          context.pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            country,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 6,
              top: 210,
              bottom: 92,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''))
                    GestureDetector(
                      onTap: () => _jump(letter),
                      child: Text(
                        letter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _jump(String letter) {
    final index = _countries.indexWhere(
      (country) => country.startsWith(letter),
    );
    if (index < 0) return;
    _controller.animateTo(
      index * 58,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }
}
