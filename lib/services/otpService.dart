import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homely_fresh_food/pages/home_screen/home_page.dart';
import 'package:homely_fresh_food/pages/authenticate/signup.dart';

class AuthService {
  // Handle Auth
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return Signup();
        }
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signin(AuthCredential authCredential) {
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }
}
