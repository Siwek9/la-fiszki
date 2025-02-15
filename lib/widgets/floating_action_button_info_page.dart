import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FloatingActionButtonInfoPage extends StatefulWidget {
  const FloatingActionButtonInfoPage({
    super.key,
    required this.children,
    this.initialOpen,
    required this.distance,
  });
  final List<Widget> children;
  final double distance;

  final bool? initialOpen;

  @override
  State<StatefulWidget> createState() => _FloatingActionButtonInfoPageState();
}

class _FloatingActionButtonInfoPageState extends State<FloatingActionButtonInfoPage>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_open,
      onPopInvokedWithResult: (didPop, result) {
        setState(() {
          _open = false;
          _controller.reverse();
        });
      },
      child: SizedBox.expand(
        child: GestureDetector(
          behavior: _open ? HitTestBehavior.opaque : HitTestBehavior.translucent,
          onTap: _open
              ? () {
                  setState(() {
                    _open = false;
                    _controller.reverse();
                  });
                }
              : null,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              _buildTapToCloseFab(),
              ..._buildExpandingActionButtons(),
              _buildTapToOpenFab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 96,
      height: 96,
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            shape: StarBorder.polygon(
              sides: 6,
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 10,
              )
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _toggle,
            customBorder: StarBorder.polygon(
              sides: 6,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Icon(
                size: 40,
                Icons.close,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: Container(
            decoration: ShapeDecoration(
              shape: StarBorder.polygon(
                sides: 6,
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 10,
                )
              ],
            ),
            child: FloatingActionButton.large(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              onPressed: _toggle,
              shape: StarBorder.polygon(
                sides: 6,
              ),
              child: Icon(
                size: 50,
                Icons.play_arrow,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    for (int i = 0; i < widget.children.length; i++) {
      children.add(
        StartStudyingActionButton(
          maxDistance: widget.distance * (i + 1) + 10,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}

class StartStudyingActionButton extends StatelessWidget {
  const StartStudyingActionButton({
    super.key,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        return Positioned(
          bottom: progress.value * maxDistance,
          child: Transform.scale(
            scale: progress.value,
            child: child!,
          ),
        );
      },
      child: FadeScaleTransition(
        animation: progress,
        child: child,
      ),
    );
  }
}
