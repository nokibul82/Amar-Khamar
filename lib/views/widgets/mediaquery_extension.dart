import 'package:flutter/material.dart';

extension MediaqueryCustomExtension on BuildContext {
  Size get mQuery => MediaQuery.sizeOf(this);
}
