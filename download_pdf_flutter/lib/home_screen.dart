import 'dart:io';

import 'package:dio/dio.dart';
import 'package:download_pdf_flutter/route_constants.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> createDirectoryInStorage() async {
    final path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );
    Directory documentsDirectory = Directory('$path/MyPDFs');
    Directory newDirectory = await documentsDirectory.create(recursive: true);
    print("New Directory created at : ${newDirectory.path}");
    return newDirectory.path;
  }

  Future<File?> downloadFile({
    required String url,
    required String fileName,
  }) async {
    Dio dio = Dio();
    try {
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      String path = await createDirectoryInStorage();
      File file = File('$path/$fileName');
      file.writeAsBytes(response.data);
      print('Files in the new directory: ${file.path}');
      final openFile = file.openSync(mode: FileMode.write);
      openFile.writeFromSync(response.data);
      await openFile.close();
      return file;
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Download and save PDF'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await downloadFile(
                  url: 'https://indico.ictp.it/event/a01167/material/1/4.pdf',
                  fileName: '4.pdf',
                );
              },
              child: const Text('Download file'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed(RouteConstants.login);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
