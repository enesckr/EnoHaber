import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/views/home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 15,
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          "Kayıt Ol",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatefulWidget {
  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<_RegisterBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Container(
        alignment: Alignment.center,
        child: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                elevation: 30.0,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: "E-Mail", hintText: "abc@test.com"),
                        validator: (String email) {
                          if (email.trim().isEmpty) {
                            return "Enter a email !";
                          }
                          return null; // return String
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                        validator: (String password) {
                          if (password.trim().isEmpty) {
                            return "Enter a password !";
                          }
                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        alignment: Alignment.center,
                        child: SignInButtonBuilder(
                          icon: Icons.person_add_outlined,
                          backgroundColor: Colors.redAccent,
                          elevation: 15,
                          text: "Register",
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              register();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void register() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      final User user =
          userCredential.user; // set registered user's credentials

      if (user != null) {
        setState(() {
          message = "Welcome, ${user.email}";
        });
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message;
      });
    } catch (e) {
      print(e);
    }
    toastMessage(message);
  }

  toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
