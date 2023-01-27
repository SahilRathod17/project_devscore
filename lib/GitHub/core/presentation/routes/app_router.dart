import 'package:auto_route/annotations.dart';
import 'package:project_devscore/GitHub/github_auth/presentation/github_link_page.dart';
import 'package:project_devscore/GitHub/starred_repos/presentation/starred_repos_page.dart';

@MaterialAutoRouter(
  routes: [
    MaterialRoute(page: GithubLinkPage, initial: true, path: '/link'),
    MaterialRoute(page: starredReopsPage, path: '/starred'),
  ],
  replaceInRouteName: 'Page,Route',
)
class $AppRouter {}
