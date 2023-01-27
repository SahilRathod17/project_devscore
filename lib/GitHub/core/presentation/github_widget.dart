import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_devscore/GitHub/core/presentation/routes/app_router.gr.dart';
import 'package:project_devscore/GitHub/github_auth/shared/providers.dart';

final initializationProvider = FutureProvider(((ref) async {
  final AuthNotifier = ref.read(AuthNotifierProvider.notifier);
  await AuthNotifier.checkAndUpdateAuthStatus();
}));

class GitHubWidget extends StatelessWidget {
  GitHubWidget({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
