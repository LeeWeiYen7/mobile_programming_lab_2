import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'registerscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'mainpage.dart';

bool _rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  TextEditingController _pscontroller = TextEditingController();
  String _password = "";
  SharedPreferences prefs;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: new Container(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      scale: 1.15,
                    ),
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
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Login'),
                      color: Colors.green,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: _onLogin,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text('Remember Me', style: TextStyle(fontSize: 16))
                      ],
                    ),
                    GestureDetector(
                        onTap: _onRegister,
                        child: Text('Register New Account',
                            style: TextStyle(fontSize: 16))),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: _onForgot,
                        child: Text('Forgot Account',
                            style: TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            )));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      print('Check value $value');
    });
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emcontroller.text = _email;
        _pscontroller.text = _password;
        _rememberMe = _rememberMe;
      });
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe = false;
        Toast.show(
          "Email/password empty!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Preferences saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.CENTER,
        );
        print("SUCCESS");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe = false;
      });
    }
  }

  void _onLogin() {
    print(_emcontroller.text);
    print(_pscontroller.text);

    http.post("https://bornforfish07.com/bornforfish/php/register_user.php",
        body: {
          "email": _email,
          "password": _password,
        }).then((res) {
      print(res.body);
      if (res.body == "sucess") {
        Toast.show(
          "Login success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainPage()));
      } else {
        Toast.show(
          "Login failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  void _onRegister() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RegisterScreens()));
  }

  void _onForgot() {
    print('onForgot');
  }
}
