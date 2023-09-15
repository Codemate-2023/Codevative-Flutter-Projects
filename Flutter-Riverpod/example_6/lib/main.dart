import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavourite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavourite,
  });

  Film copy({required bool isFavourite}) => Film(
        id: id,
        title: title,
        description: description,
        isFavourite: isFavourite,
      );

  @override
  String toString() => 'Film(id: $id,'
      ' title: $title,'
      ' description: $description,'
      ' isFavourite: $isFavourite)';

  @override
  bool operator ==(covariant Film other) =>
      id == other.id &&
      title == other.title &&
      isFavourite == other.isFavourite;

  @override
  int get hashCode => Object.hashAll([
        id,
        isFavourite,
      ]);
}

enum FavouriteStatus {
  all,
  favourite,
  notFavourite,
}

final favouriteStatusProvider = StateProvider<FavouriteStatus>(
  (_) => FavouriteStatus.all,
);
 
//all films
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier(),
);

//all favourite films
final favouriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => film.isFavourite,
      ),
);

//all non favourite films
final notFavouriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => !film.isFavourite,
      ),
);

const allFilms = [
  Film(
    id: '1',
    title: 'The Shawshank Redemption',
    description: "Description for the Shawshank Redemption",
    isFavourite: false,
  ),
  Film(
    id: '2',
    title: 'The Godfather',
    description: "Description for The Godfather",
    isFavourite: false,
  ),
  Film(
    id: '3',
    title: 'The Godfather: Part II',
    description: "Description for The Godfather: Part II",
    isFavourite: false,
  ),
  Film(
    id: '4',
    title: 'The Dark Night',
    description: "Description for The Dark Night",
    isFavourite: false,
  ),
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void update(Film film, bool isFavourite) {
    state = state
        .map(
          (thisFilm) => thisFilm.id == film.id
              ? thisFilm.copy(isFavourite: isFavourite)
              : thisFilm,
        )
        .toList();
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Films'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(
            builder: (context, ref, child) {
              final filter = ref.watch(favouriteStatusProvider);
              switch (filter) {
                case FavouriteStatus.all:
                  return FilmsWidget(provider: allFilmsProvider);
                case FavouriteStatus.favourite:
                  return FilmsWidget(provider: favouriteFilmsProvider);
                case FavouriteStatus.notFavourite:
                  return FilmsWidget(provider: notFavouriteFilmsProvider);
                default:
                  return FilmsWidget(provider: allFilmsProvider);
              }
            },
          ),
        ],
      ),
    );
  }
}

class FilmsWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsWidget({
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          final favouriteIcon = film.isFavourite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border);

          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            trailing: IconButton(
              icon: favouriteIcon,
              onPressed: () {
                final isFavourite = !film.isFavourite;
                ref.read(allFilmsProvider.notifier).update(
                      film,
                      isFavourite,
                    );
              },
            ),
          );
        },
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton(
          items: FavouriteStatus.values
              .map(
                (fs) => DropdownMenuItem(
                  value: fs,
                  child: Text(
                    fs.toString().split('.').last,
                  ),
                ),
              )
              .toList(),
          value: ref.watch(favouriteStatusProvider),
          onChanged: (FavouriteStatus? fs) {
            ref.read(favouriteStatusProvider.notifier).state = fs!;
          },
        );
      },
    );
  }
}
