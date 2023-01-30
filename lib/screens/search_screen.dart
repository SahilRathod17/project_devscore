// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_devscore/screens/chat_screen.dart';
import 'package:project_devscore/screens/profile_screen.dart';
import 'package:project_devscore/services/user_community.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project_devscore/utils/string_manipulation.dart';
import 'package:project_devscore/widgets/post_card.dart';
import 'package:project_devscore/widgets/snackbar.dart';

class SearchScreen extends StatefulWidget {
  final String uid;
  const SearchScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUser = false;
  bool showOptions = false;
  bool showCommunity = false;
  bool isJoined = false;

  bool isLoading = false;
  bool hasUserSearched = false;

  // some things
  var UserData = {};
  String username = "";
  QuerySnapshot? searchSnapshot;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdName();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  getCurrentUserIdName() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      UserData = userSnap.data()!;
      username = UserData['username'.trim()];
      // print("XXXXXXXX ${username}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: TextFormField(
          cursorColor: blackColor,
          controller: searchController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(
              color: blackColor,
            ),
            labelText: 'Search here',
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onFieldSubmitted: (String tx) {
            tx = tx.trim();
            if (tx != null) {
              setState(() {
                isShowUser = true;
                showOptions = true;
                initiateSearchMethod();
              });
            }
          },
          // onChanged: (String tx) {
          //   tx = tx.trim();
          //   if (tx != null) {
          //     setState(() {
          //       isShowUser = true;
          //       showOptions = true;
          //       initiateSearchMethod();
          //     });
          //   }
          // },
        ),
      ),
      body: isShowUser
          ? Column(
              children: [
                showOptions
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showOptions = false;
                                showCommunity = false;
                              });
                            },
                            child: const Text(
                              'user',
                              style: TextStyle(
                                color: blueColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              initiateSearchMethod();
                              setState(() {
                                showOptions = false;
                                showCommunity = true;
                              });
                            },
                            child: const Text(
                              'community',
                              style: TextStyle(
                                color: blueColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                Expanded(
                  child: showCommunity
                      ? isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : communityList()
                      : FutureBuilder(
                          // we can't just get 'users' we need to get user who were searched so we can use where method that firebase provides us

                          future: FirebaseFirestore.instance
                              .collection('users')
                              .where(
                                'username',
                                isGreaterThanOrEqualTo: searchController.text,
                              )
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData &&
                                searchController.text != null &&
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (FirebaseAuth
                                            .instance.currentUser!.uid !=
                                        (snapshot.data! as dynamic).docs[index]
                                            ['uid']) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: ((context) => ProfileScreen(
                                              uid: (snapshot.data! as dynamic)
                                                  .docs[index]['uid'])),
                                        ),
                                      );
                                    }
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['photoUrl'],
                                      ),
                                    ),
                                    title: Text(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['username'],
                                      style: const TextStyle(color: blackColor),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                ),
              ],
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished', descending: true)
                  .get(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: PostCard(
                                    snap: snapshot.data!.docs[index].data()),
                              ))));
                    },
                    child: Image.network(
                      (snapshot.data! as dynamic).docs[index]['photoUrl'],
                    ),
                  ),
                );
              }),
            ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await CommunityService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  communityList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return CommunityTile(
                username,
                searchSnapshot!.docs[index]['CommunityId'],
                searchSnapshot!.docs[index]['CommunityName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  JoinedOrNot(String username, String CommunityName, String CommunityId,
      String admin) async {
    await CommunityService(uid: widget.uid)
        .isUserJoined(CommunityName, CommunityId, username)
        .then((value) {
      setState(() {
        isJoined = value;
        // print("XXXXXXXXXXXXXXX = $value");
      });
    });
  }

  Widget CommunityTile(
      String username, String communityId, communityName, String admin) {
    JoinedOrNot(username, communityName, communityId, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          communityName.toString().substring(0, 1).toUpperCase(),
          style: const TextStyle(color: primaryColor),
        ),
      ),
      title: Text(
        communityName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text("Admin : ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await CommunityService(uid: widget.uid)
              .toggleCommunity(communityId, username, communityName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, "Successfully joined the community");
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ChatPage(
                    communityId: communityId,
                    communityName: communityName,
                    username: username);
              }));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackBar(context, "Left the community $communityName");
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                  border: Border.all(
                    color: primaryColor,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: const Text(
                  "Joined",
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: const Text(
                  'Join',
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
              ),
      ),
    );
  }
}


