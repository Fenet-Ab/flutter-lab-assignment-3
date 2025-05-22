import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_album/core/router/app_router.dart';
import 'package:flutter_album/data/repositories/album_repository.dart';
import 'package:flutter_album/domain/blocs/album_bloc.dart';

void main() {
  print('App starting...');
  runApp(const MyApp());
  print('runApp called.');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building MyApp...');
    return RepositoryProvider(
      create: (context) => AlbumRepository(),
      child: BlocProvider(
        create: (context) => AlbumBloc(
          albumRepository: context.read<AlbumRepository>(),
        ),
        child: MaterialApp.router(
          title: 'Photo Albums',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            useMaterial3: true,
          ),
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}