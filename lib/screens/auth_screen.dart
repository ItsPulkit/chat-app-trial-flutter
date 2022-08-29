import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/Widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _loading = false;
  void _submitauthform(
    String email,
    String username,
    String password,
    bool islogin,
    BuildContext ctx,
  ) async {
    UserCredential cred;
    try {
      setState(() {
        _loading = true;
      });
      if (islogin) {
        cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({'username': username, 'password': password, 'email': email});
      setState(() {
        _loading = false;
      });
    } on FirebaseAuthException catch (err) {
      var msg = "Enter valid credentials";
      if (err.message != null) {
        msg = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _loading = false;
      });
    }
    // catch (err) {
    //   print(" Error is :");
    //   print(err);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitauthform, _loading),
    );
  }
}
