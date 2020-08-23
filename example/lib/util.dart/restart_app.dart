// src :- https://github.com/Nobbas/flutter_restart

import 'package:flutter/widgets.dart';

class ReloadChildWidget extends StatefulWidget {
  final Widget child;

  const ReloadChildWidget({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  _ReloadChildWidgetState createState() => _ReloadChildWidgetState();

  static _ReloadChildWidgetState of(BuildContext context) {
    assert(context != null);

    return (context
            .getElementForInheritedWidgetOfExactType<_RestartInheritedWidget>()
            .widget as _RestartInheritedWidget)
        .state;
  }
}

class _ReloadChildWidgetState extends State<ReloadChildWidget> {
  Key _key = UniqueKey();

  /// Change the key to a new one which will make the widget tree
  /// re render.
  void restartApp() async {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _RestartInheritedWidget(
      key: _key,
      state: this,
      child: widget.child,
    );
  }
}

class _RestartInheritedWidget extends InheritedWidget {
  final _ReloadChildWidgetState state;

  _RestartInheritedWidget({
    Key key,
    this.state,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
