import 'package:flutter/material.dart';

abstract class Routable implements Widget {
  String get path;
}

abstract class RoutableExtra extends Routable {
  StatefulWidget extra(Object extra);
}
