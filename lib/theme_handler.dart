// Copyright 2020 Sani Haq. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart' show ThemeData, ThemeMode, Brightness;
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cupertino_theme_data.dart';
import 'custom_data.dart';
import 'theme_data.dart';

enum ThemeType { material, cupertino, custom }

class _ThemeManager extends InheritedWidget {
  final ThemesManagerState data;

  _ThemeManager({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_ThemeManager oldWidget) {
    return true;
  }
}

class ThemesManager extends StatefulWidget {
  /// child widget (wrap it with a build function to correctly get the context)
  final Widget child;

  /// set an [id], if using multiple [ThemeManger]
  final String id;

  /// use to set a light theme on start of an app. gets overwritten by system store.
  final String defaultLightTheme;

  /// use to set a dark theme on start of an app. gets overwritten by system store.

  final String defaultDarkTheme;

  /// use to set a cupertino theme on start of an app. gets overwritten by system store.
  final String defaultCupertinoTheme;

  /// sets default [CustomData], sets to first available [data] if null. gets overwritten by system store.
  final String defaultCustomData;

  /// use to sets initial theme mode on start of app. gets overwritten by system store.
  final ThemeMode themeMode;

  /// keep the previous setting (if available), when [ThemeMode] change from [ThemeMode.system]
  final bool keepSettingOnDisableFollow;

  /// give a color to the [WidgetsApp] theme manager uses internally.
  final Color appColor;

  /// All your [ThemeManagerData] in a list
  final List<ThemeManagerData> themes;

  /// All your [CupertinoThemeManagerData] in a list
  final List<CupertinoThemeManagerData> cupertinoThemes;

  /// All your [CustomThemeManagerData] in a list
  final List<CustomThemeManagerData> customData;

  /// [ThemesManager] is best used as parent of [MaterialApp] or [CupertinoApp] or [WidgetsApp],
  ///
  /// ** But you can also use it without any of these widgets. **
  ///
  /// Add [id] to separate data on different parts in the app.
  ///
  /// hard code some default setting for [defaultLightTheme], [defaultDarkTheme] and [themeMode].
  /// Set [defaultCupertinoTheme] if using cupertino themes.
  ///
  /// set [keepSettingOnDisableFollow] to [true] to keep current applied theme even if [themeMode] changes from [ThemeMode.system]
  ///
  /// [cupertinoThemes] does not support [themeMode]. it always follow system setting.
  ThemesManager({
    Key key,
    this.id = 'app',
    this.keepSettingOnDisableFollow = false,
    this.themeMode = ThemeMode.system,
    this.defaultLightTheme,
    this.defaultDarkTheme,
    this.defaultCupertinoTheme,
    this.defaultCustomData,
    this.themes,
    this.cupertinoThemes,
    this.customData,
    this.appColor,
    @required this.child,
  }) : super(key: key) {
    assert(
      themes == null && defaultLightTheme == null && defaultDarkTheme == null ||
          themes != null &&
              defaultLightTheme != null &&
              defaultDarkTheme != null,
      '''[themes], [defaultLightTheme] and [defaultDarkTheme] can't be null!''',
    );
    assert(
      (cupertinoThemes == null && defaultCupertinoTheme == null) ||
          (cupertinoThemes != null && defaultCupertinoTheme != null),
      '''[cupertinoThemes] and [defaultCupertinoTheme] can't be null!''',
    );
  }

  @override
  ThemesManagerState createState() => ThemesManagerState();

  /// get state of [ThemeManger] of current context.
  ///
  /// Access full theme list via designated getters (as { key: value } pair).
  static ThemesManagerState of(BuildContext context) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    return inherited.data;
  }

  /// get current [ThemeData] of current [ThemeManger]
  static ThemeData themeOf(BuildContext context) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    return inherited.data.themesMap[inherited.data.currentThemeKey].themeData;
  }

  /// get current [CupertinoThemeData] of current [ThemeManger]
  static CupertinoThemeData cupertinoThemeOf(BuildContext context) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    return inherited.data
        .cupertinoThemesMap[inherited.data.currentCupertinoThemeKey].themeData;
  }

  /// [customData] could be null.
  /// always check for null before using.
  /// ```
  /// ThemeManager.customDataOf<ExampleClass>(context)?.example ?? null
  /// ```
  /// to get data for current cupertino theme
  /// ```
  /// ThemeManager.customDataOf<ExampleClass>(context, ThemeType.cupertino)?.example
  /// ```
  static T customDataOf<T>(BuildContext context,
      [ThemeType type = ThemeType.custom]) {
    _ThemeManager inherited =
        (context.dependOnInheritedWidgetOfExactType<_ThemeManager>());
    switch (type) {
      case ThemeType.material:
        return inherited
            .data.customDataMap[inherited.data.currentThemeKey]?.data as T;
      case ThemeType.cupertino:
        return inherited.data
            .customDataMap[inherited.data.currentCupertinoThemeKey]?.data as T;
      case ThemeType.custom:
        return inherited
            .data.customDataMap[inherited.data.currentCustomDataKey]?.data as T;
      default:
        return inherited
            .data.customDataMap[inherited.data.currentCustomDataKey]?.data as T;
    }
  }
}

