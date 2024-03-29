import 'dart:convert';

import 'package:cookingApp/recipemodel.dart';
import 'package:cookingApp/recipeview.dart';
import 'package:cookingApp/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'dart:developer';
class Search extends StatefulWidget {
  String query;
  Search(this.query);

  @override
  State<Search> createState() => _HomeState();
}

class _HomeState extends State<Search> {
  bool isloading=true;
  List<Recipemodel1>recipelist=<Recipemodel1>[];
  TextEditingController searchcontroller=TextEditingController();
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
    print(getRecipe(widget.query));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.height*2.2,
            height: MediaQuery.of(context).size.width*2.2,
            color: Colors.pink.shade100,
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
                            onTap: ()async{
                              print("search text ${searchcontroller.text}");
                              if(searchcontroller.text.isEmpty){
                                print("Blank search");
                              }
                              else{
                              await  Navigator.push(context,  MaterialPageRoute(builder: (context)=>Search(searchcontroller.text)));
                                searchcontroller.text="";
                              }
                            },
                            child: Icon(Icons.search)),margin: EdgeInsets.symmetric(horizontal: 10),),
                        Expanded(
                          child: TextField(
                            controller: searchcontroller,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value){
                              if(searchcontroller.text.isEmpty){
                                print("Blank search");
                              }
                              else{
                                 Navigator.push(context,  MaterialPageRoute(builder: (context)=>Search(searchcontroller.text))).
                                 then((value) =>{
                                   setState(() {
                                     searchcontroller.text="";
                                   })
                                 });

                              }

                            },
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
                                        height: 270,
                                      ),
                                    ),
                                    Positioned(
                                        left: 10,
                                        bottom: 5,
                                        right: 0,
                                        child: Container(
                                            child: Text(recipelist[index].applabel,style: TextStyle(fontSize: 23,color: Colors.white),))),
                                    Positioned(
                                        right: 10,
                                        child: Container(
                                            child: Row(
                                              children: [
                                                Icon(Icons.local_fire_department,color: Colors.pink.shade300,),
                                                Text(recipelist[index].appcalories.toString().substring(0,5),style: TextStyle(fontSize: 24,color: Colors.pink.shade300,fontWeight: FontWeight.bold),),
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