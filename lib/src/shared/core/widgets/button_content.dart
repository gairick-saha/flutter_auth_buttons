// Copyright (c) 2021 Talat El Beick. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:auth_buttons/src/shared/auth_button_style.dart';
import 'package:auth_buttons/src/shared/core/widgets/auth_icon.dart';
import 'package:auth_buttons/src/utils/auth_type.dart';
import 'package:flutter/material.dart';

/// The common [AuthButton]s body structures.
///
/// This Widget describes how others widget will be display.
class ButtonContent extends StatefulWidget {
  const ButtonContent({
    super.key,
    this.text,
    required this.authIcon,
    this.textDirection = TextDirection.ltr,
    this.isLoading = false,
    required this.style,
  });

  /// {@macro text}
  final String? text;

  /// {@macro authIcon}
  final AuthIcon authIcon;

  /// {@macro textDirection}
  final TextDirection textDirection;

  /// {@macro isLoading}
  final bool isLoading;

  /// {@macro style}
  final AuthButtonStyle style;

  @override
  State<ButtonContent> createState() => _ButtonContentState();
}

class _ButtonContentState extends State<ButtonContent> {
  final GlobalKey _textKey = GlobalKey();
  double? _textWidth;

  @override
  void initState() {
    super.initState();
    if (widget.style.buttonType != AuthButtonType.icon) {
      WidgetsBinding.instance.addPostFrameCallback((_) => getTextWidgetWidth());
    }
  }

  @override
  Widget build(BuildContext context) {
    final indicatorType =
        widget.style.progressIndicatorType ?? AuthIndicatorType.circular;
    return Row(
      key: widget.key,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: widget.textDirection,
      children: <Widget>[
        Container(
          padding: (widget.style.buttonType == AuthButtonType.secondary)
              ? const EdgeInsets.all(5.0)
              : null,
          decoration: BoxDecoration(
            color: widget.style.iconBackground,
            borderRadius: BorderRadius.circular(
              widget.style.borderRadius ?? 0.0,
            ),
          ),
          child: widget.isLoading &&
                  (widget.style.buttonType == AuthButtonType.icon ||
                      indicatorType == AuthIndicatorType.circular)
              ? _buildCircularProgressIndicator()
              : widget.authIcon,
        ),
        if (widget.style.buttonType != AuthButtonType.icon) ...[
          SizedBox(width: widget.style.separator),
          if (widget.isLoading &&
              widget.style.buttonType != AuthButtonType.icon &&
              indicatorType == AuthIndicatorType.linear)
            _buildLinearProgressIndicator()
          else if (widget.text != null)
            Text(key: _textKey, widget.text!)
        ]
      ],
    );
  }

  void getTextWidgetWidth() {
    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    _textWidth = renderBox?.size.width;
  }

  Widget _buildCircularProgressIndicator() {
    return SizedBox(
      width: widget.style.iconSize,
      height: widget.style.iconSize,
      child: CircularProgressIndicator.adaptive(
        backgroundColor: widget.style.progressIndicatorColor,
        strokeWidth: widget.style.progressIndicatorStrokeWidth ?? 4.0,
        valueColor: AlwaysStoppedAnimation<Color?>(
          widget.style.progressIndicatorValueColor,
        ),
        value: widget.style.progressIndicatorValue,
      ),
    );
  }

  Widget _buildLinearProgressIndicator() {
    return Flexible(
      child: SizedBox(
        width: _textWidth,
        child: LinearProgressIndicator(
          backgroundColor: widget.style.progressIndicatorColor,
          minHeight: widget.style.progressIndicatorStrokeWidth ?? 4.0,
          value: widget.style.progressIndicatorValue,
          valueColor: AlwaysStoppedAnimation<Color?>(
            widget.style.progressIndicatorValueColor,
          ),
        ),
      ),
    );
  }
}
