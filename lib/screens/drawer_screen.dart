import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/community_screen.dart';
import 'package:project_devscore/screens/login_screen.dart';
import 'package:project_devscore/screens/profile_screen.dart';
import 'package:project_devscore/services/auth_methods.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/widgets/log_out_alert.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    Key? key,
    required this.UserData,
  }) : super(key: key);

  final Map UserData;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
        ),
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(UserData['photoUrl']),
            radius: MediaQuery.of(context).size.width * 0.18,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            UserData['username'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            UserData['bio'],
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => ProfileScreen(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                      )),
                ),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.person,
              color: blueColor,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => CommunityScreen(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        showBackOption: true,
                      )),
                ),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.groups,
              color: blueColor,
            ),
            title: const Text(
              'Community',
              style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                context: context,
                builder: ((context) {
                  return LogOutAlert(
                    title: 'Logout',
                    content: 'Are your sure you want to logout ?',
                    onPressed: () async {
                      await AuthMethods().SignOut();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => LoginScreen()),
                        ),
                      );
                    },
                  );
                }),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.exit_to_app,
              color: blueColor,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
