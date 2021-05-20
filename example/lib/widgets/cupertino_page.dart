import 'package:flutter/cupertino.dart';
import 'package:themes_manager/theme_manager.dart';

import '../models.dart';

class CupertinoStoreHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 1), () {
    //   ThemeManager.of(context).resetSettings();
    // });

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ThemesManager.of(context)
                      .cupertinoThemesMap
                      .keys
                      .map((themeKey) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100.0,
                        vertical: 5,
                      ),
                      child: CupertinoButton(
                        onPressed: () => ThemesManager.of(context)
                            .setCupertinoTheme(themeKey),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ThemesManager.of(context)
                                .cupertinoThemesMap[themeKey]
                                .name,
                            softWrap: false,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        color: ThemesManager.of(context)
                                    .currentCupertinoThemeKey ==
                                themeKey
                            ? CupertinoTheme.of(context).primaryColor
                            : Color(0xFF2196F3),
                      ),
                    );
                  }).toList(),
                ),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          ThemesManager.customDataOf<Name>(
                                      context, ThemeType.cupertino)
                                  ?.name ??
                              '',
                        ),
                        Text(
                          ThemesManager.customDataOf<Name>(
                                      context, ThemeType.cupertino)
                                  ?.description ??
                              '...',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SizedBox(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}
