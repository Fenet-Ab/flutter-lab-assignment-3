import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_album/presentation/screens/album_list_screen.dart';
import 'package:flutter_album/presentation/screens/album_detail_screen.dart';
import 'package:flutter_album/presentation/screens/welcome_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/albums',
      builder: (context, state) => const AlbumListScreen(),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        if (id == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Invalid album ID',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
        return AlbumDetailScreen(albumId: id);
      },
    ),
  ],
);
