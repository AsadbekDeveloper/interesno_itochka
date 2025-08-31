import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/feed/presentation/pages/video_feed_page.dart';
import 'features/feed/presentation/bloc/video_feed_bloc.dart';
import 'features/feed/data/repositories/video_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoFeedBloc>(
          create: (context) => VideoFeedBloc(videoService: VideoRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Video Feed',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: const VideoFeedPage(),
      ),
    );
  }
}