//  FutureBuilder<QuerySnapshot>(
//                           future:
//                               Future.delayed(const Duration(seconds: 1), () {
//                             return FirebaseFirestore.instance
//                                 .collection('communities')
//                                 .where(
//                                   'CommunityName',
//                                   // isEqualTo: searchController.text,
//                                   isGreaterThanOrEqualTo: searchController.text,
//                                 )
//                                 .get();
//                           }),
//                           builder: (context, AsyncSnapshot snapshot) {
//                             if (!snapshot.hasData &&
//                                 searchController.text != null &&
//                                 snapshot.connectionState ==
//                                     ConnectionState.waiting) {
//                               return const Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }
//                             return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount:
//                                   (snapshot.data as dynamic).docs!.length,
//                               itemBuilder: ((context, index) {
//                                 JoinedOrNot(
//                                     username,
//                                     getName((snapshot.data as dynamic)
//                                         .docs![index]['CommunityName']),
//                                     (snapshot.data as dynamic).docs![index]
//                                         ['CommunityId'],
//                                     getName((snapshot.data as dynamic)
//                                         .docs![index]['admin']));

//                                 return ListTile(
//                                   onTap: () async {
//                                     await CommunityService(uid: widget.uid)
//                                         .toggleCommunity(
//                                             (snapshot.data as dynamic)
//                                                 .docs![index]['CommunityId'],
//                                             username,
//                                             getName((snapshot.data as dynamic)
//                                                     .docs![index]
//                                                 ['CommunityName']));
//                                     if (isJoined) {
//                                       setState(() {
//                                         isJoined = !isJoined;
//                                       });
//                                       showSnackBar(context, 'Joined');
//                                       Future.delayed(const Duration(seconds: 1),
//                                           () {
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) {
//                                           return ChatPage(
//                                               communityId: (snapshot.data
//                                                       as dynamic)
//                                                   .docs![index]['CommunityId'],
//                                               communityName: getName(
//                                                   (snapshot.data as dynamic)
//                                                           .docs![index]
//                                                       ['CommunityName']),
//                                               username: username);
//                                         }));
//                                       });
//                                     } else {
//                                       setState(() {
//                                         isJoined = !isJoined;
//                                         showSnackBar(context, "Joined");
//                                       });
//                                     }
//                                   },
//                                   // trailing: isJoined
//                                   //     ? Container(
//                                   //         decoration: BoxDecoration(
//                                   //           borderRadius:
//                                   //               BorderRadius.circular(10),
//                                   //           color: Colors.grey,
//                                   //           border: Border.all(
//                                   //             color: primaryColor,
//                                   //           ),
//                                   //         ),
//                                   //         padding: const EdgeInsets.symmetric(
//                                   //           horizontal: 20,
//                                   //           vertical: 10,
//                                   //         ),
//                                   //         child: const Text(
//                                   //           "Joined",
//                                   //           style: TextStyle(
//                                   //             color: primaryColor,
//                                   //           ),
//                                   //         ),
//                                   //       )
//                                   //     : Container(
//                                   //         decoration: BoxDecoration(
//                                   //           borderRadius:
//                                   //               BorderRadius.circular(10),
//                                   //           color:
//                                   //               Theme.of(context).primaryColor,
//                                   //         ),
//                                   //         padding: const EdgeInsets.symmetric(
//                                   //           horizontal: 20,
//                                   //           vertical: 10,
//                                   //         ),
//                                   //         child: const Text(
//                                   //           'Join',
//                                   //           style: TextStyle(
//                                   //             color: primaryColor,
//                                   //           ),
//                                   //         ),
//                                   //       ),
//                                   leading: CircleAvatar(
//                                     radius: 20,
//                                     backgroundColor:
//                                         Theme.of(context).primaryColor,
//                                     child: Text(
//                                       getName((snapshot.data as dynamic)
//                                               .docs![index]['CommunityName'])
//                                           .substring(0, 1)
//                                           .toUpperCase(),
//                                       style: const TextStyle(
//                                         color: primaryColor,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   subtitle: Text('Admin : ' +
//                                       getName((snapshot.data as dynamic)
//                                           .docs![index]['admin'])),
//                                   title: Text(
//                                     getName((snapshot.data as dynamic)
//                                         .docs![index]['CommunityName']),
//                                     style: const TextStyle(
//                                       color: blackColor,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 );
//                               }),
//                             );
//                           },
//                         )