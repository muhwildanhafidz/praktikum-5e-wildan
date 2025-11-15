import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  // Using localhost by default. If running on Android emulator use 10.0.2.2 instead.
  // If you run on a real device, replace this with your machine IP, e.g. "http://192.168.0.10:8000"
  static const String _host = 'http://localhost:8000';

  final String baseUrl = '$_host/api/barang';

  Future<List<Item>> fetchItems() async {
    final uri = Uri.parse(baseUrl);
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is List) {
        return body
            .map((e) => Item.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      // Some APIs return an object with data key
      if (body is Map && body['data'] is List) {
        return (body['data'] as List)
            .map((e) => Item.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load items: ${resp.statusCode}');
    }
  }

  Future<Item> createItem(String name, String price) async {
    final uri = Uri.parse(baseUrl);
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': name, 'harga': price}),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      // If API returns created object directly
      if (body is Map) return Item.fromJson(Map<String, dynamic>.from(body));
      // If API wraps data
      if (body is Map && body['data'] is Map)
        return Item.fromJson(Map<String, dynamic>.from(body['data']));
      throw Exception('Unexpected create response');
    } else {
      throw Exception('Failed to create item: ${resp.statusCode} ${resp.body}');
    }
  }

  Future<Item> updateItem(Item item) async {
    if (item.id == null) throw Exception('Item id is null');
    final uri = Uri.parse('$baseUrl/${item.id}');
    final resp = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': item.name, 'harga': item.price}),
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body is Map) return Item.fromJson(Map<String, dynamic>.from(body));
      if (body is Map && body['data'] is Map)
        return Item.fromJson(Map<String, dynamic>.from(body['data']));
      throw Exception('Unexpected update response');
    } else {
      throw Exception('Failed to update item: ${resp.statusCode} ${resp.body}');
    }
  }

  Future<void> deleteItem(int id) async {
    final uri = Uri.parse('$baseUrl/$id');
    final resp = await http.delete(uri);
    if (resp.statusCode == 200 || resp.statusCode == 204) return;
    throw Exception('Failed to delete item: ${resp.statusCode} ${resp.body}');
  }
}
