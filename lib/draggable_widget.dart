import 'dart:developer' as dev;

import 'package:flutter/material.dart';

/// A widget that can be dragged and dropped.
class DraggableWidget extends StatefulWidget {
  /// Initializes the [DraggableWidget].
  const DraggableWidget({
    required this.parent,
    required this.child,
    this.initialOffset = const Offset(0, 0),
    Key? key,
  }) : super(key: key);

  /// Parent of [DraggableWidget].
  ///
  /// This field must not be null.
  final Widget parent;

  /// Child of [DraggableWidget].
  ///
  /// This field must not be null.
  final Widget child;

  /// Initial offset of [DraggableWidget].
  ///
  /// Default value is [Offset(0, 0)].
  final Offset initialOffset;

  @override
  State<StatefulWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  final GlobalKey _key = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();

  late Offset _offset;
  late Offset _minimumOffset;
  late Offset _maximumOffset;

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _offset = widget.initialOffset;

    WidgetsBinding.instance?.addPostFrameCallback(_setBoundary);
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (BuildContext context) => Stack(
          key: _parentKey,
          children: <Widget>[
            widget.parent,
            Positioned(
              bottom: _offset.dy,
              right: _offset.dx,
              child: Listener(
                onPointerMove: (PointerMoveEvent pointerMoveEvent) {
                  _updatePosition(pointerMoveEvent);

                  setState(() => _isDragging = true);
                },
                onPointerUp: (PointerUpEvent pointerUpEvent) {
                  if (_isDragging) {
                    setState(() => _isDragging = false);
                  }
                },
                child: Container(key: _key, child: widget.child),
              ),
            ),
          ],
        ),
      );

  void _setBoundary(Duration duration) {
    final RenderBox parentRenderBox =
        _parentKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;

    try {
      final Size parentSize = parentRenderBox.size;
      final Size childSize = renderBox.size;

      setState(() {
        _minimumOffset = const Offset(0, 0);

        _maximumOffset = Offset(
          parentSize.width - childSize.width,
          parentSize.height - childSize.height,
        );
      });
    } on Exception catch (e) {
      dev.log('$DraggableWidget exception: $e');
    }
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double newOffsetX = _offset.dx - pointerMoveEvent.delta.dx;
    double newOffsetY = _offset.dy - pointerMoveEvent.delta.dy;

    if (newOffsetX < _minimumOffset.dx) {
      newOffsetX = _minimumOffset.dx;
    } else if (newOffsetX > _maximumOffset.dx) {
      newOffsetX = _maximumOffset.dx;
    }

    if (newOffsetY < _minimumOffset.dy) {
      newOffsetY = _minimumOffset.dy;
    } else if (newOffsetY > _maximumOffset.dy) {
      newOffsetY = _maximumOffset.dy;
    }

    setState(() => _offset = Offset(newOffsetX, newOffsetY));
  }
}
