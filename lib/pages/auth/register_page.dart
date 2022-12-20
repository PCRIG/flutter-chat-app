import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  bool _isLoading = false;

  String fullName = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 70),
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
                            "Create your account here",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          Image.asset("assets/register.png"),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Full Name",
                                prefixIcon: Icon(Icons.person,
                                    color: Theme.of(context).primaryColor)),
                            validator: (value) {
                              return value!.trim().isNotEmpty
                                  ? null
                                  : "Name can't be empty";
                            },
                            onChanged: (value) {
                              setState(() {
                                fullName = value;
                              });
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.email,
                                    color: Theme.of(context).primaryColor)),
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
                                prefixIcon: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor)),
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
                              onPressed: registerUser,
                              child: const Text("Sign In",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(TextSpan(
                              text: "Don't have an account? ",
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Register here",
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreenReplacement(
                                            context, const LoginPage());
                                      })
                              ]))
                        ],
                      ),
                    )),
              ));
  }

  registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmail(fullName, email, password)
          .then((value) {
        if (value == true) {
          nextScreen(context, const HomePage());
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
