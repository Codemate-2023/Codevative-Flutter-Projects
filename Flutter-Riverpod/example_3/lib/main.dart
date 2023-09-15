// ignore_for_file: constant_identifier_names
//https://www.figma.com/file/gcBa7E9DggmYYbHwj99Hcr/KALHAT---Mobile?type=design&node-id=0-1&t=L3NbtlGhTPc09cn7-0
import 'package:flutter/foundation.dart';
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

enum City {
  Stockholm,
  Paris,
  Tokyo,
}

typedef WeatherString = String;

Future<String> getWeather(City city) async {
  if(kDebugMode) print(city.name);
  return await Future.delayed(
    const Duration(seconds: 2),
    () => {
      City.Stockholm: 'Rainy',
      City.Paris: 'Windy',
      City.Tokyo: 'Cloudy',
    }[city]!
    // () {
    //   var map = {
    //   City.Stockholm: 'Rainy',
    //   City.Paris: 'Windy',
    //   City.Tokyo: 'Cloudy',
    // };

    //   return map.values.where((element) => element == city.name).toString();
    // },
  );
}

//UI writes to this.
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeather = 'Undefined weather';

//UI reads this.
final weatherProvider = FutureProvider<WeatherString>(
  (ref) {
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return getWeather(city);
    } else {
      return unknownWeather;
    }
  },
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) print('build');
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(
              data,
              style: const TextStyle(fontSize: 40.0),
            ),
            error: (error, stacktrace) => Text(error.toString()),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(
                    city.name.toString(),
                  ),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () =>
                      ref.read(currentCityProvider.notifier).state = city,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
