/// id : "1"
/// prefix : "KATA"
/// internalName : "Kataster"
/// internalDescription : null
/// externalName : "Kataster"
/// externalDescription : null
/// publicEnabled : true
/// active : true
/// custom : null
/// created_at : null
/// updated_at : null
/// services : [{"id":"38","name":"Geodeti","active":true,"duration":"5","additionalCustomerDuration":"0","publicId":"6521f3ac31df516c85649a4bc1b2c42fe9e0ee9bd39a51f2faa3acceb36bbc0f","publicEnabled":true,"created":"1615897463388","updated":"1615897492883","custom":"{\"AppointmentType\":\"KATA\", \"ServicesType\":[\"UNIVER\"], \"issueCode\":\"\"}","qpId":"27","keyWords":null},{"id":"39","name":"Kataster - Poskytovanie informácií","active":true,"duration":"15","additionalCustomerDuration":"0","publicId":"0ade52e1ccb2220b4ea39a5d0949d7a8b5cf3eba47dfd4a0048171c8f19ad282","publicEnabled":true,"created":"1615897463394","updated":"1615897539325","custom":"{\"AppointmentType\":\"KATA\", \"ServicesType\":[\"UNIVER\"], \"issueCode\":\"\"}","qpId":"30","keyWords":null},{"id":"35","name":"Podateľňa - Kataster","active":true,"duration":"10","additionalCustomerDuration":"0","publicId":"6ca9a9e91f9fff311c3bee8fbc27fc1ea2d7d674432f2257a3c333e3ae687cfd","publicEnabled":true,"created":"1615897463251","updated":"1615897518040","custom":"{\"AppointmentType\":\"KATA\", \"ServicesType\":[\"UNIVER\"], \"issueCode\":\"\"}","qpId":"135","keyWords":null},{"id":"36","name":"Viac úkonov kataster","active":true,"duration":"60","additionalCustomerDuration":"0","publicId":"60daadded44c6c5bbe5805018ea7df3f4fa7a2e4f933856e38a9095d42b58c71","publicEnabled":true,"created":"1615897463364","updated":"1615897463372","custom":"{\"AppointmentType\":\"KATA\", \"ServicesType\":[\"UNIVER\"], \"issueCode\":\"\"}","qpId":"88","keyWords":null}]

class DataAgenda {
  String _id;
  String _prefix;
  String _internalName;
  dynamic _internalDescription;
  String _externalName;
  dynamic _externalDescription;
  bool _publicEnabled;
  bool _active;
  dynamic _custom;
  dynamic _createdAt;
  dynamic _updatedAt;
  List<Services> _services;

  String get id => _id;
  String get prefix => _prefix;
  String get internalName => _internalName;
  dynamic get internalDescription => _internalDescription;
  String get externalName => _externalName;
  dynamic get externalDescription => _externalDescription;
  bool get publicEnabled => _publicEnabled;
  bool get active => _active;
  dynamic get custom => _custom;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;
  List<Services> get services => _services;

  DataAgenda({
      String id, 
      String prefix, 
      String internalName, 
      dynamic internalDescription, 
      String externalName, 
      dynamic externalDescription, 
      bool publicEnabled, 
      bool active, 
      dynamic custom, 
      dynamic createdAt, 
      dynamic updatedAt, 
      List<Services> services}){
    _id = id;
    _prefix = prefix;
    _internalName = internalName;
    _internalDescription = internalDescription;
    _externalName = externalName;
    _externalDescription = externalDescription;
    _publicEnabled = publicEnabled;
    _active = active;
    _custom = custom;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _services = services;
}

  DataAgenda.fromJson(dynamic json) {
    _id = json["id"];
    _prefix = json["prefix"];
    _internalName = json["internalName"];
    _internalDescription = json["internalDescription"];
    _externalName = json["externalName"];
    _externalDescription = json["externalDescription"];
    _publicEnabled = json["publicEnabled"];
    _active = json["active"];
    _custom = json["custom"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    if (json["services"] != null) {
      _services = [];
      json["services"].forEach((v) {
        _services.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["prefix"] = _prefix;
    map["internalName"] = _internalName;
    map["internalDescription"] = _internalDescription;
    map["externalName"] = _externalName;
    map["externalDescription"] = _externalDescription;
    map["publicEnabled"] = _publicEnabled;
    map["active"] = _active;
    map["custom"] = _custom;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    if (_services != null) {
      map["services"] = _services.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "38"
/// name : "Geodeti"
/// active : true
/// duration : "5"
/// additionalCustomerDuration : "0"
/// publicId : "6521f3ac31df516c85649a4bc1b2c42fe9e0ee9bd39a51f2faa3acceb36bbc0f"
/// publicEnabled : true
/// created : "1615897463388"
/// updated : "1615897492883"
/// custom : "{\"AppointmentType\":\"KATA\", \"ServicesType\":[\"UNIVER\"], \"issueCode\":\"\"}"
/// qpId : "27"
/// keyWords : null

class Services {
  String _id;
  String _name;
  bool _active;
  String _duration;
  String _additionalCustomerDuration;
  String _publicId;
  bool _publicEnabled;
  String _created;
  String _updated;
  String _custom;
  String _qpId;
  dynamic _keyWords;

  String get id => _id;
  String get name => _name;
  bool get active => _active;
  String get duration => _duration;
  String get additionalCustomerDuration => _additionalCustomerDuration;
  String get publicId => _publicId;
  bool get publicEnabled => _publicEnabled;
  String get created => _created;
  String get updated => _updated;
  String get custom => _custom;
  String get qpId => _qpId;
  dynamic get keyWords => _keyWords;

  Services({
      String id, 
      String name, 
      bool active, 
      String duration, 
      String additionalCustomerDuration, 
      String publicId, 
      bool publicEnabled, 
      String created, 
      String updated, 
      String custom, 
      String qpId, 
      dynamic keyWords}){
    _id = id;
    _name = name;
    _active = active;
    _duration = duration;
    _additionalCustomerDuration = additionalCustomerDuration;
    _publicId = publicId;
    _publicEnabled = publicEnabled;
    _created = created;
    _updated = updated;
    _custom = custom;
    _qpId = qpId;
    _keyWords = keyWords;
}

  Services.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _active = json["active"];
    _duration = json["duration"];
    _additionalCustomerDuration = json["additionalCustomerDuration"];
    _publicId = json["publicId"];
    _publicEnabled = json["publicEnabled"];
    _created = json["created"];
    _updated = json["updated"];
    _custom = json["custom"];
    _qpId = json["qpId"];
    _keyWords = json["keyWords"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["active"] = _active;
    map["duration"] = _duration;
    map["additionalCustomerDuration"] = _additionalCustomerDuration;
    map["publicId"] = _publicId;
    map["publicEnabled"] = _publicEnabled;
    map["created"] = _created;
    map["updated"] = _updated;
    map["custom"] = _custom;
    map["qpId"] = _qpId;
    map["keyWords"] = _keyWords;
    return map;
  }

}