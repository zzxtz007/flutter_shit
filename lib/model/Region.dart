class Region {
  String code;
  String name;
  List<Pchild> pchilds;

  Region({this.code, this.name, this.pchilds});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      code: json['code'],
      name: json['name'],
      pchilds: json['pchilds'] != null ? (json['pchilds'] as List).map((i) => Pchild.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.pchilds != null) {
      data['pchilds'] = this.pchilds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pchild {
  List<Cchild> cchilds;
  String code;
  String name;

  Pchild({this.cchilds, this.code, this.name});

  factory Pchild.fromJson(Map<String, dynamic> json) {
    return Pchild(
      cchilds: json['cchilds'] != null ? (json['cchilds'] as List).map((i) => Cchild.fromJson(i)).toList() : null,
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.cchilds != null) {
      data['cchilds'] = this.cchilds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cchild {
  String code;
  String name;

  Cchild({this.code, this.name});

  factory Cchild.fromJson(Map<String, dynamic> json) {
    return Cchild(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
