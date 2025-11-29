import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global/global_parameters.dart';
import '../models/brand.dart';

class BrandService {
  // -------------------------------
  // GET ALL BRANDS
  // -------------------------------
  Future<List<Brand>> getAllBrands() async {
    final response = await http.get(Uri.parse(GlobalParameters.brandsEndpoint));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Brand.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }

  // -------------------------------
  // GET BRAND BY ID
  // -------------------------------
  Future<Brand?> getBrandById(String id) async {
    final response = await http.get(Uri.parse('${GlobalParameters.brandsEndpoint}/$id'));

    if (response.statusCode == 200) {
      return Brand.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load brand by id');
    }
  }

  // -------------------------------
  // GET BRAND BY NAME
  // -------------------------------
  Future<Brand?> getBrandByName(String name) async {
    final response = await http.get(Uri.parse('${GlobalParameters.brandsEndpoint}/name/$name'));

    if (response.statusCode == 200) {
      return Brand.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to load brand by name');
    }
  }

  // -------------------------------
  // CREATE BRAND
  // -------------------------------
  Future<Brand> createBrand(Brand brand) async {
    final response = await http.post(
      Uri.parse(GlobalParameters.brandsEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(brand.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Brand.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create brand');
    }
  }

  // -------------------------------
  // UPDATE BRAND
  // -------------------------------
  Future<Brand> updateBrand(String id, Brand brand) async {
    final response = await http.put(
      Uri.parse('${GlobalParameters.brandsEndpoint}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(brand.toJson()),
    );

    if (response.statusCode == 200) {
      return Brand.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update brand');
    }
  }

  // -------------------------------
  // DELETE BRAND
  // -------------------------------
  Future<void> deleteBrand(String id) async {
    final response = await http.delete(Uri.parse('${GlobalParameters.brandsEndpoint}/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete brand');
    }
  }
}
