// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/routes/routes_name.dart';
import '../view_model/home_view_model.dart';
import '../view_model/user_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewViewModel homeViewViewModel = HomeViewViewModel();

  @override
  void initState() {
    homeViewViewModel.fetchMoviesListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPrefernece = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              userPrefernece.removeUser().then(
                (value) {
                  Navigator.pushNamed(context, RoutesName.login);
                },
              );
            },
            child: const Center(
              child: Text('Logout'),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: ChangeNotifierProvider<HomeViewViewModel>(
        create: (BuildContext context) => homeViewViewModel,
        child: Consumer<HomeViewViewModel>(
          builder: (context, value, _) {
            // switch (value.moviesList.status) {
            //   case Status.LOADING:
            //     return const Center(child: CircularProgressIndicator());
            //   case Status.ERROR:
            //     return Center(
            //         child: Text(
            //       value.moviesList.message.toString(),
            //     ));
            //   case Status.COMPLETED:
            return ListView.builder(
              itemCount: value.moviesList?.length ?? 1,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      value.moviesList?[index].name ?? "",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Text(
                      value.moviesList?[index].email ?? "",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          value.moviesList?[index].company?.name ?? ''
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
            // default:
            //   return Container();
          },
        ),
      ),
    );
  }
}
