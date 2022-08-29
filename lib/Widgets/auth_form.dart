import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  // AuthForm(this.submitFn);

  // final void Function(String email, String username, String password, bool islogin,BuildContext context) {
  //   submitfn;
  // }

  AuthForm(
    this.submitFn,
    this.isloading,
  );
  final bool isloading;
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext ctx) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();

  var _islogin = true;
  var _useremail = "";
  var _username = "";
  var _userpassword = "";
  // var _isloading=false;

  void _trySubmit() {
    final _isvalid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isvalid) {
      _formkey.currentState!.save();
      widget.submitFn(_useremail.trim(), _username.trim(), _userpassword.trim(),
          _islogin, context);
      print(_useremail);
      print(_username);
      print(_userpassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: ValueKey("Useremail"),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _useremail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                  ),
                ),
                if (!_islogin)
                  TextFormField(
                    key: ValueKey("Username"),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return "Enter atleast 4 characters ";
                      }
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                  ),
                TextFormField(
                  key: ValueKey("Userpassword"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return " Enter atleast 7 characters";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userpassword = value!;
                  },
                ),
                const SizedBox(height: 12),
                if (widget.isloading) CircularProgressIndicator(),
                if (!widget.isloading)
                  ElevatedButton(
                    onPressed: () {
                      _trySubmit();
                    },
                    child: Text(_islogin ? "Login" : "Sign up"),
                  ),
                if (!widget.isloading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _islogin = !_islogin;
                      });
                    },
                    child: Text(_islogin
                        ? "Create New Account"
                        : "Already have account"),
                  )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
