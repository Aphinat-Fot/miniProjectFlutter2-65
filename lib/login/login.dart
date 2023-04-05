import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formstate = GlobalKey<FormState>();
  String? email;
  String? password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formstate,
      child: Container(
        padding: EdgeInsets.all(60),
        child: ListView(
          children: <Widget>[
            showImage(),
            emailTextFormField(),
            passwordTextFormField(),
            loginButton(),
            registerButton(context),
            resetPassButton(context)
          ],
        ),
      ),
    ));
  }

  Container showImage() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Image.asset(
        "assets/images/logo.png",
        height: 250,
      ),
    );
  }

  Container resetPassButton(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        // ignore: prefer_const_constructors
        child: Text('Reset Password  account'),
        onPressed: () {
          print('Goto  Reset pagge');
          Navigator.pushNamed(context, '/reset');
        },
      ),
    );
  }

  Container registerButton(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        // ignore: prefer_const_constructors
        child: Text('Register new account'),
        onPressed: () {
          print('Goto  Regis pagge');
          Navigator.pushNamed(context, '/register');
        },
      ),
    );
  }

  Container loginButton() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: EdgeInsets.only(top: 8),
      child: ElevatedButton(
          child: const Text('Login'),
          onPressed: () async {
            if (_formstate.currentState!.validate()) {
              print('Valid Form');
              _formstate.currentState!.save();
              try {
                await auth
                    .signInWithEmailAndPassword(
                        email: email!, password: password!)
                    .then((value) {
                  if (value.user!.emailVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login Pass")));
                    Navigator.pushReplacementNamed(context, '/homepage');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please verify email")));
                  }
                }).catchError((reason) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Login or Password Invalid")));
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                }
              }
            } else {
              print('Invalid Form');
            }
          }),
    );
  }

  Container passwordTextFormField() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: TextFormField(
        onSaved: (value) {
          password = value!.trim();
        },
        validator: (value) {
          if (value!.length <= 5) {
            return 'Please Enter more than 6 Character';
          } else {
            return null;
          }
        },
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder()),
      ),
    );
  }

  Container emailTextFormField() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: TextFormField(
        onSaved: (value) {
          email = value!.trim();
        },
        validator: (value) {
          if (!validateEmail(value!)) {
            return 'Please fill in E-mail field';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
            labelText: 'E-mail',
            prefixIcon: Icon(Icons.email),
            hintText: 'x@x.com',
            border: OutlineInputBorder()),
      ),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return (!regex.hasMatch(value)) ? false : true;
  }
}
