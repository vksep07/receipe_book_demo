import 'package:flutter/material.dart';

/// Common text widget with predefined styles
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.fontWeight,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style?.copyWith(
            color: color,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ) ??
          TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Display Large Text (32px)
class AppTextDisplayLarge extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppTextDisplayLarge(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Display Medium Text (28px)
class AppTextDisplayMedium extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppTextDisplayMedium(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Heading Text (20px)
class AppTextHeading extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppTextHeading(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Title Text (18px)
class AppTextTitle extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppTextTitle(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Subtitle Text (16px, medium weight)
class AppTextSubtitle extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppTextSubtitle(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Body Text (16px)
class AppTextBody extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppTextBody(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Caption/Small Text (14px)
class AppTextCaption extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppTextCaption(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
