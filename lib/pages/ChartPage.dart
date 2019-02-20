import 'package:flutter/material.dart';
import 'package:ysnzp_random_flutter/models/NameModel.dart';

class ChartPage extends StatefulWidget {

  ChartPage(this.nameModel);

  final NameModel nameModel;

  @override
  _ChartPageState createState() => _ChartPageState();
}


class _ChartPageState extends State<ChartPage> {

  NameModel _nameModel;

  @override
  void initState() {
    _nameModel = widget.nameModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_nameModel.name),
      ),
      body: Container(
        key: Key("Asd"),
      ),
    );
  }
}
