import 'package:flutter/material.dart';

class ItemName extends StatefulWidget {

  ItemName({this.name, this.onTap, this.onLongTap});

  final Function(bool) onTap;
  final Function onLongTap;

  final String name;

  @override
  _ItemNameState createState() => _ItemNameState();
}

class _ItemNameState extends State<ItemName> {


  bool isSelected = false;
  Color _defaultColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _defaultColor,
      child: ListTile(
        selected: isSelected,
        title: Text("${widget.name}"),
        onTap: _toggleSelection,
        onLongPress: widget.onLongTap,
      ),
    );
//    return new Card(
//      color: _defaultColor,
//      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//        new ListTile(
//          selected: isSelected,
//          title: Text("${widget.name} 삭제"),
//          onTap: _toggleSelection,
//          onLongPress: widget.onLongTap,
//        )
//      ]),
//    );
  }

  _toggleSelection() {
    widget.onTap(isSelected);
    setState(() {
      if (isSelected) {
        _defaultColor = Colors.white;
        isSelected = false;
      } else {
        _defaultColor = Colors.grey[300];
        isSelected = true;
      }
    });
  }
}