class ThemesManagerState extends State<ThemesManager> {
  SharedPreferences _sharedPrefs;

  BuildContext _mediaContext;

  Map<String, ThemeManagerData> _themes = Map();

  Map<String, CupertinoThemeManagerData> _cupertinoThemes = Map();

  Map<String, CustomThemeManagerData> _customData = Map();

  String _currentLightThemeKey;

  String _currentDarkThemeKey;

  String _currentCupertinoThemeKey;

  String _currentCustomDataKey;

  ThemeMode _mode;

  Map<String, ThemeManagerData> get themesMap => _themes;

  Map<String, CupertinoThemeManagerData> get cupertinoThemesMap =>
      _cupertinoThemes;

  Map<String, CustomThemeManagerData> get customDataMap => _customData;

  /// Current [customData]
  CustomThemeManagerData get customData =>
      _customData[_currentCustomDataKey]?.data;

  /// Current CupertinoTheme
  CupertinoThemeData get cupertinoTheme =>
      _cupertinoThemes[_currentCupertinoThemeKey]?.themeData ?? null;

  /// Current light theme of Themes
  ThemeData get lightTheme => _themes[_currentLightThemeKey]?.themeData ?? null;

  /// Current dark theme of Themes
  ThemeData get darkTheme => _themes[_currentDarkThemeKey]?.themeData ?? null;

  /// Current applied [ThemeMode]
  ThemeMode get themeMode => _mode;

  /// get [themeKey] of currently applied cupertino themes .
  String get currentCupertinoThemeKey => _currentCupertinoThemeKey;

  /// get [themeKey] of currently applied theme.
  String get currentThemeKey =>
      checkDark() ? _currentDarkThemeKey : _currentLightThemeKey;

  /// get [themeKey] of currently active [customData].
  String get currentCustomDataKey => _currentCustomDataKey;

