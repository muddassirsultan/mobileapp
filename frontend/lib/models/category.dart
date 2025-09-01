import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String imagePath;
  final String route;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.route,
    required this.icon,
  });
}
