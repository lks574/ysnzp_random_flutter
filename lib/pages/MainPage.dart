import 'package:flutter/material.dart';
import 'package:ysnzp_random_flutter/items/ItemName.dart';
import 'package:ysnzp_random_flutter/models/DefaultData.dart';
import 'package:ysnzp_random_flutter/models/NameModel.dart';
import 'package:ysnzp_random_flutter/pages/ResultPage.dart';
import 'package:ysnzp_random_flutter/sql/DatabaseHelper.dart';


class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final _cleanPosition = DefaultData.cleanList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var db = new DatabaseHelper();
  List _nameModel;

  List<NameModel> _selectNames = List();
  List<int> _cleanListInt = [0,0,0,0,0,0];
  int _peopleNumber = 0;
  int _cleanNumber = 0;

  @override
  Widget build(BuildContext context) {
    modelInit();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("제너레이션,용산집"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _appBarAction();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        menuTitleWidget("청소인원", _peopleNumber),
                        IconButton(
                          icon: Icon(Icons.done_all),
                          onPressed: (){

                          },
                        )
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: menuTitleWidget("청소지역", _cleanNumber),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                primary: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: cleanPeopleWidget(),
                    ),
                    Expanded(
                      flex: 1,
                      child: cleanListWidget(),
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              child: Text("시작하기"),
              onPressed: (){
                _startAction();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future modelInit() async{
    _nameModel = await db.getAllNameModel();
    setState(() {});
  }

  // region Action
  _appBarAction(){
    _addNameDialog();
  }

  _startAction(){
    if (_cleanNumber == 0){
      _showToast("청소 지역 눌러주세요.");
      return;
    }
    if (_peopleNumber >= _cleanNumber) {
      _randomDialog();
    }else{
      _showToast("청소인원 부족");
    }
  }

  // endregion


  // region 1.위젯

  // region 2.청소인원
  Widget cleanPeopleWidget(){
    return
      _nameModel != null ?
      ListView.builder(
        itemBuilder: (BuildContext context, int index){
          NameModel model = NameModel.fromMap(_nameModel[index]);
//            return ItemName( _nameModel[index]["name"], (){
//              _selectNames.add(_nameModel[index]);
//            });
          return ItemName(
            name: _nameModel[index]["name"],
            onTap: (isSelect){
              if (!isSelect){
                _selectNames.add(model);
              }else{
                _selectNames.removeWhere((model) => model.name == _nameModel[index]["name"]);
              }

              setState(() {
                _peopleNumber = _selectNames.length;
              });
            },
            onLongTap: () => _deleteNameDialog(_nameModel[index]),
          );

//            return ListTile(
//              title: Text(_nameModel[index]["name"]),
//              onLongPress: (){
//                _deleteNameDialog(_nameModel[index]);
//                modelInit();
//              },
//              onTap: (){
//                _selectNames.add(_nameModel[index]);
//                print(_selectNames);
//              },
//            );
        },
        itemCount: _nameModel.length,
        shrinkWrap: true,
        primary: false,
      ) :
      Container();
  }
  // endregion 2.청소인원


  // region 2.청소지역 위젯
  Widget cleanListWidget(){
    return
      ListView.builder(
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(
              _cleanPosition[index],
            ),
            trailing: Text(_cleanListInt[index].toString()),
            onTap: () {
              _cleanListInt[index] += 1;
              setState(() {
                _cleanNumber = _cleanListInt.reduce((a, b) => a + b);
              });
            },
            onLongPress: (){
              if (_cleanListInt[index] != 0){
                _cleanListInt[index] -= 1;
                setState(() {
                  _cleanNumber = _cleanListInt.reduce((a, b) => a + b);
                });
              }
            },
          );
        },
        itemCount: _cleanPosition.length,
        shrinkWrap: true,
        primary: false,
      );

  }
  // endregion 2.청소지역


  // region 3.메뉴타이틀 위젯
  Widget menuTitleWidget(String text, int number){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(text, style: TextStyle(fontSize: 20.0, color: Colors.black,),),
        SizedBox(width: 10.0,),
        Text(number.toString(), style: TextStyle(fontSize: 20.0, color: Colors.black,),),
      ],
    );
  }
  // endregion 3.메뉴타이틀

  // endregion 1.위젯


  // region Dialog
  _addNameDialog(){
    String addName = "";
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("이름 추가"),
            content: TextField(
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.blueAccent,
              ),
              decoration: InputDecoration(
                hintText: "이름",
              ),
              onChanged: (text){
                addName = text;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("확인"),
                onPressed: (){
                  Navigator.of(context).pop();
                  db.saveNote(NameModel(addName));
                  modelInit();
                },
              ),
              FlatButton(
                child: Text("취소"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _deleteNameDialog(Map model){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("인원 삭제"),
            content: Text("${model["name"]} 삭제"),
            actions: <Widget>[
              FlatButton(
                child: Text("확인"),
                onPressed: (){
                  Navigator.of(context).pop();
                  db.deleteNameModel(model["id"]);
                  modelInit();
                },
              ),
              FlatButton(
                child: Text("취소"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _randomDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("인원 삭제"),
            content: Text("인원: $_peopleNumber, 청소: $_cleanNumber, 쉬는인원: ${_peopleNumber - _cleanNumber}"),
            actions: <Widget>[
              FlatButton(
                child: Text("확인"),
                onPressed: (){

                  Navigator.of(context).pop();
                  Navigator.push(this.context, MaterialPageRoute(builder: (context) => ResultPage(_selectNames, _cleanListInt)));
                },
              ),
              FlatButton(
                child: Text("취소"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  // endregion Dialog

  // region SnackBar
  void _showToast(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(text),),
    );
  }
// endregion

}
