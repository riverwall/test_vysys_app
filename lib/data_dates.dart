/// meta : {"start":"","end":"","totalResults":20,"offset":null,"limit":null,"fields":"","arguments":""}
/// dates : ["2021-04-14T00:00:00","2021-04-15T00:00:00","2021-04-16T00:00:00","2021-04-19T00:00:00","2021-04-20T00:00:00","2021-04-21T00:00:00","2021-04-22T00:00:00","2021-04-23T00:00:00","2021-04-26T00:00:00","2021-04-27T00:00:00","2021-04-28T00:00:00","2021-04-29T00:00:00","2021-04-30T00:00:00","2021-05-03T00:00:00","2021-05-04T00:00:00","2021-05-05T00:00:00","2021-05-06T00:00:00","2021-05-07T00:00:00","2021-05-10T00:00:00","2021-05-11T00:00:00"]
/// notifications : ["test1","test2"]

class DataDates {
  Meta _meta;
  List<String> _dates;
  List<String> _notifications;

  Meta get meta => _meta;
  List<String> get dates => _dates;
  List<String> get notifications => _notifications;

  DataDates({
      Meta meta, 
      List<String> dates, 
      List<String> notifications}){
    _meta = meta;
    _dates = dates;
    _notifications = notifications;
}

  DataDates.fromJson(dynamic json) {
    _meta = json["meta"] != null ? Meta.fromJson(json["meta"]) : null;
    _dates = json["dates"] != null ? json["dates"].cast<String>() : [];
    _notifications = json["notifications"] != null ? json["notifications"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_meta != null) {
      map["meta"] = _meta.toJson();
    }
    map["dates"] = _dates;
    map["notifications"] = _notifications;
    return map;
  }

}

/// start : ""
/// end : ""
/// totalResults : 20
/// offset : null
/// limit : null
/// fields : ""
/// arguments : ""

class Meta {
  String _start;
  String _end;
  int _totalResults;
  dynamic _offset;
  dynamic _limit;
  String _fields;
  dynamic _arguments;

  String get start => _start;
  String get end => _end;
  int get totalResults => _totalResults;
  dynamic get offset => _offset;
  dynamic get limit => _limit;
  String get fields => _fields;
  String get arguments => _arguments;

  Meta({
      String start, 
      String end, 
      int totalResults, 
      dynamic offset, 
      dynamic limit, 
      String fields, 
      String arguments}){
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
    _arguments = json["arguments"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["start"] = _start;
    map["end"] = _end;
    map["totalResults"] = _totalResults;
    map["offset"] = _offset;
    map["limit"] = _limit;
    map["fields"] = _fields;
    map["arguments"] = _arguments;
    return map;
  }

}