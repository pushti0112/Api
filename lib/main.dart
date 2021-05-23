import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restapis_get_post_delete/Provider/user_provider.dart';
import 'package:restapis_get_post_delete/theme.dart';
import 'package:restapis_get_post_delete/view/sign_in.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      home: SignIn(),

    );
  }
}
