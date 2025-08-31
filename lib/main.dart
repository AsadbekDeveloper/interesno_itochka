import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/feed/presentation/pages/video_feed_page.dart';
import 'features/feed/presentation/bloc/video_feed_bloc.dart';
import 'features/feed/data/services/video_service.dart';

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
          create: (context) => VideoFeedBloc(videoService: VideoService()),
        ),
      ],
      child: MaterialApp(
        title: 'Interesno i Tochka',
        debugShowCheckedModeBanner: false,
        home: const VideoFeedPage(),
      ),
    );
  }
}
