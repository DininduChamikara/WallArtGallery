import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/data.dart';
import '../model/wallpaper_model.dart';
import '../widgets/widget.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class Search extends StatefulWidget {

  final String searchQuery;
  Search({required this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchController = new TextEditingController();

  List <WallpaperModel> wallpapers = [];

  getSearchWallpapers(String query) async{

    var response = await http.get(Uri.parse("https://api.pexels.com/v1/search?query=$query"),
        headers: {
          "Authorization" : apiKey});

    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["photos"].forEach((element){

      WallpaperModel wallpaperModel;

      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);

    });

    setState(() {

    });

  }

  @override
  void initState() {
    getSearchWallpapers(widget.searchQuery);
    super.initState();
    searchController.text = widget.searchQuery;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: brandName(),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xfff5f8fd),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(children: <Widget> [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "search wallpaper",
                              border: InputBorder.none
                          ),
                        ),
                      ),

                      GestureDetector(

                        // onTap: (){
                        //    getSearchWallpapers(searchController.text);
                        // },
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Search(
                                searchQuery: searchController.text,

                              )
                          ));
                        },

                        child: Container(
                          child: Icon(Icons.search),
                        ) ,
                      )
                    ],),
                  ),
                  SizedBox(
                    height: 16,),
                  wallpapersList(wallpapers: wallpapers, context: context)
                ],),),

          )

      ),
    );

  }
}
