import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Email",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
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
                obscureText: true,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {},
                ),
              ),
            ]),
          ),
        ),
      )),
    );
  }
}
