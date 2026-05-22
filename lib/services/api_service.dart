import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // GET - Sab courses lao
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      return jsonList.take(20).map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception('Courses load nahi ho sake');
    }
  }

  // POST - Naya course add karo
  Future<Course> addCourse(String title, String body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body, 'userId': 1}),
    );
    if (response.statusCode == 201) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Course add nahi ho saka');
    }
  }

  // PUT - Course update karo
  Future<Course> updateCourse(int id, String title, String body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body, 'userId': 1}),
    );
    if (response.statusCode == 200) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Course update nahi ho saka');
    }
  }

  // DELETE - Course delete karo
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Course delete nahi ho saka');
    }
  }
}