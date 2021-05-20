import 'package:flutter/material.dart' show Colors, Icons;
import 'package:flutter/widgets.dart';

class CheckBox extends StatelessWidget {
  const CheckBox({
    Key? key,
    this.active = false,
    this.label = '',
    this.onTap,
  }) : super(key: key);

  final bool active;
  final String label;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        color: Colors.black12,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Container(
              height: 30,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  if (active)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
