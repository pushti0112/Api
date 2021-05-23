import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:restapis_get_post_delete/Provider/user_provider.dart';
import 'package:restapis_get_post_delete/models/data_model.dart';

class DataService{

  DataModel dataModel;

  Future<List<Data>> getData() async{
    http.Response response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));

    List<Data> users = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['data'] != null) {
        jsonData['data'].forEach((v) {
          users.add(new Data.fromJson(v));
        });
      }
    }

    return users;
  }
  addData(BuildContext context, Data user) async{
    UserProvider userProvider = Provider.of(context, listen: false);
    //dataModel.data.add(Data(firstName: firstName,lastName: lastName,email: email,id: id,avatar: avatar));
    //print(dataModel.data.length);

    http.Response response = await http.post(
      Uri.parse("https://reqres.in/api/users"),
      body: {
        "first_name" : user.firstName,
        "last_name" : user.lastName,
        "email" : user.email,
        'avatar' : user.avatar,
      },
    );
    print(response.body);

    if(response.statusCode == 201) {

      if(user != null) {
        userProvider.users.add(user);
        userProvider.notifyListeners();
      }
    }
    else print("Error in Api");

   // response = await http.post(Uri.parse("https://reqres.in/api/users?page=2"),body: json.encode(dataModel.toJson()));

  }

  deleteData(BuildContext context, Data user) async{
    UserProvider userProvider = Provider.of(context, listen: false);
    //dataModel.data.add(Data(firstName: firstName,lastName: lastName,email: email,id: id,avatar: avatar));
    //print(dataModel.data.length);

    userProvider.users.remove(user);
    userProvider.notifyListeners();

    http.Response response = await http.delete(
      Uri.parse("https://reqres.in/api/users/${user.id}"),
    );
    print(response.body);

    if(response.statusCode != 204) {

      if(user != null) {


      }
    }
    else {
      print("Error in Api");
      userProvider.users.add(user);
      userProvider.notifyListeners();
    }

    // response = await http.post(Uri.parse("https://reqres.in/api/users?page=2"),body: json.encode(dataModel.toJson()));

  }
}