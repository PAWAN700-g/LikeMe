import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Reel {
  const Reel({
    required this.id,
    required this.videoUrl,
    required this.modelName,
    required this.handle,
    required this.caption,
    required this.likes,
    required this.likedByViewer,
  });
  final String id, videoUrl, modelName, handle, caption;
  final int likes;
  final bool likedByViewer;
  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
    id: json['id'] as String,
    videoUrl: json['videoUrl'] as String,
    modelName: json['modelName'] as String,
    handle: json['handle'] as String,
    caption: json['caption'] as String,
    likes: json['likes'] as int,
    likedByViewer: json['likedByViewer'] as bool? ?? false,
  );
  Reel copyWith({int? likes, bool? likedByViewer}) => Reel(
    id: id,
    videoUrl: videoUrl,
    modelName: modelName,
    handle: handle,
    caption: caption,
    likes: likes ?? this.likes,
    likedByViewer: likedByViewer ?? this.likedByViewer,
  );
}

class ReelStore extends ChangeNotifier {
  ReelStore._();

  static final ReelStore instance = ReelStore._();
  static const _apiUrl = String.fromEnvironment(
    'REELS_API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );
  static const _userId = String.fromEnvironment(
    'APP_USER_ID',
    defaultValue: 'demo-model-ananya',
  );

  List<Reel> _reels = [];

  bool isLoading = false;
  String? error;

  List<Reel> get reels => List.unmodifiable(_reels);

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 500));

    _reels = [
      const Reel(
        id: '1',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        modelName: 'Ananya Sharma',
        handle: '@ananya_sharma',
        caption: 'Fashion shoot ✨ Mumbai',
        likes: 1240,
        likedByViewer: false,
      ),

      const Reel(
        id: '2',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        modelName: 'Priya Singh',
        handle: '@priya_singh',
        caption: 'New collection shoot 📸',
        likes: 890,
        likedByViewer: false,
      ),
    ];

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleLike(int index) async {
    final reel = _reels[index];

    _reels[index] = reel.copyWith(
      likedByViewer: !reel.likedByViewer,
      likes: reel.likes + (reel.likedByViewer ? -1 : 1),
    );

    notifyListeners();
  }

  Future<void> publish(XFile file, String caption) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/api/reels'),
    )
      ..headers['x-user-id'] = _userId
      ..fields['caption'] = caption
      ..files.add(
        http.MultipartFile.fromBytes(
          'video',
          await file.readAsBytes(),
          filename: file.name,
        ),
      );
    final response = await request.send();
    final body = await response.stream.bytesToString();
    if (response.statusCode != 201) {
      throw Exception('Reel upload failed: ${response.statusCode}');
    }
    _reels.insert(0, Reel.fromJson(jsonDecode(body) as Map<String, dynamic>));
    notifyListeners();
  }
}

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key, this.canUpload = false});
  final bool canUpload;
  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  int _activeIndex = 0;
  @override
  void initState() {
    super.initState();
    ReelStore.instance.addListener(_storeUpdated);
    ReelStore.instance.load();
  }

  @override
  void dispose() {
    ReelStore.instance.removeListener(_storeUpdated);
    _pageController.dispose();
    super.dispose();
  }

  void _storeUpdated() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = ReelStore.instance;
    if (store.isLoading && store.reels.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    if (store.error != null && store.reels.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: _EmptyReels(message: store.error!, onRetry: store.load),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: store.reels.length,
            onPageChanged: (index) => setState(() => _activeIndex = index),
            itemBuilder: (_, index) {
              final reel = store.reels[index];
              return _ReelPage(
                key: ValueKey(reel.id),
                reel: reel,
                isActive: index == _activeIndex,
                onLike: () => store.toggleLike(index),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
              child: Row(
                children: [
                  const Text(
                    'Reels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (widget.canUpload)
                    IconButton.filled(
                      onPressed: _pickAndPublish,
                      icon: const Icon(Icons.add),
                      tooltip: 'Upload reel',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndPublish() async {
    final file = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );
    if (!mounted || file == null) return;
    final caption = TextEditingController();
    final publish = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          8,
          24,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Publish reel',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your reel will appear in the LikeMe Reels feed.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caption,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Caption',
                hintText: 'Describe your reel...',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(sheetContext, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B2CBF),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Publish reel'),
              ),
            ),
          ],
        ),
      ),
    );
    if (publish != true) return;
    try {
      await ReelStore.instance.publish(file, caption.text);
      if (!mounted) return;
      await _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your reel is now live.')));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not publish reel. Please try again.'),
          ),
        );
      }
    }
  }
}

class _EmptyReels extends StatelessWidget {
  const _EmptyReels({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.video_collection_outlined,
            color: Colors.white,
            size: 54,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );
}

class _ReelPage extends StatefulWidget {
  const _ReelPage({
    super.key,
    required this.reel,
    required this.isActive,
    required this.onLike,
  });
  final Reel reel;
  final bool isActive;
  final Future<void> Function() onLike;
  @override
  State<_ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<_ReelPage> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.reel.videoUrl),
    );
    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          _controller.setLooping(true);
          if (widget.isActive) _controller.play();
          setState(() => _ready = true);
        })
        .catchError((_) {
          if (mounted) setState(() => _ready = true);
        });
  }

  @override
  void didUpdateWidget(covariant _ReelPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_ready || !_controller.value.isInitialized) return;
    widget.isActive ? _controller.play() : _controller.pause();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      if (_controller.value.isInitialized) {
        _controller.value.isPlaying ? _controller.pause() : _controller.play();
      }
    },
    child: Stack(
      fit: StackFit.expand,
      children: [
        if (_ready && _controller.value.isInitialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          )
        else
          const ColoredBox(
            color: Color(0xFF24142E),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 76,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.reel.handle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.reel.caption,
                style: const TextStyle(color: Colors.white, height: 1.35),
              ),
            ],
          ),
        ),
        Positioned(
          right: 14,
          bottom: 28,
          child: Column(
            children: [
              _ReelAction(
                icon: widget.reel.likedByViewer
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: _formatLikes(widget.reel.likes),
                onTap: widget.onLike,
              ),
              const SizedBox(height: 18),
              const _ReelAction(
                icon: Icons.chat_bubble_outline,
                label: 'Comment',
              ),
              const SizedBox(height: 18),
              const _ReelAction(icon: Icons.share_outlined, label: 'Share'),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ReelAction extends StatelessWidget {
  const _ReelAction({required this.icon, required this.label, this.onTap});
  final IconData icon;
  final String label;
  final Future<void> Function()? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap == null ? null : () => onTap!(),
    borderRadius: BorderRadius.circular(30),
    child: Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    ),
  );
}

String _formatLikes(int likes) => likes >= 1000
    ? '${(likes / 1000).toStringAsFixed(likes % 1000 == 0 ? 0 : 1)}K'
    : '$likes';
