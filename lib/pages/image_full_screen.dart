import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:itsoltest/constants/string_constants.dart';

class ImageFullScreen extends StatefulWidget {
  ImageFullScreen({super.key, required this.networkImageUrl});

  String networkImageUrl;

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  double deviceHeight = 00;
  double deviceWidth = 00;
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.REQUIRED_FULL_SCREEN_IMAGE),
      ),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Image.network(
          widget.networkImageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
