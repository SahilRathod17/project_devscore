import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_devscore/GitHub/core/presentation/github_widget.dart';
import 'package:project_devscore/screens/community_screen.dart';
import 'package:project_devscore/screens/home_screen.dart';

import 'package:project_devscore/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  HomeScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  SearchScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  ProviderScope(child: GitHubWidget()),
  CommunityScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
    showBackOption: false,
  ),
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  // ),
];
