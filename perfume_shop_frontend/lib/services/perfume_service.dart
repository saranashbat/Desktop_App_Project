import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/perfume.dart';

class PerfumeService {
  // -------------------------------
  // GET ALL PERFUMES
  // -------------------------------
  Future<List<Perfume>> getAllPerfumes() async {
  final response = await http.get(Uri.parse(GlobalParameters.perfumesEndpoint));

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    // If backend returns a list
    if (decoded is List) {
      return decoded.map((e) => Perfume.fromJson(e)).toList();
    } 
    // If backend returns a single object
    else if (decoded is Map<String, dynamic>) {
      return [Perfume.fromJson(decoded)];
    } else {
      throw Exception('Unexpected response format');
    }
  } else {
    throw Exception('Failed to load perfumes');
  }
}


  // -------------------------------
  // GET PERFUME BY ID
  // -------------------------------
  Future<Perfume?> getPerfumeById(String id) async {
    final response = await http.get(Uri.parse('${GlobalParameters.perfumesEndpoint}/$id'));

    if (response.statusCode == 200) {
      return Perfume.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load perfume by id');
    }
  }

  // -------------------------------
  // CREATE PERFUME
  // -------------------------------
  Future<Perfume> createPerfume(Perfume perfume) async {
    final response = await http.post(
      Uri.parse(GlobalParameters.perfumesEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(perfume.toJson()),
    );

    if (response.statusCode == 201) {
      return Perfume.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create perfume');
    }
  }

  // -------------------------------
  // DELETE PERFUME
  // -------------------------------
  Future<void> deletePerfume(String id) async {
    final response = await http.delete(Uri.parse('${GlobalParameters.perfumesEndpoint}/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete perfume');
    }
  }

  // -------------------------------
  // FILTER BY BRAND
  // -------------------------------
  Future<List<Perfume>> getPerfumesByBrand(String brand) async {
    final response = await http.get(Uri.parse('${GlobalParameters.perfumesEndpoint}/filter/brand/$brand'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Perfume.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load perfumes by brand');
    }
  }

  // -------------------------------
  // FILTER BY NOTE
  // -------------------------------
  Future<List<Perfume>> getPerfumesByNote(String noteName) async {
    final response = await http.get(Uri.parse('${GlobalParameters.perfumesEndpoint}/filter/note/$noteName'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Perfume.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load perfumes by note');
    }
  }

  // -------------------------------
  // FILTER BY BRAND + NOTE
  // -------------------------------
  Future<List<Perfume>> getPerfumesByBrandAndNote({String? brand, String? note}) async {
    final uri = Uri.parse('${GlobalParameters.perfumesEndpoint}/filter')
        .replace(queryParameters: {
      if (brand != null) 'brand': brand,
      if (note != null) 'note': note,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Perfume.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load perfumes by brand and note');
    }
  }

  // -------------------------------
  // FILTER BY PRICE RANGE
  // -------------------------------
  Future<List<Perfume>> getPerfumesByPriceRange(double min, double max) async {
    final uri = Uri.parse('${GlobalParameters.perfumesEndpoint}/price')
        .replace(queryParameters: {
      'min': min.toString(),
      'max': max.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Perfume.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load perfumes by price range');
    }
  }
}
