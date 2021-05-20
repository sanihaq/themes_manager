// Copyright 2020 Sani Haq. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart' show ThemeData;

class ThemeManagerData {
  final String key;
  final String? name;
  final String? creator;
  final ThemeData themeData;
  ThemeManagerData({
    required this.key,
    this.name,
    this.creator,
    required this.themeData,
  });
}
