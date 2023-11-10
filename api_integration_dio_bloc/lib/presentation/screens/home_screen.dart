import 'package:api_integration_dio_bloc/blocs/post_bloc/post_cubit.dart';
import 'package:api_integration_dio_bloc/blocs/post_bloc/post_state.dart';
import 'package:api_integration_dio_bloc/data/modals/posts_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../UI/listview_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Handling using Dio and Bloc'),
      ),
      body: SafeArea(
        child: BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state is PostErrorState) {
              SnackBar snackBar = SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is PostLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PostLoadedState) {
              return UsersList(post: state.posts);
            }
            return const Center(
              child: Text('An error occurred!'),
            );
          },
        ),
      ),
    );
  }
}
