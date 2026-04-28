import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/profile_providers.dart';
import 'settings_widgets.dart';

class BirthdateSettingsScreen extends ConsumerStatefulWidget {
  const BirthdateSettingsScreen({super.key});

  @override
  ConsumerState<BirthdateSettingsScreen> createState() =>
      _BirthdateSettingsScreenState();
}

class _BirthdateSettingsScreenState
    extends ConsumerState<BirthdateSettingsScreen> {
  late DateTime _initial;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _initial = ref.read(profileProvider).birthday;
    _selected = _initial;
  }

  bool get _changed =>
      _selected.year != _initial.year ||
      _selected.month != _initial.month ||
      _selected.day != _initial.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: PinterestBackHeader(title: 'Birthdate'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
                children: [
                  const Text(
                    'To help keep Pinterest safe, we now require your birthdate. Your birthdate also helps us provide more personalized recommendations and relevant ads. We won’t share this information without your permission and it won’t be visible on your profile.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 44),
                  SizedBox(
                    height: 210,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: _selected,
                        maximumDate: DateTime.now(),
                        minimumYear: 1900,
                        maximumYear: DateTime.now().year,
                        onDateTimeChanged: (value) =>
                            setState(() => _selected = value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 38),
                  const Text(
                    'If this is a business account, use your own birthdate.',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _changed
                      ? () {
                          ref
                              .read(profileControllerProvider)
                              .setBirthday(_selected);
                          context.pop();
                        }
                      : null,
                  style: pinterestButtonStyle(
                    color: _changed ? pinterestRed : pinterestGrey,
                  ),
                  child: const Text('Update'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
