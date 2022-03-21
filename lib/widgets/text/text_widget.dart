import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final String text;
  TextTitle(this.text,
      {this.textAlign, this.maxLines, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 25,
          color: color != null ? color : null,
          fontWeight: fontWeight != null ? fontWeight : null),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class TextLead extends StatelessWidget {
  final FontWeight? fontWeight;

  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final String text;
  TextLead(this.text,
      {this.textAlign, this.maxLines, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          color: color != null ? color : null,
          fontWeight: fontWeight != null ? fontWeight : null),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class TextNormal extends StatelessWidget {
  final FontWeight? fontWeight;

  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final String text;
  TextNormal(this.text,
      {this.textAlign, this.maxLines, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color != null ? color : null,
          fontWeight: fontWeight != null ? fontWeight : null),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class TextSmall extends StatelessWidget {
  final FontWeight? fontWeight;

  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final String text;
  TextSmall(this.text,
      {this.textAlign, this.maxLines, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 12,
          color: color != null ? color : null,
          fontWeight: fontWeight != null ? fontWeight : null),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
