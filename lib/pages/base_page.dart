import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:uicons/uicons.dart';

import '../constants.dart';
import '../widgets/custom_nav_item.dart';
import 'home_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slide;
  late AnimationController _animationController;
  int _selectedIndex = 0;

  void _switchNavPage(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final pages = [
    const HomePage(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: kDefaultAnimationDuration);

    _slide = Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
        .animate(_animationController);

    Future.delayed(kDefaultAnimationDuration * 2, () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[_selectedIndex],
      bottomNavigationBar: CustomSlideYAnimation(
        begin: 1,
        delayDuration: kDefaultAnimationDuration * 2,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 35),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomNavItem(
                      icon: UIcons.solidRounded.home,
                      index: 0,
                      selectedIndex: _selectedIndex,
                      onTap: _switchNavPage,
                    ),
                    CustomNavItem(
                      icon: UIcons.solidRounded.bell,
                      index: 1,
                      selectedIndex: _selectedIndex,
                      onTap: _switchNavPage,
                    ),
                    const CenterNavButton(),
                    CustomNavItem(
                      icon: UIcons.solidRounded.comment_alt,
                      index: 2,
                      selectedIndex: _selectedIndex,
                      onTap: _switchNavPage,
                    ),
                    CustomNavItem(
                      icon: UIcons.regularRounded.user,
                      index: 3,
                      selectedIndex: _selectedIndex,
                      onTap: _switchNavPage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSlideYAnimation extends StatefulWidget {
  const CustomSlideYAnimation({
    super.key,
    this.curve,
    required this.child,
    this.delayDuration,
    this.animationDuration,
    this.begin,
  });

  final Widget child;
  final Duration? delayDuration;
  final Duration? animationDuration;
  final Curve? curve;
  final double? begin;

  @override
  State<CustomSlideYAnimation> createState() => _CustomSlideYAnimationState();
}

class _CustomSlideYAnimationState extends State<CustomSlideYAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slide;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: widget.animationDuration ?? kDefaultAnimationDuration);

    _slide =
        Tween(begin: Offset(0, widget.begin ?? -1), end: const Offset(0, 0))
            .animate(
      widget.curve == null
          ? _animationController
          : CurvedAnimation(
              parent: _animationController,
              curve: widget.curve!,
            ),
    );

    Future.delayed(widget.delayDuration ?? Duration.zero, () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _slide, child: widget.child);
  }
}

class CenterNavButton extends StatefulWidget {
  const CenterNavButton({
    super.key,
  });

  @override
  State<CenterNavButton> createState() => _CenterNavButtonState();
}

class _CenterNavButtonState extends State<CenterNavButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _scaleTransition;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _scaleTransition = Tween(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const ElasticOutCurve(1),
      ),
    );

    Future.delayed(kDefaultAnimationDuration * 3, () {
      _animationController.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleTransition,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Icon(
          UIcons.regularStraight.plus,
          color: Theme.of(context).primaryColor,
          size: 16,
        ),
      ),
    );
  }
}
