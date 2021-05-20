import 'package:flutter/material.dart';
import 'package:themes_manager/theme_manager.dart';

import '../models.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          ElevatedButton(
            onPressed: ThemesManager.of(context).resetSettings,
            child: Text('Delete'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Switch(
                value: ThemesManager.of(context).checkDark(),
                onChanged: (_) => ThemesManager.of(context).toggleDarkMode(),
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value:
                      ThemesManager.of(context).themeMode == ThemeMode.system,
                  onChanged: ThemesManager.of(context).setThemeModeToSystem,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  'Follow system setting',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  ...ThemesManager.of(context).themesMap.keys.map((themeKey) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          ThemesManager.of(context)
                              .setTheme(themeKey, both: true, apply: true);
                          print(ThemesManager.customDataOf<Name>(
                                  context, ThemeType.material)
                              ?.description);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (ThemesManager.of(context)
                                  .checkIfDefault(themeKey))
                                Icon(
                                  Icons.star,
                                  size: 14,
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ThemesManager.of(context)
                                      .themesMap[themeKey]
                                      .name,
                                ),
                              ),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                          (states) =>
                              ThemesManager.of(context).checkIfCurrent(themeKey)
                                  ? ThemesManager.themeOf(context).primaryColor
                                  : Colors.blue,
                        )),
                      ),
                    );
                  }).toList(),
                ],
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
