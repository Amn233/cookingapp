import 'dart:convert';

import 'package:cookinapp/recipemodel.dart';
import 'package:cookinapp/recipeview.dart';
import 'package:cookinapp/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'dart:developer';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isloading=true;
  List<Recipemodel1>recipelist=<Recipemodel1>[];
  TextEditingController searchcontroller=TextEditingController();
  List recipecart=[{"heading":"Chili Food"},{"heading":"Pakistani Food"},{"heading":"Indian Food"},{"heading":"Punjabi Food"},{"heading":"Mango Recipe"},{"heading":"Banana Recipe"},{"heading":"Ice Cream"}];
  getRecipe(String query)async{
    String url="https://api.edamam.com/search?q=$query&app_id=b77ed183&app_key=6b2804d3da57f7b303dd69f883a20b11";
    Response response = await get(Uri.parse(url));
    Map data=jsonDecode(response.body);
    data["hits"].forEach((element){
      Recipemodel1 recipemodel1=new Recipemodel1();
      recipemodel1=Recipemodel1.fromMap(element["recipe"]);
      recipelist.add(recipemodel1);
      setState(() {
        isloading=false;
      });
      log(recipelist.toString());
    });
    recipelist.forEach((recipe) {
      print(recipe.applabel);
      print(recipe.appcalories);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(getRecipe("Apple"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.height*2.2,
            height: MediaQuery.of(context).size.width*2.2,
            color: Colors.pink.shade200,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 27,vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(
                      children: [
                        Container(child: GestureDetector(
                            onTap: (){
                              print("search text ${searchcontroller.text}");
                              if(searchcontroller.text.isEmpty){
                                print("Blank search");
                              }
                              else{
                                Navigator.push(context,  MaterialPageRoute(builder: (context)=>Search(searchcontroller.text)));
                              }
                            },
                            child: Icon(Icons.search)),margin: EdgeInsets.symmetric(horizontal: 10),),
                        Expanded(
                          child: TextField(
                            controller: searchcontroller,
                            decoration: InputDecoration(
                                hintText: "Let's Cook Something New",
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal:20 ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("What Do You Want To Cook Today",style: TextStyle(
                            fontSize: 33,color: Colors.white
                        ),),
                        Text("Let's Cook Something New",style: TextStyle(
                            fontSize: 20,color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                  Container(
                      height: 100,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: recipecart.length,
                          itemBuilder: (context,index){
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Search(recipecart[index]["heading"])));
                              },
                              child: Container(
                                width: 200,
                                height: 250,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade100,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [BoxShadow(
                                    color: Colors.pink,
                                    blurRadius:15,
                                    spreadRadius: 1
                                  )]
                                ),
                                child: Center(child: Text(recipecart[index]["heading"],style: TextStyle(fontSize: 23,color: Colors.pink),)),
                              ),
                            );
                          })
                  ),
                  Container(

                    child: isloading? CircularProgressIndicator(): ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recipelist.length,
                        itemBuilder: (context,index){
                          return Container(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Recipeview(recipelist[index].appurl)));
                              },
                              child:Card(
                                margin: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(recipelist[index].appimgurl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 230,
                                      ),
                                    ),
                                    Positioned(
                                        left: 10,
                                        bottom: 5,
                                        right: 0,
                                        child: Container(
                                            child: Text(recipelist[index].applabel,style: TextStyle(fontSize: 25,color: Colors.white),))),
                                    Positioned(
                                        right: 10,
                                        child: Container(
                                            child: Row(
                                              children: [
                                                Icon(Icons.local_fire_department,color: Colors.pink.shade300,),
                                                Text(recipelist[index].appcalories.toString().substring(0,5),style: TextStyle(fontSize: 24,color: Colors.pink.shade300),),
                                              ],
                                            )))

                                  ],),
                              ) ,
                            ),
                          );

                        }),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}