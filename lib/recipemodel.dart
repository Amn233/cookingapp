class Recipemodel1{

  late String applabel;
  late double appcalories;
  late String appurl;
  late String appimgurl;
  Recipemodel1({
    this.applabel="label",this.appcalories=0.0000,this.appimgurl="img",this.appurl="url"
  });
  factory Recipemodel1.fromMap(Map recipe){
    return Recipemodel1(
        applabel: recipe["label"],
        appcalories: recipe["calories"],
        appimgurl: recipe["image"],
        appurl: recipe["url"]

    );
  }
}