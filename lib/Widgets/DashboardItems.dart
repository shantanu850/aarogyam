import 'package:flutter/material.dart';
class DashboardItems extends StatelessWidget {
  final String backgroundImage;
  final bool isImage;
  final Color color;
  final double borderRadious;
  final String text;
  final Widget icon;
  final bool isIcon;
  final bool isCustomText;
  final Widget customText;
  final Function onTap;
  const DashboardItems({Key key, this.backgroundImage, this.color, this.borderRadious, this.text, this.icon, this.isIcon=false, this.onTap, this.isImage = true, this.isCustomText = false, this.customText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadious))
        ),
        child: Stack(
          children: [
            (isImage)?Container(
              width:width*0.5,
              height: 150,
              decoration:BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadious)),
                  image: DecorationImage(
                      image: AssetImage(backgroundImage),
                      fit: BoxFit.cover
                  )
              ),
            ):Container(),
            Container(
              width:width*0.5,
              height: 150,
              decoration:BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadious)),
                  color: color
              ),
            ),
            Container(
              width:width*0.5,
              height: 150,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (isIcon)?Padding(
                    padding: const EdgeInsets.all(10),
                    child: icon,
                  ):SizedBox(),
                  (!isCustomText)?Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:16),):customText,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
