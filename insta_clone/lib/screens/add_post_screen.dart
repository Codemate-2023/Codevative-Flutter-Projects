import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resources/firestore.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../modals/user_modal.dart';
import '../providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController descriptionController = TextEditingController();
  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return file.readAsBytes();
    }

    debugPrint('no image picked');
  }

  showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      print('post function clicked.');
      String res = await FirestoreMethods().uploadPost(
        descriptionController.text,
        _file!,
        profileImage,
        username,
        uid,
      );

      if (res == 'success') {
        print('post function success.');
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted.');
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Error!');
      }
    } catch (e) {
      print('post function $e.');
      showSnackBar(e.toString());
    }
  }

  void back() {
    if (mounted) {
      setState(() {
        _file = null;
      });
    }
    Navigator.of(context).pop();
  }

  void clearImage() {
    if (mounted) {
      setState(() {
        _file = null;
      });
    }
    // Navigator.of(context).pop();
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a new post.'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(12.0),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file!;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(12.0),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List? file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file!;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(12.0),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser;
    // print('${user.email} from here 123');
    // print('${user.photoUrl} from here 123');
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () => back(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    user.uid!,
                    user.username!,
                    '',
                    // user.photoUrl!,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0.0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        user.photoUrl!,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
