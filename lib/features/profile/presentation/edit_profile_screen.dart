import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/profile_providers.dart';
import '../data/models/user_profile_model.dart';
import 'settings/settings_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _website;
  late UserProfileModel _initial;
  bool _showAllPins = true;

  @override
  void initState() {
    super.initState();
    _initial = ref.read(profileProvider);
    _name = TextEditingController(text: _initial.name);
    _username = TextEditingController(text: _initial.username);
    _website = TextEditingController(text: _initial.website);
    _showAllPins = _initial.showAllPins;
    _name.addListener(_changed);
    _username.addListener(_changed);
    _website.addListener(_changed);
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _website.dispose();
    super.dispose();
  }

  void _changed() => setState(() {});

  bool get _dirty =>
      _name.text != _initial.name ||
      _username.text != _initial.username ||
      _website.text != _initial.website ||
      _showAllPins != _initial.showAllPins;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            PinterestBackHeader(
              title: 'Edit profile',
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FilledButton(
                  onPressed: _dirty ? _save : null,
                  style: pinterestButtonStyle(color: pinterestRed),
                  child: const Text('Done'),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
                children: [
                  const Text(
                    'Keep your personal details private. Information you add here is visible to anyone who can view your profile.',
                    style: TextStyle(
                      color: pinterestTextGrey,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 56),
                  Center(
                    child: Column(
                      children: [
                        PinterestAvatar(
                          initial: _initial.avatarInitial,
                          radius: 82,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Avatar editing is a demo'),
                                ),
                              ),
                          style: pinterestButtonStyle(),
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 38),
                  _EditField(label: 'Name', controller: _name),
                  const SizedBox(height: 20),
                  _EditField(label: 'Username', controller: _username),
                  const SizedBox(height: 30),
                  const Text(
                    'About',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SettingsRow(
                    title: 'Tell your story',
                    onTap: () => _showTextSheet('About'),
                  ),
                  const SizedBox(height: 18),
                  _EditField(
                    label: 'Website',
                    controller: _website,
                    hint: 'Add a link to drive traffic to your site',
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Pronouns',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SettingsRow(
                    title: 'Share how you like to be referred to',
                    onTap: () => _showTextSheet('Pronouns'),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Show All Pins',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'People visiting your profile will be able to see a collection of all the Pins you saved. Pins saved to secret boards won’t be visible.',
                              style: TextStyle(
                                color: pinterestTextGrey,
                                fontSize: 16,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _showAllPins,
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF6265F6),
                        onChanged: (value) =>
                            setState(() => _showAllPins = value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextSheet(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title can be edited in the next version')),
    );
  }

  void _save() {
    ref
        .read(profileProvider.notifier)
        .update(
          _initial.copyWith(
            name: _name.text.trim(),
            username: _username.text.trim().replaceAll('@', ''),
            website: _website.text.trim(),
            showAllPins: _showAllPins,
          ),
        );
    context.pop();
  }
}

class _EditField extends StatelessWidget {
  const _EditField({required this.label, required this.controller, this.hint});

  final String label;
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 19),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white, width: 1.1),
        ),
      ),
    );
  }
}
