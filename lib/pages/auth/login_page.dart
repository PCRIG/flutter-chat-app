import 'package:chatapp/pages/auth/register_page.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Groupie!",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            const Text(
              "Login now to stay connected...",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            Image.asset("assets/login.png"),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  labelText: "Email",
                  prefixIcon:
                      Icon(Icons.email, color: Theme.of(context).primaryColor)),
              validator: (value) {
                return value!.length > 6
                    ? null
                    : "Please enter a valid email address";
              },
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              obscureText: true,
              decoration: textInputDecoration.copyWith(
                  labelText: "Password",
                  prefixIcon:
                      Icon(Icons.lock, color: Theme.of(context).primaryColor)),
              validator: (value) {
                return value!.length > 6
                    ? null
                    : "Password should be in more than 6 characters";
              },
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text("Sign In", style: TextStyle(fontSize: 16)),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
                TextSpan(text: "Don't have an account? ", children: <TextSpan>[
              TextSpan(
                  text: "Register here",
                  style: const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    nextScreen(context, const RegisterPage());
                  })
            ]))
          ],
        ),
      )),
    ));
  }
}
