import 'package:flutter/material.dart';
import 'package:restapis_get_post_delete/constants.dart';
import 'package:restapis_get_post_delete/form_error.dart';
import 'file:///D:/Flutter/restapis_get_post_delete/lib/view/homeScreen.dart';
import 'package:restapis_get_post_delete/size_config.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String email;
  String password;
  bool remember = false;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.04,),
                    Text("Welcome Back",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(28),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Sign in with your email and password \n or continue with social media",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.08,),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildEmailFormField(),
                      SizedBox(height: getProportionateScreenHeight(30),),
                      buildPasswordFormField(),
                      SizedBox(height: getProportionateScreenHeight(30),),

                      FormError(errors: errors),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: kPrimaryColor,
                        height: getProportionateScreenWidth(56),
                        minWidth: double.infinity,
                        onPressed: (){
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            // if all r valid then go to success screen

                            print("success");
                               Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

                          }
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }


  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter your email",
        suffixIcon: Icon(Icons.email),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        else if (value == "a"){
          removeError(error: "Invalid password" );
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }

        else if(value != "a"){
          addError(error: "Invalid password");
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter your password",
        suffixIcon: Icon(Icons.lock_rounded),
      ),
    );
  }

}


