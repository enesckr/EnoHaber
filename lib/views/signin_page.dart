import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
String message;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 15,
        backgroundColor: Colors.red,
        title: Text(
          "Giriş Yap",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _SignInBody(),
    );
  }
}

class _SignInBody extends StatefulWidget {
  @override
  _SignInBodyState createState() => _SignInBodyState();
}

class _SignInBodyState extends State<_SignInBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: ListView(
        children: [
          _FormWithEmailPassword(),
          _SignInProvider(
              text: "Google ile giriş yap",
              buttonType: Buttons.Google,
              signInMethod: () async => _signInWithGoogle())
        ],
      ),
    );
  }

  _signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final UserCredential userCred =
          await _firebaseAuth.signInWithCredential(credential);
      final User user = userCred.user;
      setState(() {
        message = "Welcome, ${user.displayName}";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message;
      });
    }
    toastMessage(message);
  }
}

class _SignInProvider extends StatefulWidget {
  final String text;
  final Buttons buttonType;
  final Function signInMethod;

  const _SignInProvider({
    Key key,
    @required this.text,
    @required this.buttonType,
    @required this.signInMethod,
  }) : super(key: key);

  @override
  __SignInProviderState createState() => __SignInProviderState();
}

class __SignInProviderState extends State<_SignInProvider> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.text,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            Container(
              padding: EdgeInsets.only(top: 14.0),
              alignment: Alignment.center,
              child: SignInButton(
                widget.buttonType,
                text: widget.text,
                onPressed: () async => widget.signInMethod(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FormWithEmailPassword extends StatefulWidget {
  @override
  __FormWithEmailPasswordState createState() => __FormWithEmailPasswordState();
}

class __FormWithEmailPasswordState extends State<_FormWithEmailPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Form(
        key: _formKey,
        child: Card(
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "Email ile giriş yap",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  alignment: AlignmentDirectional.center,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: _emailController,
                  validator: (String email) {
                    if (email.trim().isEmpty) {
                      return "Bir email giriniz !";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Parola"),
                  validator: (String password) {
                    if (password.trim().isEmpty) {
                      return "Bir parola giriniz !";
                    }
                    return null;
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: SignInButton(Buttons.Email,
                      text: "Email ile giriş yap", onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _signIn();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signIn() async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      final User user = userCredential.user;

      setState(() {
        message = "Hoşgeldiniz, ${user.email}";
      });
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

  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
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
