class Symtom {
  String? disease;
  String? symptome;

  Symtom({this.disease, this.symptome});

  Symtom.fromJson(Map<String, dynamic> json) {
    disease = json['disease'];
    symptome = json['symptome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['disease'] = this.disease;
    data['symptome'] = this.symptome;
    return data;
  }
}