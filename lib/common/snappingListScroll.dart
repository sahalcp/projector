import 'dart:math';

import 'package:flutter/material.dart';

class SnappingListScrollPhysics extends ScrollPhysics {
  final double itemWidth;

  const SnappingListScrollPhysics({
    @required this.itemWidth,
    ScrollPhysics parent,
  }) : super(parent: parent);

  @override
  SnappingListScrollPhysics applyTo(ScrollPhysics ancestor) => SnappingListScrollPhysics(
    parent: buildParent(ancestor),
    itemWidth: itemWidth,
  );

  double _getItem(ScrollPosition position) => (position.pixels) / itemWidth;

  double _getPixels(ScrollPosition position, double item) => min(item * itemWidth, position.maxScrollExtent);

  double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}