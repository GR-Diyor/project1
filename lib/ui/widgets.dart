import 'package:flutter/material.dart';

import 'theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? lineColor;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const AppCard({
    required this.child,
    this.color,
    this.lineColor,
    this.padding = const EdgeInsets.all(20),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppTheme.card,
        border: Border(
          bottom: BorderSide(color: lineColor ?? AppTheme.line, width: 1),
        ),
      ),
      child: child,
    );
  }
}

class PatternBackground extends StatelessWidget {
  final Widget child;
  const PatternBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bg,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: CustomPaint(painter: _DotPainter()),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  static const double spacing = 22;
  final Paint _paint = Paint()..color = AppTheme.line;

  @override
  void paint(Canvas canvas, Size size) {
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;
    for (var x = 0; x < cols; x++) {
      for (var y = 0; y < rows; y++) {
        canvas.drawRect(
          Rect.fromLTWH(x * spacing, y * spacing, 2, 2),
          _paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppButton extends StatefulWidget {
  final String text;
  final Color normalColor;
  final Color hoverColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double height;
  final double? width;
  final double fontSize;
  final FontWeight fontWeight;

  const AppButton({
    required this.text,
    required this.normalColor,
    required this.hoverColor,
    required this.textColor,
    this.onPressed,
    this.height = 44,
    this.width,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: Opacity(
        opacity: widget.onPressed == null ? 0.5 : 1,
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          color: _pressed ? widget.hoverColor : widget.normalColor,
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: AppTheme.font(
              size: widget.fontSize,
              color: widget.textColor,
              weight: widget.fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class AppTextInput extends StatefulWidget {
  final String placeholder;
  final TextEditingController controller;
  final double height;
  final TextInputType? keyboardType;
  final int maxLength;

  const AppTextInput({
    required this.placeholder,
    required this.controller,
    this.height = 45,
    this.keyboardType,
    this.maxLength = 64,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: focused ? AppTheme.soft : Colors.white,
        border: Border.all(color: AppTheme.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        style: AppTheme.font(size: 14, color: AppTheme.text),
        decoration: InputDecoration(
          isDense: true,
          counterText: '',
          border: InputBorder.none,
          hintText: widget.placeholder,
          hintStyle: AppTheme.font(size: 14, color: const Color(0xFF9C9C9C)),
        ),
      ),
    );
  }
}

class AppSelectBox extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final double height;

  const AppSelectBox({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    final safe = options.contains(selected) ? selected : (options.isNotEmpty ? options.first : '');
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.line),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safe.isEmpty ? null : safe,
          isExpanded: true,
          icon: Text('▼', style: AppTheme.font(size: 10, color: AppTheme.muted)),
          style: AppTheme.font(size: 14, color: AppTheme.text),
          dropdownColor: Colors.white,
          items: options
              .map(
                (o) => DropdownMenuItem(
                  value: o,
                  child: Text(
                    o,
                    style: AppTheme.font(size: 14, color: AppTheme.text),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? fillColor;
  final Color? bgColor;

  const AppProgressBar({
    required this.value,
    this.height = 10,
    this.fillColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (ctx, c) {
        final fill = (c.maxWidth * v).clamp(1.0, c.maxWidth);
        return Container(
          height: height,
          color: bgColor ?? const Color(0xFFEEE8DC),
          alignment: Alignment.centerLeft,
          child: Container(
            width: fill,
            height: height,
            color: fillColor ?? AppTheme.gold,
          ),
        );
      },
    );
  }
}

class PageTitle extends StatelessWidget {
  final String small;
  final String big;
  const PageTitle({required this.small, required this.big});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          small.toUpperCase(),
          style: AppTheme.font(
            size: 12,
            color: AppTheme.gold,
            weight: FontWeight.w700,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          big,
          style: AppTheme.font(size: 32, color: AppTheme.green, style: 'elegant'),
        ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  final double letterSpacing;
  const SectionLabel({required this.text, this.color = AppTheme.green, this.letterSpacing = 2});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTheme.font(
        size: 12,
        color: color,
        weight: FontWeight.w700,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

class AvatarSquare extends StatelessWidget {
  final String letter;
  final double size;
  final Color color;
  final double fontSize;
  const AvatarSquare({
    required this.letter,
    this.size = 36,
    this.color = AppTheme.gold,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: color,
      alignment: Alignment.center,
      child: Text(
        letter,
        style: AppTheme.font(size: fontSize, color: AppTheme.text, weight: FontWeight.w700),
      ),
    );
  }
}
