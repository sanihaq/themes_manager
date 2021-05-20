// Copyright 2020 Sani Haq. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart' hide Radio;
import 'package:themes_manager/theme_manager.dart';

import '../models.dart';
import 'check_box.dart';
import 'delete_dialogue.dart';
import 'radio.dart';
import 'theme_selector.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({
    Key? key,
    required this.isMultiTheme,
    required this.noAppWidget,
    required this.isCupertino,
    required this.onlyWidgetApp,
    required this.setApp,
  }) : super(key: key);

  final bool isMultiTheme;
  final bool noAppWidget;
  final bool isCupertino;
  final bool onlyWidgetApp;
  final Function setApp;

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool _showMore = false;
  bool _warnDelete = false;

  @override
  Widget build(BuildContext context) {
    return ThemesManager(
      customData: ThemeSelectorThemes.themeData,
      child: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _showMore = !_showMore;
            });
          },
          child: Stack(
            children: [
              if (_showMore)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMore = false;
                    });
                  },
                  child: Container(
                    color: Colors.black12,
                  ),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 300,
                    maxWidth: 300,
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 50),
                    margin: const EdgeInsets.all(8.0),
                    width: _showMore ? null : 40,
                    height: _showMore ? null : 40,
                    decoration: BoxDecoration(
                      color: ThemesManager.customDataOf<ThemeSelectorThemes>(
                                  context)
                              ?.color ??
                          Colors.amber,
                      shape: _showMore ? BoxShape.rectangle : BoxShape.circle,
                    ),
                    child: _showMore
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CheckBox(
                                      active: widget.isMultiTheme,
                                      label: 'Multiple Apps',
                                      onTap: () => widget.setApp(
                                          isMulti: !widget.isMultiTheme),
                                    ),
                                    CheckBox(
                                      active: widget.noAppWidget,
                                      label: 'No Parent App',
                                      onTap: () => widget.setApp(
                                          noApp: !widget.noAppWidget),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio(
                                      active: !widget.isCupertino &&
                                          !widget.onlyWidgetApp,
                                      label: 'Show Material App',
                                      onTap: () => widget.setApp(
                                          isCuper: false, isOnly: false),
                                    ),
                                    Radio(
                                      active: widget.isCupertino &&
                                          !widget.onlyWidgetApp,
                                      label: 'Show Cupertino App',
                                      onTap: () => widget.setApp(
                                          isCuper: true, isOnly: false),
                                    ),
                                    Radio(
                                      active: widget.onlyWidgetApp,
                                      label: 'Show Widgets App Only',
                                      onTap: () => widget.setApp(isOnly: true),
                                    ),
                                  ],
                                ),
                                Stack(
                                  children: [
                                    Row(
                                      children: ThemesManager.of(context)!
                                          .customDataMap
                                          .entries
                                          .map((entries) {
                                        final data = entries.value.data
                                            as ThemeSelectorThemes;
                                        return ThemeSelector(
                                          color: data.color,
                                          themeKey: entries.key,
                                          active: entries.key ==
                                              ThemesManager.of(context)!
                                                  .currentCustomDataKey,
                                        );
                                      }).toList(),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _showMore = !_showMore;
                                              _warnDelete = true;
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Icon(Icons.more_horiz),
                  ),
                ),
              ),
              if (_warnDelete)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _warnDelete = false;
                    });
                  },
                  child: Container(
                    color: Colors.black12,
                  ),
                ),
              if (_warnDelete)
                DeleteSettingDialogue(
                  onCancel: () {
                    setState(() {
                      _warnDelete = false;
                    });
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}
