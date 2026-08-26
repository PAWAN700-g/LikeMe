import 'package:video_player/video_player.dart';

VideoPlayerController controllerForVideo(String path) =>
    VideoPlayerController.networkUrl(Uri.parse(path));
