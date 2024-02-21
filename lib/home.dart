import 'dart:convert';
import 'dart:developer';
import 'package:cookinapp/recipemodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<recipesmodel1>Recipelist = <recipesmodel1>[];
  TextEditingController searchcontrollr = new TextEditingController();
  getrecipes(String query) async
  {
    String url = "https://api.edamam.com/search?q=$query&app_id=b77ed183&app_key=6b2804d3da57f7b303dd69f883a20b11";
    Response respones = await get(Uri.parse(url));
    Map data = jsonDecode(respones.body);
    // log(data.toString());
    data["hits"].forEach((element) {
      recipesmodel1 Recipesmodel1 = new recipesmodel1();
      Recipesmodel1 = recipesmodel1.fromMap(element["recipe"]);
      Recipelist.add(Recipesmodel1);
      log(Recipelist.toString());
    });
    Recipelist.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    });

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
          children: [
            Container(
               height: MediaQuery.of(context).size.width,
               width:  MediaQuery.of(context).size.height,
              color: Colors.cyan,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Container(

                      padding: EdgeInsets.symmetric(horizontal: 8),
                      margin: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                print("Search Text: ${searchcontrollr.text}");
                                if (searchcontrollr.text.isEmpty) {
                                  print("Blank Search");
                                }
                                else {
                                  getrecipes(searchcontrollr.text);
                                }
                              },
                              child: Container(child: Icon(Icons.search),
                                  margin: EdgeInsets.fromLTRB(2, 0, 7, 0))),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Seach any city name",
                                  border: InputBorder.none
                              ),
                              controller: searchcontrollr,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      // padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WHAT DO YOU WANT TO COOK TODAY?", style: TextStyle(
                              fontSize: 33,
                              color: Colors.white
                          ),),
                          SizedBox(
                            height: 10,
                          ),
                          Text("LET'S COOK SOMETHING NEW", style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),),
                        ],
                      )
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Recipelist.length,
                        itemBuilder: (context,index){
                          return Container(
                            child: InkWell(
                              onTap: (){},
                              child: Card(
                                margin: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(Recipelist[index].appimgUrl,
                                      fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 250,
                                      ),),
                                    Positioned(
                                      left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child:Container(
                                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.black26
                                            ),
                                            child: Text(Recipelist[0].applabel,style: TextStyle(color: Colors.white),)) ),
                                    Positioned(
                                        //left: 0,
                                        //bottom: 0,
                                        right: 0,
                                            child: Text(Recipelist[0].appcalories.toString().substring(0,6) )
                                ),
                              ]),
                            ),
                            ));

                        }),
                  )
                ],
              ),
            ),

          ]),
    );
  }
}