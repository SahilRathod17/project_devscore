// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_devscore/model/user_model.dart';
import 'package:project_devscore/providers/userdata_provider.dart';
import 'package:project_devscore/services/firestore_methods.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/utils/picking_image.dart';
import 'package:project_devscore/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _desc = TextEditingController();

  bool _isLoading = false;

  void PostImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    // starts loading
    try {
      String res = await FireStoreMethods().uploadPost(
        _desc.text,
        _file!,
        uid,
        username,
        profImage,
      );

      if (res.toString() == "done") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Post uploaded');
        clearImage();
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res.toString());
        clearImage();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: ((context) {
        return SimpleDialog(
          title: const Text('Post something'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await PickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await PickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
          ],
        );
      }),
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _desc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserDataProvider>(context).getUserData;
    return _file == null
        ? Material(
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.upload,
                  size: 50.0,
                ),
                onPressed: () {
                  _selectImage(context);
                },
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text(
                'Post to profile',
                style: TextStyle(fontFamily: 'pacifico'),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                    onPressed: () =>
                        PostImage(user.uid, user.username, user.photoUrl),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          fontFamily: 'pacifico',
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _desc,
                        decoration: const InputDecoration(
                          hintText: 'Write about post',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
