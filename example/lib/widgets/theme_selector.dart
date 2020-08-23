import 'package:flutter/widgets.dart';
import 'package:themes_manager/theme_handler.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({
    Key key,
    @required this.color,
    @required this.themeKey,
    this.active = false,
  }) : super(key: key);

  final Color color;

  final bool active;

  final String themeKey;

  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  double size = 30.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          size = 35;
        });
      },
      onTapUp: (_) {
        setState(() {
          size = 30;
        });
        ThemesManager.of(context).setCurrentCustomData(widget.themeKey);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 75),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: widget.color,
            border: widget.active
                ? Border.all(
                    width: 2.0,
                    color: Color(0xffffffff),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
