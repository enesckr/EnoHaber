import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:news_app/views/home.dart';

import 'register_page.dart';
import 'signin_page.dart';

class AuthTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Eno",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Haber",
              style: TextStyle(color: Colors.orangeAccent),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.red[400],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // REGISTER BUTTON
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(18.0),
              child: SignInButtonBuilder(
                text: "Kaydol",
                backgroundColor: Colors.redAccent,
                icon: Icons.person_add_outlined,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                )),
              ),
            ),
            Container(
              padding: EdgeInsets.all(18.0),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                text: "Giriş Yap",
                icon: Icons.login_outlined,
                backgroundColor: Colors.deepOrangeAccent,
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        FirebaseAuth.instance.currentUser == null
                            ? SignInPage()
                            : Home())),
              ),
            )
          ],
        ),
      ),
    );
  }
}
