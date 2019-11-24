import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatefulWidget {
  Avatar({Key key, @required this.handler, @required this.modifyFunc}) 
    : super(key: key);
  final ValueChanged<bool> handler;
  final modifyFunc;

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  var _imgPath;
  bool showCircle = false;
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(child: imageView(context),) ,
        RaisedButton(
          onPressed: () => pickImg('takePhote'),
          child: Text('拍照')
        ),
        RaisedButton(
          onPressed: () => pickImg('gallery'),
          child: Text('选择相册')
        )
      ],
    );
  }

  Widget imageView(BuildContext context) {
    if (_imgPath == null && !showCircle) {
      return Center(
        child: Text('请选择图片或拍照'),
      );
    } else if (_imgPath != null) {
      return Center(
          child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20.0),
              child: Crop(
                key: cropKey,
                image: FileImage(_imgPath),
                aspectRatio: 4.0 / 3.0,
              ),
          )
          // FadeInImage(
          //   placeholder: AssetImage("images/loading.gif"),
          //   image: FileImage(_imgPath),
          //   height: 375,
          //   width: 375,
          // )
      ); 
    } else {
      return Center(
        child: Image.asset("images/loading.gif",
          width: 375.0,
          height: 375,
        )
      );
    }
  }  

  void pickImg(String action) async{
    setState(() {
      _imgPath = null;
      showCircle = true;
    });
    var image = await (action == 'gallery' ? ImagePicker.pickImage(source: ImageSource.gallery) : ImagePicker.pickImage(source: ImageSource.camera));
    setState(() {
      showCircle = false;
      _imgPath = image;
    });
  }
}