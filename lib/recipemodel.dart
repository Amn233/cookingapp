class recipesmodel1 {
  late String applabel;
  late String appimgUrl;
  late double appcalories;
  late String appurl;

  recipesmodel1(
      {this.applabel = "LABEL",this.appcalories = 0.000 ,this.appimgUrl = "IMAGE",this.appurl = "URL"});

  factory recipesmodel1.fromMap(Map recipe)

  {
    return recipesmodel1(
        applabel: recipe["label"],
        appcalories: recipe["calories"],
        appimgUrl: recipe["image"],
        appurl: recipe["url"]
    );
  }
}