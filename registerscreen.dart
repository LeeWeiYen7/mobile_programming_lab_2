import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'loginscreen.dart';
import 'package:http/http.dart' as http;

class RegisterScreens extends StatefulWidget {
  @override
  _RegisterScreensState createState() => _RegisterScreensState();
}

class _RegisterScreensState extends State<RegisterScreens> {
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emcontroller = TextEditingController();
  TextEditingController _pscontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();

  String _name = "";
  String _email = "";
  String _password = "";
  String _phone = "";
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Image.asset(
                      'assets/images/logo.png',
                      scale: 1.7,
                    ),
                    TextField(
                        controller: _namecontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Name', icon: Icon(Icons.person))),
                    TextField(
                        controller: _emcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email', icon: Icon(Icons.email))),
                    TextField(
                      controller: _pscontroller,
                      decoration: InputDecoration(
                          labelText: 'Password', icon: Icon(Icons.lock)),
                      obscureText: true,
                    ),
                    TextField(
                        controller: _phonecontroller,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'Phone', icon: Icon(Icons.phone))),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Register'),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onRegister,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _onRegisted,
                        child: Text('Already Register',
                            style: TextStyle(fontSize: 16))),
                  ]),
                ))));
  }

  Future<void> _onRegister() async {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    _phone = _phonecontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    await pr.show();

    http.post("https://bornforfish07.com/bornforfish/php/register_user.php",
        body: {
          "name": _name,
          "email": _email,
          "password": _password,
          "phone": _phone,
        }).then((res) {
      if (res.body == "succes") {
        Toast.show(
          "Registration success. An email has been sent to .$_email. Please check your email for OTP verification. Also check in your spam folder.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        if (_rememberMe) {
          savepref();
        }
        _onRegisted();
      } else {
        Toast.show(
          "Registration failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
    await prefs.setBool('rememberme', true);
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      print('Check value $value');
    });
  }

  void _onRegisted() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
