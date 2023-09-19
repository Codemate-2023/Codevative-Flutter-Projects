// import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:users_app/users_model.dart';

import 'api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UsersModel>? users = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    users = await ApiService().getUsers();
    setState(() {});
    log(users.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, index) {
          log(' $index: ${users![index].name} from home page.');
          return Text(
            users![index].name!,
            style: Theme.of(context).textTheme.headlineMedium,
          );
        },
      ),
    );
  }
}
