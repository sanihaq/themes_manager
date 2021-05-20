import 'package:example/util.dart/restart_app.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:themes_manager/theme_manager.dart';

class DeleteSettingDialogue extends StatelessWidget {
  const DeleteSettingDialogue({
    Key? key,
    this.onCancel,
  }) : super(key: key);

  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 150,
          width: double.infinity,
          color: ThemesManager.customDataOf(context).color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Delete all settings from system?',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Container(
                margin: const EdgeInsets.all(24.0),
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Button(
                      label: 'Yes',
                      onTap: () {
                        ThemesManager.of(context)!.resetAll().then((_) {
                          ReloadChildWidget.of(context)!.restartApp();
                          onCancel!();
                        });
                      },
                    ),
                    Button(
                      label: 'No',
                      onTap: onCancel,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatefulWidget {
  const Button({Key? key, this.label, this.onTap}) : super(key: key);
  final Function? onTap;
  final String? label;
  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  double _width = 60;
  double _height = 40;
  double _border = 2;
  Color _color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _color = Colors.black;
        });
        Future.delayed(Duration(
          milliseconds: 50,
        )).then((value) => widget.onTap!());
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 2),
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          border: Border.all(
            width: _border,
            color: _color,
          ),
        ),
        child: Center(
            child: Text(
          widget.label!,
          style: TextStyle(color: _color),
        )),
      ),
    );
  }
}
