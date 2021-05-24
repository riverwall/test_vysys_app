/// times : ["09:00","09:15","09:30","09:45","10:00","10:15","10:30","10:45","11:00","11:15","11:30","11:45","12:00","12:15","12:30","12:45","13:00","13:15","13:30","13:45","14:00","14:15","14:30","14:45"]
/// meta : {"start":"","end":"","totalResults":24,"offset":null,"limit":null,"fields":"","arguments":{"a1":"a1","a2":"a2"}}
/// notifications : ["priklad1","priklad2"]

class DataTimes {
  List<String> _times;
  Meta _meta;
  List<String> _notifications;

  List<String> get times => _times;
  Meta get meta => _meta;
  List<String> get notifications => _notifications;

  DataTimes({
      List<String> times, 
      Meta meta, 
      List<String> notifications}){
    _times = times;
    _meta = meta;
    _notifications = notifications;
}

  DataTimes.fromJson(dynamic json) {
    _times = json["times"] != null ? json["times"].cast<String>() : [];
    _meta = json["meta"] != null ? Meta.fromJson(json["meta"]) : null;
    _notifications = json["notifications"] != null ? json["notifications"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["times"] = _times;
    if (_meta != null) {
      map["meta"] = _meta.toJson();
    }
    map["notifications"] = _notifications;
    return map;
  }

}

/// start : ""
/// end : ""
/// totalResults : 24
/// offset : null
/// limit : null
/// fields : ""
/// arguments : {"a1":"a1","a2":"a2"}

class Meta {
  String _start;
  String _end;
  int _totalResults;
  dynamic _offset;
  dynamic _limit;
  String _fields;
  Arguments _arguments;

  String get start => _start;
  String get end => _end;
  int get totalResults => _totalResults;
  dynamic get offset => _offset;
  dynamic get limit => _limit;
  String get fields => _fields;
  Arguments get arguments => _arguments;

  Meta({
      String start, 
      String end, 
      int totalResults, 
      dynamic offset, 
      dynamic limit, 
      String fields, 
      Arguments arguments}){
    _start = start;
    _end = end;
    _totalResults = totalResults;
    _offset = offset;
    _limit = limit;
    _fields = fields;
    _arguments = arguments;
}

  Meta.fromJson(dynamic json) {
    _start = json["start"];
    _end = json["end"];
    _totalResults = json["totalResults"];
    _offset = json["offset"];
    _limit = json["limit"];
    _fields = json["fields"];
    _arguments = json["arguments"] != null ? Arguments.fromJson(json["arguments"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["start"] = _start;
    map["end"] = _end;
    map["totalResults"] = _totalResults;
    map["offset"] = _offset;
    map["limit"] = _limit;
    map["fields"] = _fields;
    if (_arguments != null) {
      map["arguments"] = _arguments.toJson();
    }
    return map;
  }

}

/// a1 : "a1"
/// a2 : "a2"

class Arguments {
  String _a1;
  String _a2;

  String get a1 => _a1;
  String get a2 => _a2;

  Arguments({
      String a1, 
      String a2}){
    _a1 = a1;
    _a2 = a2;
}

  Arguments.fromJson(dynamic json) {
    _a1 = json["a1"];
    _a2 = json["a2"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["a1"] = _a1;
    map["a2"] = _a2;
    return map;
  }

}