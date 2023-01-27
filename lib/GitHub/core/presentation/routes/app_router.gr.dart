// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../../../github_auth/presentation/github_link_page.dart' as _i1;
import '../../../starred_repos/presentation/starred_repos_page.dart' as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    GithubLinkRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.GithubLinkPage(),
      );
    },
    StarredReopsRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.starredReopsPage(),
      );
    },
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/link',
          fullMatch: true,
        ),
        _i3.RouteConfig(
          GithubLinkRoute.name,
          path: '/link',
        ),
        _i3.RouteConfig(
          StarredReopsRoute.name,
          path: '/starred',
        ),
      ];
}

/// generated route for
/// [_i1.GithubLinkPage]
class GithubLinkRoute extends _i3.PageRouteInfo<void> {
  const GithubLinkRoute()
      : super(
          GithubLinkRoute.name,
          path: '/link',
        );

  static const String name = 'GithubLinkRoute';
}

/// generated route for
/// [_i2.starredReopsPage]
class StarredReopsRoute extends _i3.PageRouteInfo<void> {
  const StarredReopsRoute()
      : super(
          StarredReopsRoute.name,
          path: '/starred',
        );

  static const String name = 'StarredReopsRoute';
}
