import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// Vertical spacing widgets for consistent gaps
class VSpace extends StatelessWidget {
  final double height;

  const VSpace(this.height, {super.key});

  const VSpace.xs({super.key}) : height = AppDimensions.spaceXs;
  const VSpace.sm({super.key}) : height = AppDimensions.spaceSm;
  const VSpace.md({super.key}) : height = AppDimensions.spaceMd;
  const VSpace.base({super.key}) : height = AppDimensions.space;
  const VSpace.lg({super.key}) : height = AppDimensions.spaceLg;
  const VSpace.xl({super.key}) : height = AppDimensions.spaceXl;
  const VSpace.xxl({super.key}) : height = AppDimensions.spaceXxl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// Horizontal spacing widgets for consistent gaps
class HSpace extends StatelessWidget {
  final double width;

  const HSpace(this.width, {super.key});

  const HSpace.xs({super.key}) : width = AppDimensions.spaceXs;
  const HSpace.sm({super.key}) : width = AppDimensions.spaceSm;
  const HSpace.md({super.key}) : width = AppDimensions.spaceMd;
  const HSpace.base({super.key}) : width = AppDimensions.space;
  const HSpace.lg({super.key}) : width = AppDimensions.spaceLg;
  const HSpace.xl({super.key}) : width = AppDimensions.spaceXl;
  const HSpace.xxl({super.key}) : width = AppDimensions.spaceXxl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
