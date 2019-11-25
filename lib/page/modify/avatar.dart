import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SingleChildScrollView(child: imageView(context),) ,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: () => pickImg('takePhote'),
              child: Text('拍照')
            ),
            RaisedButton(
              onPressed: () => pickImg('gallery'),
              child: Text('选择相册')
            ),
            RaisedButton(
              onPressed: getBase64,
              child: Text('获取base64')
            )
          ],
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
          child: 
          FadeInImage(
            placeholder: AssetImage("images/loading.gif"),
            image: FileImage(_imgPath),
            height: 375,
            width: 375,
          )
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

  void getBase64() async {
    print(_imgPath.path);
    File file = new File(_imgPath.path);
    List<int> imageBytes = await file.readAsBytes();
    print(base64Encode(imageBytes).toString());
    //return base64Encode(imageBytes);
  }  

  void pickImg(String action) async{
    setState(() {
      _imgPath = null;
      showCircle = true;
    });
    var image = await (action == 'gallery' ? ImagePicker.pickImage(source: ImageSource.gallery) : ImagePicker.pickImage(source: ImageSource.camera));
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY:1),
      compressQuality: 60,
      maxHeight: 100,
      maxWidth: 100,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false
      )
    );
    setState(() {
      showCircle = false;
      _imgPath = croppedFile;
    });
  }
}