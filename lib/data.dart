class Branch {
  String id;
  List<Services> services;
  String externalDescription;
  String internalName;
  String updatedAt;
  String externalName;
  String prefix;
  String createdAt;
  bool active;
  String internalDescription;
  bool publicEnabled;
  String custom;

  Branch(
      {this.id,
        this.services,
        this.externalDescription,
        this.internalName,
        this.updatedAt,
        this.externalName,
        this.prefix,
        this.createdAt,
        this.active,
        this.internalDescription,
        this.publicEnabled,
        this.custom});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    externalDescription = json['externalDescription'];
    internalName = json['internalName'];
    updatedAt = json['updatedAt'];
    externalName = json['externalName'];
    prefix = json['prefix'];
    createdAt = json['createdAt'];
    active = json['active'];
    internalDescription = json['internalDescription'];
    publicEnabled = json['publicEnabled'];
    custom = json['custom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    data['externalDescription'] = this.externalDescription;
    data['internalName'] = this.internalName;
    data['updatedAt'] = this.updatedAt;
    data['externalName'] = this.externalName;
    data['prefix'] = this.prefix;
    data['createdAt'] = this.createdAt;
    data['active'] = this.active;
    data['internalDescription'] = this.internalDescription;
    data['publicEnabled'] = this.publicEnabled;
    data['custom'] = this.custom;
    return data;
  }
}

class Services {
  String id;
  String additionalCustomerDuration;
  String duration;
  String qpId;
  String updated;
  String created;
  String name;
  String publicId;
  String keyWords;
  bool active;
  bool publicEnabled;
  String custom;

  Services(
      {this.id,
        this.additionalCustomerDuration,
        this.duration,
        this.qpId,
        this.updated,
        this.created,
        this.name,
        this.publicId,
        this.keyWords,
        this.active,
        this.publicEnabled,
        this.custom});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    additionalCustomerDuration = json['additionalCustomerDuration'];
    duration = json['duration'];
    qpId = json['qpId'];
    updated = json['updated'];
    created = json['created'];
    name = json['name'];
    publicId = json['publicId'];
    keyWords = json['keyWords'];
    active = json['active'];
    publicEnabled = json['publicEnabled'];
    custom = json['custom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['additionalCustomerDuration'] = this.additionalCustomerDuration;
    data['duration'] = this.duration;
    data['qpId'] = this.qpId;
    data['updated'] = this.updated;
    data['created'] = this.created;
    data['name'] = this.name;
    data['publicId'] = this.publicId;
    data['keyWords'] = this.keyWords;
    data['active'] = this.active;
    data['publicEnabled'] = this.publicEnabled;
    data['custom'] = this.custom;
    return data;
  }
}