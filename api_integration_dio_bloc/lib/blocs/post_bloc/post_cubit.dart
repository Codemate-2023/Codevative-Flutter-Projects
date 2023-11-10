import 'package:api_integration_dio_bloc/blocs/post_bloc/post_state.dart';
import 'package:api_integration_dio_bloc/data/modals/posts_modal.dart';
import 'package:api_integration_dio_bloc/data/repositories/post_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostLoadingState()) {
    fetchPosts();
  }

  PostRepository postRepository = PostRepository();

  void fetchPosts() async {
    try {
      List<UserPosts> posts = await postRepository.fetchPosts();
      emit(PostLoadedState(posts));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        emit(
          PostErrorState(
            "Can't fetch posts, please check your internet connection!",
          ),
        );
      } else {
        emit(
          PostErrorState(
            e.type.toString(),
          ),
        );
      }
    }
  }
}
