import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_devscore/model/user_model.dart';
import 'package:project_devscore/providers/userdata_provider.dart';
import 'package:project_devscore/screens/comment_screen.dart';
import 'package:project_devscore/services/firestore_methods.dart';
import 'package:project_devscore/utils/colors.dart';
import 'package:project_devscore/utils/global_variables.dart';
import 'package:project_devscore/widgets/like_animation.dart';
import 'package:project_devscore/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int noOfComments = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postID'])
          .collection('comments')
          .get();
      noOfComments = snap.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user =
        Provider.of<UserDataProvider>(context, listen: false).getUserData;
    final width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: width > webScreenSize ? secondaryColor : Colors.white,
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Column(
          children: [
            // header
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0)
                      .copyWith(
                right: 0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(widget.snap['profImage']),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (user.uid == widget.snap['uid'])
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: ListView(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                      onTap: () async {
                                        FireStoreMethods()
                                            .deletePost(widget.snap['postID']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                          horizontal: 16.0,
                                        ),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: blackColor,
                      ),
                    ),
                ],
              ),
              // post
            ),
            GestureDetector(
              onDoubleTap: () async {
                await FireStoreMethods().likePost(
                  widget.snap['postID'],
                  user.uid,
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['photoUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      isAnimation: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 120,
                      )),
                )
              ]),
            ),
            // like comment
            Row(
              children: [
                LikeAnimation(
                  isAnimation: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      await FireStoreMethods().likePost(
                        widget.snap['postID'],
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => CommentScreen(
                              snap: widget.snap,
                            )),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.comment_outlined,
                  ),
                ),
              ],
            ),
            // description and no of comments and likes
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                    child: Text(
                      // in firestore likes are in array get length of the array and then convert it into text/string
                      "${widget.snap['likes'].length} likes",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: blackColor,
                        ),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "  ${widget.snap['description']}",
                            style: const TextStyle(color: blackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 1.0,
                      ),
                      child: Text(
                        // our comments will be in a sub collection so we cant show total numbers directly
                        'View all $noOfComments comments',
                        style: const TextStyle(
                          color: secondaryColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  // time and date
                  Container(
                    child: Text(
                      // this one is in timestamp so will use intl package
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
