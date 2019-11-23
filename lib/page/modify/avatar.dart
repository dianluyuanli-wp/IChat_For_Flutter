import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
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
  bool showImg = false;
  num showCircle = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(child: imageView(context),) ,
        RaisedButton(
          onPressed: showCar,
          child: Text('拍照')
        ),
        RaisedButton(
          onPressed: show,
          child: Text('选择相册')
        )
      ],
    );
  }

  Widget imageView(BuildContext context) {
    if (_imgPath == null || showCircle == 1) {
      return Center(
        child: Text('请选择图片或拍照'),
      );
    } else if(_imgPath == null || showCircle != 2 ) {
      return Center(
        child: Image.asset("images/loading.gif",
          width: 375.0,
          height: 375,
        )
      );
    } else {
      return Center(
          child: FadeInImage(
            placeholder: AssetImage("images/loading.gif"),
            image: FileImage(_imgPath),
            height: 375,
            width: 375,
          )
      ); 
    }
  }

  void _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      showCircle = 2;
      _imgPath = image;
    });
  }

  void show() {
    setState(() {
      showImg = true;
      showCircle = 1;
    });
    _openGallery();
  }

  void showCar() {
    setState(() {
      showImg = true;
      showCircle = 1;
    });
    _takePhoto();
  }

  Future _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      showCircle = 2;
      _imgPath = image;
    });
  }
}