import 'dart:convert';

List<Staffmodel> staffmodelFromJson(String str) =>
    List<Staffmodel>.from(json.decode(str).map((x) => Staffmodel.fromJson(x)));

String staffmodelToJson(List<Staffmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Staffmodel {
  final int id;
  final String staffName;

  Staffmodel({
    required this.id,
    required this.staffName,
  });

  factory Staffmodel.fromJson(Map<String, dynamic> json) => Staffmodel(
        id: json["id"],
        staffName: json["staff_Name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "staff_Name": staffName,
      };
}

List<Goruppartmodel> grouppartmodelFromJson(String str) =>
    List<Goruppartmodel>.from(
        json.decode(str).map((x) => Goruppartmodel.fromJson(x)));

String grouppartmodelToJson(List<Goruppartmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Goruppartmodel {
  final int id;
  final String name;
  final int locationId;
  final int miscMasterId;

  Goruppartmodel({
    required this.id,
    required this.name,
    required this.locationId,
    required this.miscMasterId,
  });

  factory Goruppartmodel.fromJson(Map<String, dynamic> json) => Goruppartmodel(
        id: json["id"],
        name: json["name"],
        locationId: json["locationId"],
        miscMasterId: json["miscMasterId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "locationId": locationId,
        "miscMasterId": miscMasterId,
      };
}
