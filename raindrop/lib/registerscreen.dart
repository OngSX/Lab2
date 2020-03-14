import 'package:flutter/material.dart';
import 'package:raindrop/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "https://www.albeeneko.com/raindrop/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autoValidate = false;
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Material App',
      home: Scaffold(
          backgroundColor: Colors.blue[100],
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/login.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 500,
      margin: EdgeInsets.only(top: screenHeight / 3.2),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: Form(
                key: _key,
                autovalidate: _autoValidate,
                //all of the textFormField including EULA and the register button is included in the _formUI()
                child: _formUI(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Already register? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        TextFormField(
            controller: _nameEditingController,
            keyboardType: TextInputType.text,
            maxLength: 50,
            validator: _validateName,
            
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),
        TextFormField(
            controller: _emailEditingController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextFormField(
            controller: _phoneditingController,
            keyboardType: TextInputType.phone,
            validator: _validatePhone,
            maxLength: 11,
            decoration: InputDecoration(
              labelText: 'Phone',
              icon: Icon(Icons.phone),
            )),
        TextFormField(
          controller: _passEditingController,
          maxLength: 30,
          validator: _validatePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            icon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Checkbox(
              value: _isChecked,
              onChanged: (bool value) {
                _onChange(value);
              },
            ),
            GestureDetector(
              onTap: _showEULA,
              child: Text('I Agree to Terms  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              minWidth: 115,
              height: 50,
              child: Text('Register'),
              color: Colors.blue,
              textColor: Colors.white,
              elevation: 10,
              onPressed: _onRegister,
            ),
          ],
        ),
      ],
    );
  }

  Widget pageTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 0, 60, 450),
      child: Container(
        height: 148,
        width: 300,
        decoration: new BoxDecoration(
          color: Color.fromRGBO(121, 156, 253, 150),
          borderRadius: new BorderRadius.circular(50.0),
        ),
        margin: EdgeInsets.only(top: 60),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text(
                "RainDrop",
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Register",
                style: TextStyle(
                  color: Colors.blue[50],
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRegister() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Confirm?"),
            content: new Text("Do you want to register using this email address?\n\nEach email address can only be registered once."),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginScreen()));
                  }),
              new FlatButton(
                  child: new Text("No, I wish to double check"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;
    if (_key.currentState.validate()) {
      //No validation error
    } else {
      //validation error
      setState(() {
        _autoValidate = true;
      });
    }
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("End-User License Agreement (EULA) of RainDrop"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement (\"EULA\") is a legal agreement between you and AlbeeNeko \nThis EULA agreement governs your acquisition and use of our RainDrop software (\"Software\") directly from AlbeeNeko or indirectly through a AlbeeNeko authorized reseller or distributor (a \"Reseller\"). \nPlease read this EULA agreement carefully before completing the installation process and using the RainDrop software. It provides a license to use the RainDrop software and contains warranty information and liability disclaimers.\nIf you register for a free trial of the RainDrop software, this EULA agreement will also govern that trial. By clicking \"accept\" or installing and/or using the RainDrop software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.\nIf you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\nThis EULA agreement shall apply only to the Software supplied by AlbeeNeko herewith regardless of whether other software is referred to or described herein. The terms also apply to any AlbeeNeko updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for RainDrop.\n\n*License Grant*\nAlbeeNeko hereby grants you a personal, non-transferable, non-exclusive licence to use the RainDrop software on your devices in accordance with the terms of this EULA agreement.\nYou are permitted to load the RainDrop software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the RainDrop software.\nYou are not permitted to:\n - Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things\n - Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose\n - Allow any third party to use the Software on behalf of or for the benefit of any third party\n - Use the Software in any way which breaches any applicable local, national or international law\n - use the Software for any purpose that AlbeeNeko considers is a breach of this EULA agreement\n\n*Intellectual Property and Ownership*\nAlbeeNeko shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of AlbeeNeko.\nAlbeeNeko reserves the right to grant licences to use the Software to third parties.\n\n*Termination*\nThis EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to AlbeeNeko.\nIt will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.\n\n*Governing Law*\nThis EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of my. "
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  String _validateName(String name) {
    String pattern = r'(^[a-zA-z]*$)';
    RegExp regExp = new RegExp(pattern);
    if (name.length == 0) {
      return 'Please enter your name';
    } else if (!regExp.hasMatch(name)) {
      return 'Name must be in alphabet';
    } else {
      return null;
    }
  }

  String _validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (email.length == 0) {
      return 'Please enter your email';
    } else if (!regex.hasMatch(email)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String _validatePhone(String phone) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (phone.length == 0) {
      return 'Please enter your phone number';
    } else if (!regExp.hasMatch(phone)) {
      return 'Phone number must be in number only';
    } else if (!((phone.length == 10) || (phone.length == 11))) {
      return 'Mobile number invalid';
    } else {
      return null;
    }
  }

  String _validatePassword(String password) {
    if (password.length == 0) {
      return 'Please enter your password';
    } else {
      return null;
    }
  }
}
