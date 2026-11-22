import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../auth/auth_service.dart';

class _FeedVideo {
  const _FeedVideo({
    required this.url,
    required this.creator,
    required this.description,
    required this.likes,
    required this.pexelsUrl,
  });

  final String url;
  final String creator;
  final String description;
  final int likes;
  final String pexelsUrl;
}

const _videos = [
  _FeedVideo(
    url: 'https://videos.pexels.com/video-files/6292467/6292467-uhd_2160_4096_25fps.mp4',
    creator: 'luzdeciudad',
    description: 'Un minuto para mirar hacia arriba. ☁️',
    likes: 1842,
    pexelsUrl: 'https://www.pexels.com/download/video/6292467/',
  ),
  _FeedVideo(
    url: 'https://videos.pexels.com/video-files/7273908/7273908-uhd_2160_4096_25fps.mp4',
    creator: 'pausa.creativa',
    description: 'Respira, vuelve al presente y sigue. ✨',
    likes: 926,
    pexelsUrl: 'https://www.pexels.com/download/video/7273908/',
  ),
  _FeedVideo(
    url: 'https://videos.pexels.com/video-files/12902487/12902487-hd_1080_1920_30fps.mp4',
    creator: 'momentosvisual',
    description: 'Pequeños detalles, grandes historias.',
    likes: 3210,
    pexelsUrl: 'https://www.pexels.com/download/video/12902487/',
  ),
  _FeedVideo(
    url: 'https://videos.pexels.com/video-files/7583538/7583538-hd_1080_1920_25fps.mp4',
    creator: 'sabores.del.dia',
    description: 'El arte también se encuentra en lo cotidiano. 🥖',
    likes: 1476,
    pexelsUrl: 'https://www.pexels.com/download/video/7583538/',
  ),
];

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _authService = AuthService();
  int _currentPage = 0;
  final Set<int> _likedVideos = {};
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    try {
      await _authService.signOut();
      if (mounted) context.go('/login');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Bad state: ', '')),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  void _showComments() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF191923),
      showDragHandle: true,
      builder: (context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comentarios',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text(
                'La conversación de este video estará disponible próximamente.',
                style: TextStyle(color: Color(0xFFB8B8C5)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareVideo(_FeedVideo video) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Video de Pexels: ${video.pexelsUrl}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final accountName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : user?.email ?? 'Mi cuenta';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _VideoPage(
                key: ValueKey(_videos[index].url),
                video: _videos[index],
                isActive: index == _currentPage,
                isLiked: _likedVideos.contains(index),
                onLike: () => setState(() {
                  if (!_likedVideos.add(index)) _likedVideos.remove(index);
                }),
                onComments: _showComments,
                onShare: () => _shareVideo(_videos[index]),
              );
            },
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 135,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x80000000), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Row(
                  children: [
                    const Text(
                      'REELUP',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 210),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: TextButton.icon(
                        onPressed: _isSigningOut ? null : _signOut,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: const Size(0, 40),
                        ),
                        icon: _isSigningOut
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.logout_rounded, size: 18),
                        label: Flexible(
                          child: Text(
                            accountName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPage extends StatefulWidget {
  const _VideoPage({
    super.key,
    required this.video,
    required this.isActive,
    required this.isLiked,
    required this.onLike,
    required this.onComments,
    required this.onShare,
  });

  final _FeedVideo video;
  final bool isActive;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComments;
  final VoidCallback onShare;

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  late final VideoPlayerController _controller;
  bool _isReady = false;
  bool _isPlaying = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.url));
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      if (!mounted) return;
      setState(() => _isReady = true);
      await _syncPlayback();
    } catch (error) {
      if (mounted) {
        setState(() => _loadError = 'No se pudo cargar este video: $error');
      }
    }
  }

  @override
  void didUpdateWidget(covariant _VideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) _syncPlayback();
  }

  Future<void> _syncPlayback() async {
    if (!_isReady || !_controller.value.isInitialized) return;
    try {
      if (widget.isActive) {
        await _controller.play();
        if (mounted) setState(() => _isPlaying = true);
      } else {
        await _controller.pause();
        if (mounted) setState(() => _isPlaying = false);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _loadError = 'No se pudo reproducir este video: $error');
      }
    }
  }

  Future<void> _togglePlayback() async {
    if (!_isReady) return;
    try {
      if (_controller.value.isPlaying) {
        await _controller.pause();
      } else {
        await _controller.play();
      }
      if (mounted) {
        setState(() => _isPlaying = _controller.value.isPlaying);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _loadError = 'No se pudo controlar el video: $error');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayback,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF181820)),
          if (_isReady)
            Center(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            )
          else if (_loadError == null)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF3D70)),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 330,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                    stops: [0.0, 0.92],
                  ),
                ),
              ),
            ),
          ),
          if (_isReady && !_isPlaying)
            const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0x55000000),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.play_arrow_rounded, size: 48),
                ),
              ),
            ),
          Positioned(
            left: 20,
            right: 90,
            bottom: 38,
            child: _VideoCaption(video: widget.video),
          ),
          Positioned(
            right: 14,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _VideoAction(
                  icon: widget.isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: _formatCount(
                    widget.video.likes + (widget.isLiked ? 1 : 0),
                  ),
                  color: widget.isLiked
                      ? const Color(0xFFFF4778)
                      : Colors.white,
                  onPressed: widget.onLike,
                ),
                const SizedBox(height: 22),
                _VideoAction(
                  icon: Icons.mode_comment_outlined,
                  label: 'Comentar',
                  onPressed: widget.onComments,
                ),
                const SizedBox(height: 22),
                _VideoAction(
                  icon: Icons.share_outlined,
                  label: 'Compartir',
                  onPressed: widget.onShare,
                ),
                const SizedBox(height: 18),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.white70, width: 1.5),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF3D70), Color(0xFFFF8B52)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.music_note_rounded, size: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoCaption extends StatelessWidget {
  const _VideoCaption({required this.video});

  final _FeedVideo video;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '@${video.creator}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            shadows: [Shadow(blurRadius: 8, color: Colors.black87)],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          video.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            height: 1.35,
            shadows: [Shadow(blurRadius: 8, color: Colors.black87)],
          ),
        ),
        const SizedBox(height: 11),
        Row(
          children: [
            const Icon(Icons.music_note_rounded, size: 15),
            const SizedBox(width: 4),
            const Expanded(
              child: Text(
                'Audio original · Pexels',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Video de Pexels: ${video.pexelsUrl}')),
              ),
              child: const Text(
                'Ver fuente',
                style: TextStyle(
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VideoAction extends StatelessWidget {
  const _VideoAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = Colors.white,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 31, color: color),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 48, height: 42),
            visualDensity: VisualDensity.compact,
            tooltip: label,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

String _formatCount(int count) {
  if (count < 1000) return '$count';
  return '${(count / 1000).toStringAsFixed(count >= 10000 ? 0 : 1)} mil';
}
