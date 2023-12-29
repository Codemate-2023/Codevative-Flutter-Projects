import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'activity.dart';

// Necessary for code-generation to work
part 'provider.g.dart';

@riverpod
Future<Activity> activity(ActivityRef ref) async {
  String url = 'https://www.boredapi.com/api/activity/';
  final response = await http.get(Uri.parse(url));
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  return Activity.fromJson(json);
}
