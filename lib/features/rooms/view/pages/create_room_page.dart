import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/viewmodel/create_room_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:textfield_tags/textfield_tags.dart';

final GlobalKey<CreateRoomPageState> createRoomFormKey =
    GlobalKey<CreateRoomPageState>();

class CreateRoomPage extends ConsumerStatefulWidget {
  CreateRoomPage({Key? key}) : super(key: key ?? createRoomFormKey);

  @override
  ConsumerState<CreateRoomPage> createState() => CreateRoomPageState();
}

class CreateRoomPageState extends ConsumerState<CreateRoomPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextfieldTagsController _tagsController = TextfieldTagsController();

  bool _isScheduled = false;
  String? _scheduledDateTimeIso;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _dateTimeController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  String? _validateTag(dynamic tag) {
    if (tag is String && tag.trim().isValidTag) return null;
    return '${AppLocalizations.of(context)!.invalidTags} $tag';
  }

  String _formatTzOffset(String offset, bool isNegative) {
    final parts = offset.split(':');
    final hour = isNegative ? parts[0].split('-')[1] : parts[0];
    final hh = hour.length < 2 ? '0$hour' : hour;
    final mm = parts[1].length < 2 ? '0${parts[1]}' : parts[1];
    return '$hh:$mm';
  }

  Future<void> _chooseDateTime() async {
    final now = DateTime.now();
    final offsetStr = now.timeZoneOffset.toString();
    final isNeg = now.timeZoneOffset.isNegative;
    final formattedOffset = _formatTzOffset(offsetStr, isNeg);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );
    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 5))),
    );
    if (!mounted || pickedDate == null || pickedTime == null) return;

    final pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (!pickedDateTime.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.scheduledDateTimePast),
        ),
      );
      return;
    }

    setState(() {
      _scheduledDateTimeIso =
          '${DateFormat('yyyy-MM-dd').format(pickedDate)}T${pickedTime.hour}:${pickedTime.minute}:00${isNeg ? '-' : '+'}$formattedOffset';
      _dateTimeController.text = DateFormat(
        'd  MMM  yyyy  h:mm  a',
      ).format(pickedDateTime);
    });
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _dateTimeController.clear();
    _tagsController.clearTags();
    setState(() {
      _scheduledDateTimeIso = null;
    });
  }

  Future<AppwriteRoom?> submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return null;

    final name = _nameController.text;
    final description = _descriptionController.text;
    final tags = (_tagsController.getTags ?? const <String>[])
        .map((t) => t.toString())
        .toList();

    try {
      if (_isScheduled) {
        if (_scheduledDateTimeIso == null) return null;
        await ref
            .read(createRoomProvider.notifier)
            .createScheduledRoom(
              name: name,
              description: description,
              tags: tags,
              scheduledDateTime: _scheduledDateTimeIso!,
            );
        _clearForm();
        return null;
      } else {
        final room = await ref
            .read(createRoomProvider.notifier)
            .createLiveRoom(name: name, description: description, tags: tags);
        _clearForm();
        return room;
      }
    } catch (e) {
      log('createRoom failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToCreateRoom),
          ),
        );
      }
      return null;
    }
  }

  bool get isScheduled => _isScheduled;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(createRoomProvider);

    final kTextFieldDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
          const Color.fromARGB(255, 139, 134, 134),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        const BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.3),
          offset: const Offset(-2, -2),
          blurRadius: 3,
          spreadRadius: 1,
        ),
      ],
    );

    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: UiSizes.width_25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: UiSizes.height_24_6),
                    Text(
                      AppLocalizations.of(context)!.createNewRoom,
                      style: TextStyle(
                        fontSize: UiSizes.size_24 * 1.4,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ModeChip(
                          label: AppLocalizations.of(context)!.live,
                          active: !_isScheduled,
                          onTap: () => setState(() => _isScheduled = false),
                        ),
                        _ModeChip(
                          label: AppLocalizations.of(context)!.scheduled,
                          active: _isScheduled,
                          onTap: () => setState(() => _isScheduled = true),
                        ),
                      ],
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                    if (_isScheduled) ...[
                      SizedBox(
                        height: UiSizes.height_66,
                        child: TextFormField(
                          style: TextStyle(fontSize: UiSizes.size_14),
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : AppLocalizations.of(
                                  context,
                                )!.pleaseEnterScheduledDateTime,
                          readOnly: true,
                          controller: _dateTimeController,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.calendar_month,
                              size: UiSizes.size_23,
                            ),
                            labelText: AppLocalizations.of(
                              context,
                            )!.scheduleDateTimeLabel,
                            labelStyle: TextStyle(fontSize: UiSizes.size_14),
                            suffix: GestureDetector(
                              onTap: _chooseDateTime,
                              child: const Icon(Icons.date_range),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: UiSizes.height_33),
                    ],
                    Container(
                      decoration: kTextFieldDecoration,
                      child: TextFormField(
                        controller: _nameController,
                        style: TextStyle(fontSize: UiSizes.size_25),
                        cursorColor: Theme.of(context).colorScheme.primary,
                        maxLength: 30,
                        minLines: 1,
                        maxLines: 13,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.giveGreatName,
                          prefixIcon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          filled: false,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(UiSizes.width_16),
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_33),
                    Container(
                      decoration: kTextFieldDecoration,
                      child: TextFieldTags(
                        textfieldTagsController: _tagsController,
                        initialTags: const ['sample-tag'],
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: _validateTag,
                        inputFieldBuilder: (context, values) {
                          return TextField(
                            maxLength: 50,
                            maxLines: 1,
                            style: TextStyle(fontSize: UiSizes.size_20),
                            controller: values.textEditingController,
                            focusNode: values.focusNode,
                            decoration: InputDecoration(
                              hintText: values.tags.isNotEmpty
                                  ? null
                                  : AppLocalizations.of(context)!.enterTags,
                              filled: false,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(UiSizes.width_16),
                              errorText: values.error,
                              prefixIconConstraints: BoxConstraints(
                                maxWidth: UiSizes.width_304,
                              ),
                              prefixIcon: values.tags.isNotEmpty
                                  ? SingleChildScrollView(
                                      controller: values.tagScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: values.tags.map((tag) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  UiSizes.size_20,
                                                ),
                                              ),
                                              color: Colors.black54,
                                            ),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: UiSizes.width_5,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: UiSizes.width_10,
                                              vertical: UiSizes.height_5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '#$tag',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: UiSizes.size_18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: UiSizes.width_4,
                                                ),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.cancel,
                                                    size: UiSizes.size_18,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error
                                                        .withValues(alpha: 0.7),
                                                  ),
                                                  onTap: () =>
                                                      values.onTagRemoved(tag),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : null,
                            ),
                            onChanged: values.onTagChanged,
                            onSubmitted: values.onTagSubmitted,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: UiSizes.height_33),
                    Container(
                      decoration: kTextFieldDecoration,
                      child: TextFormField(
                        controller: _descriptionController,
                        style: TextStyle(fontSize: UiSizes.size_20),
                        cursorColor: Theme.of(context).colorScheme.primary,
                        maxLines: 10,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(
                            context,
                          )!.roomDescriptionOptional,
                          filled: false,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(UiSizes.width_16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).colorScheme.primary,
                size: MediaQuery.of(context).devicePixelRatio * 50,
              ),
            ),
          ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lightTheme = Theme.of(context).brightness == Brightness.light;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_10,
          horizontal: UiSizes.width_20,
        ),
        decoration: BoxDecoration(
          color: active
              ? scheme.primary
              : scheme.secondary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: UiSizes.size_14,
            color: lightTheme
                ? (active ? Colors.white : Colors.black)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
