import 'package:barcode_scanner/components/app_colors.dart';
import 'package:flutter/material.dart';

import '../models/items.dart';

class ItemTile extends StatefulWidget {
  final Item item;
  final Widget icon;

  void Function()? onPressed;
  ItemTile({super.key,
    required this.item,
    required this.onPressed,
    required this.icon});

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.tile),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ListTile(
        title: Text(widget.item.name),
        subtitle: Text(widget.item.price),
        leading: Image.asset(widget.item.imagePath),
        trailing: IconButton(
            icon: widget.icon,
            onPressed: widget.onPressed,)
      ),
    );
  }
}
