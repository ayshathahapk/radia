import 'package:flutter/material.dart';
import 'package:radia/Core/app_export.dart';

Widget space({double? h, double? w}) {
  return SizedBox(
    height: h ?? 20.v,
    width: w ?? 0.v,
  );
}
