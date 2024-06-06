import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_type_page.dart';

class Settings extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final version = "1.0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Seçenekler",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 15,
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.red[400],
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 20,
                child: Container(
                  height: MediaQuery.of(context).size.height / 10,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () => null,

                    ///TODO: Geliştirici Ekranı Yapılacak
                    child: Text("Geliştirici"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepOrangeAccent)),
                  ),
                ),
              ),
              Card(
                elevation: 20,
                child: Container(
                  height: MediaQuery.of(context).size.height / 10,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () => null,

                    ///TODO: Lisanslar Ekranı Yapılacak
                    child: Text("Lisanslar"),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepOrangeAccent)),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    child: IconButton(
                        icon: Icon(
                          Icons.logout,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _firebaseAuth.signOut();
                          if (await GoogleSignIn().isSignedIn()) {
                            await GoogleSignIn().disconnect();
                            await GoogleSignIn().signOut();
                          }
                          toastMessage("Başarıyla çıkış yapıldı.");

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthTypeSelector()));
                        }),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    child: Text(
                      "EnoHaber v$version",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
}
