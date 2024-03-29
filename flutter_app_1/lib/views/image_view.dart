import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {


  @override
  Widget build(BuildContext context) {
    String downloadMessage = "Downloading...";
    // var percentage = 0.0;

    return Scaffold(
      body: Stack(children: [
        Hero(
          tag: widget.imgUrl,
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.imgUrl, fit: BoxFit.cover,)),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Image will be saved in gallery"),
                      content: Container(
                        child: Text(downloadMessage),
                      )
                    ),
                  );
                  //
                  if(Platform.isAndroid){
                    await _askPermission();
                  }
                  var response = await Dio().get(
                    widget.imgUrl,
                    options: Options(responseType: ResponseType.bytes),
                    onReceiveProgress: (actualbytes, totalbytes){
                      var percentage = actualbytes/totalbytes * 100;
                      setState(() {
                        downloadMessage = 'Downloading...${percentage.floor()} %';
                      });
                    }
                  );
                  final result =
                      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
                  print(result);
                  Navigator.pop(context);
                  //

                  // showDialog(
                  //     context: context,
                  //     builder: (context) => AlertDialog(
                  //       title: Text("Alert test"),
                  //       content: Text(downloadMessage ?? ''),
                  //       //
                  //
                  //
                  //
                  //       //
                  //       // actions: [
                  //       //   TextButton(onPressed: () {
                  //       //     _save();
                  //       //   }, child: Text("Yes")),
                  //       //   TextButton(onPressed: () {
                  //       //     Navigator.pop(context);
                  //       //   }, child: Text("No")),
                  //       // ],
                  //     ),
                  // );
                  // _save();
                },
                child: Stack(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff1C1B1B).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: MediaQuery.of(context).size.width/2,

                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              colors: [
                                Color(0x36FFFFFF),
                                Color(0x0FFFFFFF)
                              ]
                          )
                      ),
                      child: Column(children: [
                        Text("Set Wallpaper", style: TextStyle(
                            fontSize: 16, color: Colors.white70),),
                        Text("Image will be saved in gallery", style: TextStyle(
                            fontSize: 10, color: Colors.white70),)
                      ],),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.white),)
            ),
              SizedBox(height: 50,),
          ],),
        )
      ],),
    );
  }

  _save() async {

    String downloadMessage = "Downloading...";

    if(Platform.isAndroid){
      await _askPermission();
    }
    var response = await Dio().get(
        widget.imgUrl,
        options: Options(responseType: ResponseType.bytes),
        // onReceiveProgress: (actualbytes, totalbytes){
        //   setState(() {
        //     downloadMessage = actualbytes.toString();
        //   });
        // }
    );
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */await PermissionHandler()
          .requestPermissions([PermissionGroup.photos]);
    } else {
      /* PermissionStatus permission = */await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}
