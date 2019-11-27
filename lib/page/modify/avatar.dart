import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../../tools/base64.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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
  var baseImg;
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
            ),
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
    //  生成图片实体
    final img.Image image = img.decodeImage(File(_imgPath.path).readAsBytesSync());
    //  缓存文件夹
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path; // 临时文件夹
    //  创建文件
    final File imageFile = File(path.join(tempPath, 'dart.png')); // 保存在应用文件夹内
    await imageFile.writeAsBytes(img.encodePng(image)); 
    print(await Util.imageFile2Base64(imageFile));
  }  

  void pickImg(String action) async{
    setState(() {
      _imgPath = null;
      showCircle = true;
    });
    File image = await (action == 'gallery' ? ImagePicker.pickImage(source: ImageSource.gallery) : ImagePicker.pickImage(source: ImageSource.camera));
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