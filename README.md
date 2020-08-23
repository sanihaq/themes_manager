# Flutter Themes Manger

A Themes Manger for your flutter app. Handles multiple themes in your app and easily switch between them. Generate new themes on the fly. Create your own Themes with custom data.

![](https://github.com/sanihaq/themes_manager/blob/master/assets/themes_manager.gif)

## Getting Started

Add `themes_manager` to your project.
```
  dependencies:
    themes_manager: ^1.0.0
```

run `flutter packages get` and import `themes_manager`
```dart
import 'package:themes_manager/theme_manager.dart';
```

## How to configure themes data


```dart
class MyApp extends StatelessWidget {
  final List<ThemeManagerData> themes = [
    ThemeManagerData(
      key: 'default-dark',
      name: 'Default Dark',
      creator: '',
      themeData: ThemeData.dark(),
    ),
    ThemeManagerData(
      key: 'default-light',
      name: 'Default Light',
      creator: '',
      themeData: ThemeData(),
    ),
  ];
  final List<CupertinoThemeManagerData> cupertinoThemes = [
    CupertinoThemeManagerData(
      key: 'default',
      name: 'Default',
      creator: '',
      themeData: CupertinoThemeData().copyWith(
        primaryColor: Colors.amber,
      ),
    ),
  ]

// Wrap your app `Widget` with `ThemesManager`:
  @override
  Widget build(BuildContext context) {
    return ThemesManager(
      defaultLightTheme: 'default-light',
      defaultDarkTheme: 'default-dark',
      defaultCupertinoTheme: 'default',
      themeMode: ThemeMode.system,
      themes: themes,
      cupertinoThemes: cupertinoThemes,
      // configure custom data.
      customData: [
        CustomThemeManagerData(
          key: 'example',
          data: 'Your Data Object'
        ),
      ],
      child: MyAppWidget(),
    ),
  }
}
```

How to add additional theme later in the app:

```dart
...
ThemesManager.of(context).generateTheme(
  ThemeManagerData(
    key: 'generated-theme',
    name: 'Generated Theme',
    creator: 'creator name',
    themeData: ThemeData.dark().copyWith(),
  ),
);
...
```

How to access `customData`
```dart
// remember you can pass any kind of data. To get type checking, you just need to pass the data type while getting that data.
ThemesManager.customDataOf<String>(context);
```

![](https://github.com/sanihaq/themes_manager/blob/master/assets/example2.png)

## Additional Help

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).