  // set default settings either from hard code or from system storage or server.
  @override
  void initState() {
    _mapCustomData(widget.customData);
    if (widget.themes == null) {
      _themes = {
        'default-light': ThemeManagerData(
          key: 'default-light',
          name: 'Default Light',
          creator: '',
          themeData: ThemeData.light(),
        ),
        'default-dark': ThemeManagerData(
          key: 'default-dark',
          name: 'Default Dark',
          creator: '',
          themeData: ThemeData.dark(),
        ),
      };
    } else {
      widget.themes.forEach((value) {
        _themes[value.key] = ThemeManagerData(
          key: value.key,
          name: value.name ?? '',
          creator: value.creator ?? '',
          themeData: value.themeData ?? ThemeData(),
        );
      });
    }
    //
    if (widget.cupertinoThemes == null) {
      _cupertinoThemes = {
        'default': CupertinoThemeManagerData(
          key: 'default',
          name: 'Default',
          creator: '',
          themeData: CupertinoThemeData(),
        ),
      };
    } else {
      widget.cupertinoThemes.forEach((value) {
        _cupertinoThemes[value.key] = CupertinoThemeManagerData(
          key: value.key,
          name: value.name ?? '',
          creator: value.creator ?? '',
          themeData: value.themeData ?? CupertinoThemeData(),
        );
      });
    }
    // first set default value based on available values
    _setDefaults();
    // get value from system machine and change defaults.
    SharedPreferences.getInstance().then((prefs) {
      _sharedPrefs = prefs;
      final isDark = _sharedPrefs?.getBool('${widget.id}-dark-mode');
      final followSystem = _sharedPrefs?.getBool('${widget.id}-follow-system');
      final dLight = _sharedPrefs?.getString('${widget.id}-default-light');
      final dDark = _sharedPrefs?.getString('${widget.id}-default-dark');
      final dCupertino =
          _sharedPrefs?.getString('${widget.id}-default-cupertino');
      final dCustom =
          _sharedPrefs?.getString('${widget.id}-default-custom-data');
      //
      if (dCustom != null && _customData.containsKey(dCustom)) {
        _currentCustomDataKey = dCustom;
      }
      if (dCupertino != null && _cupertinoThemes.containsKey(dCupertino))
        _currentCupertinoThemeKey = dCupertino;
      if (dLight != null && _themes.containsKey(dLight))
        _currentLightThemeKey = dLight;
      if (dDark != null && _themes.containsKey(dDark))
        _currentDarkThemeKey = dDark;
      if (followSystem != null && !followSystem) setDarkMode(isDark ?? false);
      if (followSystem != null && followSystem && _mode != ThemeMode.system)
        setThemeModeToSystem(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      debugShowCheckedModeBanner: false,
      builder: (context, _) {
        _mediaContext = context;
        return _ThemeManager(
          data: this,
          child: widget.child,
        );
      },
      color: widget.appColor ?? Color(0xFF2196F3),
    );
  }

  /// get [ThemeData] by [key] name of [themesMap]
  /// returns [null] if theme not found
  ThemeManagerData _getThemeData(String key) {
    return _themes.containsKey(key) ? _themes[key] : null;
  }

  /// set default themes for [darkTheme] or [lightTheme]
  ///
  /// to apply them straightaway set [apply] to [true]
  ///
  /// Note: Doing this changes [themeMode] to [ThemeMode.dark] or [ThemeMode.light] based on the theme selected, even if [themeMode] was [ThemeMode.system]
  ///
  /// set [both] to [true] to set related theme to [darkTheme] or [lightTheme],
  /// if no related theme found keeps the previous theme.
  ///
  /// Note: To apply related theme correctly [themeKey] needs to be correctly configured in  [ThemeManagerData].
  ///
  /// follow these kind of structure in [key] for related themes [example-light], [example-dark] or [vary_simple_light_theme], [vary_simple_dark_theme].
  /// Don't use camel cases in [themeKey] like [exampleLight], [exampleDark].
  void setTheme(String themeKey, {bool apply = false, bool both = false}) {
    final theme = _getThemeData(themeKey).themeData;
    if (theme.brightness == Brightness.dark) {
      if (both) {
        final key = themeKey.replaceAll('dark', 'light');
        if (key != themeKey && _themes.containsKey(key)) setLightTheme(key);
      }
      setDarkTheme(themeKey, apply: apply);
      if (apply) setDarkMode(true);
    } else {
      if (both) {
        final key = themeKey.replaceAll('light', 'dark');
        if (key != themeKey && _themes.containsKey(key)) setDarkTheme(key);
      }
      setLightTheme(themeKey, apply: apply);
      if (apply) setDarkMode(false);
    }
  }

  /// set default theme for [cupertinoTheme]
  void setCupertinoTheme(String themeKey) {
    setState(() {
      _currentCupertinoThemeKey = themeKey;
    });
    _sharedPrefs?.setString('${widget.id}-default-cupertino', themeKey);
  }

  /// set default theme for [lightTheme]
  void setLightTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _currentLightThemeKey = themeKey;
    });
    _sharedPrefs?.setString('${widget.id}-default-light', themeKey);
  }

  /// set default theme for [darkTheme]
  void setDarkTheme(String themeKey, {bool apply = false}) {
    setState(() {
      _currentDarkThemeKey = themeKey;
    });
    _sharedPrefs?.setString('${widget.id}-default-dark', themeKey);
  }

  /// set current active [customData]
  void setCurrentCustomData(String key) {
    setState(() {
      _currentCustomDataKey = key;
    });
    _sharedPrefs?.setString('${widget.id}-default-custom-data', key);
  }

  /// toggle between [ThemeMode.dark] and [ThemeMode.light]
  void toggleDarkMode() {
    setDarkMode(!checkDark());
  }

  /// set [themeMode] to [ThemeMode.dark] or [ThemeMode.light] by passing [value]
  void setDarkMode(bool value) {
    setState(() {
      _mode = value ? ThemeMode.dark : ThemeMode.light;
    });
    _sharedPrefs?.setBool('${widget.id}-dark-mode', value);
    _sharedPrefs?.setBool('${widget.id}-follow-system', false);
  }

  /// set [themeMode] value to [ThemeMode.system] by passing [true],
  /// or pass [false] to change [themeMode] to [ThemeMode.dark] or [ThemeMode.light]
  void setThemeModeToSystem(bool value) {
    setState(() {
      if (widget.keepSettingOnDisableFollow) {
        _mode = value
            ? ThemeMode.system
            : checkDark()
                ? ThemeMode.dark
                : ThemeMode.light;
      } else {
        final isDark = _sharedPrefs?.getBool('${widget.id}-dark-mode');
        _mode = value
            ? ThemeMode.system
            : isDark != null && isDark
                ? ThemeMode.dark
                : ThemeMode.light;
      }
    });

    _sharedPrefs?.setBool('${widget.id}-follow-system', value);
    if (widget.keepSettingOnDisableFollow)
      _sharedPrefs?.setBool('${widget.id}-dark-mode', _mode == ThemeMode.dark);
  }

  /// check current theme is dark or not.
  /// if [themeMode] is [ThemeMode.system] check current [ThemeMode] of [system].
  bool checkDark() {
    if (_mediaContext == null) return false;
    final Brightness systemBrightnessValue =
        MediaQuery.of(_mediaContext).platformBrightness;
    return _mode == ThemeMode.system
        ? systemBrightnessValue == Brightness.dark
        : _mode == ThemeMode.dark;
  }

  /// check if a theme is currently default or not.
  bool checkIfDefault(String key) {
    return key == _currentLightThemeKey || key == _currentDarkThemeKey;
  }

  /// check if theme is currently applied
  bool checkIfCurrent(String key) {
    return checkDark()
        ? key == _currentDarkThemeKey
        : key == _currentLightThemeKey;
  }

  /// Make sure [ThemesManager] exist in the widget tree and your are in the correct [BuildContext].
  /// ```
  /// builder: (context, child) {
  ///   ...
  ///   ThemeManager.of(context).generateTheme(
  ///     ThemeManagerData(
  ///         key: <themeKey>,
  ///         data: <ThemeData>,
  ///     )
  ///   );
  ///   return child;
  /// },
  /// ```
  void generateTheme(
    ThemeManagerData themeData,
  ) {
    assert(themeData != null, "[themeData] can't be null");
    _themes[themeData.key] = themeData;
  }

  /// Make sure [ThemesManager] exist in the widget tree, above of the widget where you are trying to add new themes.
  /// ```
  /// builder: (context, child) {
  ///   ...
  ///   ThemeManager.of(context).generateTheme(
  ///     CupertinoThemeManagerData(
  ///         key: <themeKey>,
  ///         data: <ThemeData>,
  ///     )
  ///   );
  ///   return child;
  /// },
  /// ```
  void generateCupertinoTheme(
    CupertinoThemeManagerData themeData,
  ) {
    assert(themeData != null, "[themeData] can't be null");
    _cupertinoThemes[themeData.key] = themeData;
  }

  /// Add additional [customData] later in the app
  /// always make sure [ThemesManager] exist above your builder function
  void addToCustomData(
    CustomThemeManagerData data,
  ) {
    _mapCustomData([data]);
  }

  // set default values
  _setDefaults() {
    _mode = widget.themeMode;
    _currentLightThemeKey = widget.defaultLightTheme ?? 'default-light';
    _currentDarkThemeKey = widget.defaultDarkTheme ?? 'default-dark';
    _currentCupertinoThemeKey = widget.defaultCupertinoTheme ?? 'default';
    _currentCustomDataKey =
        widget.defaultCustomData ?? widget.customData?.first?.key;
  }

  // map data to [customData]
  void _mapCustomData(List<CustomThemeManagerData> dataList) {
    dataList?.forEach((data) {
      _customData[data.key] = CustomThemeManagerData(
        key: data.key,
        data: data.data,
      );
    });
  }

  /// reset every settings, Go back to hard coded settings.
  Future<void> resetSettings() async {
    await _sharedPrefs?.remove('${widget.id}-dark-mode');
    await _sharedPrefs?.remove('${widget.id}-follow-system');
    await _sharedPrefs?.remove('${widget.id}-default-light');
    await _sharedPrefs?.remove('${widget.id}-default-dark');
    await _sharedPrefs?.remove('${widget.id}-default-cupertino');
    await _sharedPrefs?.remove('${widget.id}-default-custom-data');
    _setDefaults();
    setState(() {});
  }

  /// reset every settings throughout the whole app.
  ///
  /// ! ** Warning ** if you're using [SharedPreferences] in other parts of your app, avoid using this function.
  @deprecated
  Future<bool> resetAll() async {
    return _sharedPrefs.clear();
  }
}
