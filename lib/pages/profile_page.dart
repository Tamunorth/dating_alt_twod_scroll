import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uicons/uicons.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user, required this.controller});

  final User user;

  final CachedVideoPlayerController controller;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  final profileDelayDuration = const Duration(milliseconds: 200);
  final profileAnimationDuration = const Duration(milliseconds: 700);
  final profileCurve = Curves.easeInOut;

  bool showControls = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Hero(
            tag: widget.user.videoUrl,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 1.5,
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: CachedVideoPlayer(widget.controller),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.user.imageUrl,
                              width: 80,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '@${widget.user.name.split(' ').first.toLowerCase()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.user.caption,
                                ),
                              ],
                            ),
                          )
                          // StatefulBuilder(builder: (context, setState2) {
                          //   return InkWell(
                          //     onTap: () {
                          //       setState2(() {
                          //         widget.user.liked = !widget.user.liked;
                          //         liked = !liked;
                          //       });
                          //     },
                          //     child: IconSquare(
                          //       size: 12,
                          //       icon: widget.user.liked
                          //           ? Icons.favorite_rounded
                          //           : Icons.favorite_border_rounded,
                          //       color: Colors.white,
                          //     ),
                          //   );
                          // }),
                        ],
                      ),
                    ],
                  ),
                  // ProfileAppBar(user: widget.user),
                  ChatFieldControls(user: widget.user),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatFieldControls extends StatefulWidget {
  const ChatFieldControls({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ChatFieldControls> createState() => _ChatFieldControlsState();
}

class _ChatFieldControlsState extends State<ChatFieldControls>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  late Animation<double> _scale;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: kDefaultAnimationDuration * 2,
    );

    _fade = Tween(begin: -1.0, end: 1.0).animate(_animationController);
    _scale = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _slide = Tween(begin: const Offset(-5, 0), end: const Offset(0, 0))
        .animate(_animationController);

    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final _imageIndex = Random().nextInt(usersList.length);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...List.generate(
              widget.user.tags.length,
              (index) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "#${widget.user.tags[index]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        FadeTransition(
          opacity: _fade,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(
                    usersList[_imageIndex].imageUrl,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'James',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white60,
                          ),
                    ),
                    Text(
                      'Well done',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
        FadeTransition(
          opacity: _fade,
          child: TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              fillColor: Colors.black12,
              filled: true,
              hintText: 'Add comment...',
              hintStyle: const TextStyle(color: Colors.white),
              suffixIcon: SlideTransition(
                position: _slide,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    UIcons.regularRounded.paper_plane,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.all(14),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileAppBar extends StatefulWidget {
  const ProfileAppBar({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar>
    with SingleTickerProviderStateMixin {
  late Animation<double> _rotations;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: kDefaultAnimationDuration,
    );

    _rotations = Tween(begin: 0.5, end: 0.0).animate(_animationController);

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(widget.user.imageUrl),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '428k viewers',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(),
                ),
              ],
            ),
            const SizedBox(width: 10),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                child: Text(
                  'Follow',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            )
          ],
        ),
        RotationTransition(
          turns: _rotations,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              CupertinoIcons.xmark,
            ),
          ),
        ),
      ],
    );
  }
}
