import 'package:flutter/material.dart';

/// A quiz topic shown on the home screen.
@immutable
class QuizCategory {
  const QuizCategory({
    required this.id,
    required this.name,
    required this.tagline,
    required this.icon,
  });

  final String id;
  final String name;
  final String tagline;
  final IconData icon;
}
