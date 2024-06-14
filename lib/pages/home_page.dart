import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uicons/uicons.dart';

import '../constants.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int crossAxisCount = 5;

  late ScrollController _scrollCtrl;
  @override
  void initState() {
    super.initState();

    _scrollCtrl = ScrollController(
      initialScrollOffset: 250,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Transform.scale(
        scale: 2,
        child: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: false,
          constrained: false,
          interactionEndFrictionCoefficient: 0.0001,
          clipBehavior: Clip.none,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 2,
            height: MediaQuery.sizeOf(context).height * 7,
            child: MasonryGridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: crossAxisCount,
              controller: _scrollCtrl,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: (index % 2 != 0 && index < 4)
                      ? const EdgeInsets.only(top: 100.0)
                      : EdgeInsets.zero,
                  child: SizedBox(
                    width: 60,
                    height: 220,
                    child: UserGridItem(
                      user: usersList[index],
                    ),
                  ),
                );
              },
              itemCount: usersList.length,
            ),
          ),
        ),
      ),
    );
  }
}

class UserGridItem extends StatefulWidget {
  final User user;

  const UserGridItem({super.key, required this.user});

  @override
  _UserGridItemState createState() => _UserGridItemState();
}

class _UserGridItemState extends State<UserGridItem>
    with AutomaticKeepAliveClientMixin {
  late CachedVideoPlayerController _controller;

  bool liked = false;

  @override
  void initState() {
    super.initState();
    _controller = CachedVideoPlayerController.network(widget.user.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) {
              return ProfilePage(
                user: widget.user,
                controller: _controller,
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: _controller.value.isInitialized
                  ? Hero(
                      tag: widget.user.videoUrl,
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: Colors.black,
                          width: double.infinity,
                          height: 400,
                          alignment: Alignment.center,
                          child: Transform.scale(
                            scale: 1.5,
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: CachedVideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          widget.user.imageUrl,
                          width: 40,
                          height: 50,
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
                                fontSize: 6,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.user.caption,
                              style: const TextStyle(
                                fontSize: 6,
                              ),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...List.generate(
                        widget.user.tags.length,
                        (index) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "#${widget.user.tags[index]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class IconSquare extends StatelessWidget {
  const IconSquare({
    super.key,
    this.onTap,
    required this.icon,
    this.color,
    this.size,
  });

  final Color? color;
  final double? size;
  final VoidCallback? onTap;

  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.black38.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: size ?? 18,
          color: color ?? Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}
