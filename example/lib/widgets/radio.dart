import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';

class Radio extends StatelessWidget {
  const Radio({
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
        margin: const EdgeInsets.all(2.0),
        color: Colors.black12,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
                child: active
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
