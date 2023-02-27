import 'package:flutter/material.dart';

class PantryListItem extends StatefulWidget {
  final VoidCallback onLongPress;

  const PantryListItem({super.key, required this.onLongPress});
  @override
  State<StatefulWidget> createState() => PantryListItemState();

}

class PantryListItemState extends State<PantryListItem> {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    );
  }

}