import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fishingapp/widgets/main/bottom_navigation.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _username = '';
  var _password = '';

  // void _trySubmit()  async{
  //   final isValid = _formKey.currentState?.validate();
  //   if (isValid == true) {
  //     // Use AuthService to log in the user

  //     if ( await AuthService().login(_username, _password)) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => BottomNavigationExample()),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Invalid username or password')),
  //       );
  //     }
  //   }
  // }
  void performLogin() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      final userData = await AuthService().login(_username, _password);
      if (userData != null) {
        final userModel = Provider.of<UserModel>(context, listen: false);
        userModel.setUser(userData);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavigationExample()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Card(
          // color:Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'fishingforecast', // Add logo text
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _username = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF42d9c8), // foreground
                    ),
                    onPressed: performLogin,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon:
                            Image.asset('assets/google_logo.png', height: 18.0),
                        onPressed: () {
                          // Handle Google sign in
                        },
                      ),
                      IconButton(
                        icon:
                            Image.asset('assets/apple_logo.png', height: 18.0),
                        onPressed: () {
                          // Handle Apple sign in
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/facebook_logo.png',
                            height: 18.0),
                        onPressed: () {
                          // Handle Facebook sign in
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF42d9c8), // foreground
                    ),
                    child: Text('Create Account'),
                    onPressed: () {
                      // Handle account creation
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
