import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class ViewImage extends StatefulWidget {
  final url;
  const ViewImage({Key key, this.url}) : super(key: key);
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: PhotoView(
          imageProvider: NetworkImage(widget.url),
        )
    );
  }
}
