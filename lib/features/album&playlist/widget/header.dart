import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: NetworkImage('https://5sfashion.vn/storage/upload/images/ckeditor/4KG2VgKFDJWqdtg4UMRqk5CnkJVoCpe5QMd20Pf7.jpg'),)
            ),
          ),
          const SizedBox(height: 24),
          customText('Mtp', 32, FontWeight.bold),
          const SizedBox(height: 8),
          customText('CustomText', 24, FontWeight.normal),
          const SizedBox(height: 8),
          customText('album • 2017', 16, FontWeight.normal),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_circle_down_outlined, size: 32, color: Colors.white)),
                  customText('Tải về', 20, FontWeight.normal),
                ],
              ),
              SizedBox(width: 32),
              TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      backgroundColor: Colors.deepPurple
                  ),
                  onPressed: (){},
                  child:customText('PHÁT NGẪU NHIÊN', 24, FontWeight.normal)),
              SizedBox(width: 32),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.favorite_outline, size: 32, color: Colors.white)),
                  customText('Yêu thích', 20, FontWeight.normal),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget customText(String text, double? size, FontWeight? fontWeight){
    size ??= 16;
    fontWeight ??= FontWeight.normal;
    return Text(text,
      style: TextStyle(
        fontSize: size,
        color: Colors.white,
        fontWeight: fontWeight,
      ),
    );
  }
}