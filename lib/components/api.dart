import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wms_mst/components/prefences.dart';
import 'package:wms_mst/model/group.dart';

class ApiService {
  static const String updatedurl = "http://lms.muepetro.com/api";

  static Future fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$updatedurl/$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$updatedurl/$endpoint'),
        headers: {
          'Content-Type': 'application/json', // Specify content-type
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
}

//api mismaster
Future<void> fetchDataByMiscTypeId(
  int miscTypeId,
  List<Map<String, dynamic>> listToUpdate,
) async {
  final url = Uri.parse(
    'http://lms.muepetro.com/api/UserController1/GetMiscMasterLocationWise?MiscTypeId=$miscTypeId&LocationId=${Preference.getString(PrefKeys.locationId)}',
  );
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<Goruppartmodel> goruppartmodelList = grouppartmodelFromJson(
        response.body,
      );
      listToUpdate.clear();
      for (var item in goruppartmodelList) {
        listToUpdate.add({'id': item.id, 'name': item.name});
      }
    } else {
      // Handle error if needed
    }
  } catch (e) {
    // Handle error if needed
  }
}
