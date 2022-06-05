import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_authentication/model/profile.dart';
import 'package:flutter_authentication/screen/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
            ),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text("Sign up")),
            body: Container(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: MultiValidator([
                            EmailValidator(
                                errorText: "forget @ Email Don't Format !"),
                            RequiredValidator(
                                errorText: "Please enter Email !"),
                          ]),
                          onSaved: (String? email) {
                            profile.email = email;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(fontSize: 20),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                              errorText: "Please enter Password !"),
                          onSaved: (String? password) {
                            profile.password = password;
                          },
                          obscureText: true,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "Sign up",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: profile.email!,
                                    password: profile.password!,
                                  )
                                      .then((value) {
                                    formKey.currentState!.reset();
                                    Fluttertoast.showToast(
                                      msg: "SucessFully",
                                      gravity: ToastGravity.TOP,
                                    );
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: ((context) {
                                        return HomeScreen();
                                      }),
                                    ));
                                  });
                                } on FirebaseAuthException catch (e) {
                                  String? message;
                                  if (e.code == 'email-already-in-use') {
                                    message = 'There is a duplicate email';
                                  } else if (e.code == 'weak-password') {
                                    message =
                                        'Password must be more than 6 characters.';
                                  } else {
                                    message = e.message;
                                  }

                                  Fluttertoast.showToast(
                                    msg: message!,
                                    gravity: ToastGravity.CENTER,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ]),
                ),
              ),
            )),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
    //
  }
}
