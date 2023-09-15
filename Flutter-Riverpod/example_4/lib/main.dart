import 'dart:async';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'Dave',
  'Eve',
  'Fred',
  'Ginny',
  'Hank',
  'Irene',
  'Jack',
  'Kate',
  'Larry',
];

final tickerProvider = StreamProvider<int>(
  (ref) => Stream.periodic(const Duration(seconds: 1), (i) => i + 1),
);

final namesProvider = StreamProvider<List<String>>((ref) {
  final controller = StreamController<List<String>>();
  StreamSubscription<int>? subscription;

  void updateStream(int count) {
    final namesList = names.getRange(0, count).toList();
    controller.sink.add(namesList);
  }

  ref.onDispose(
    () {
      subscription?.cancel();
      controller.close();
    },
  );

  subscription = ref.watch(tickerProvider.stream).listen(updateStream);

  return controller.stream;
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Provider'),
      ),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(names[index]),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('$error'),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
