class NameModel {
  int _id;
  String _name;

  NameModel(this._name);

  NameModel.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
  }


  int get id => _id;
  String get name => _name;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;

    return map;
  }


  NameModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
  }

}