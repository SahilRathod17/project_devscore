// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_null_comparison

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_devscore/services/auth_methods.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/utils/picking_image.dart';
import 'package:project_devscore/widgets/snackbar.dart';
import 'package:project_devscore/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading2 = false;

  @override
  void dispose() {
    super.dispose();
    // it's important to dispose these controllers  after this widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await PickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  // function from auth_methods to sign up an user
  void SignInUser() async {
    setState(() {
      _isLoading2 = true;
    });
    // print('helloooooo');
    if (_image != null) {
      String result = await AuthMethods().SignupUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _userNameController.text,
          bio: _bioController.text,
          file: _image!);
      setState(() {
        _isLoading2 = false;
      });

      if (result != 'success') {
        showSnackBar(context, result.toString());
      }
    }
    setState(() {
      _isLoading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              Text(
                'DevsCore',
                style: TextStyle(
                    fontSize: 70.0,
                    fontFamily: 'Festive',
                    fontWeight: FontWeight.w500),
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 45.0,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 45.0,
                          backgroundImage: NetworkImage(
                              'https://mbweb.b-cdn.net/images/nouser.png'),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 50.0,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo_rounded),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextFieldInput(
                  hintText: 'Enter your username',
                  textEditingController: _userNameController,
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24.0,
              ),
              TextFieldInput(
                  hintText: 'Enter your email',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24.0,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textEditingController: _passwordController,
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextFieldInput(
                hintText: 'Enter your position',
                textEditingController: _bioController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 25.0,
              ),
              InkWell(
                onTap: SignInUser,
                child: Container(
                  child: _isLoading2
                      ? Center(
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(
                            fontFamily: 'pacifico',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'OR',
                style: TextStyle(fontFamily: 'pacifico'),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign up with   ',
                        style:
                            TextStyle(fontFamily: 'pacifico', fontSize: 18.0),
                      ),
                      Icon(EvaIcons.githubOutline),
                    ],
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
