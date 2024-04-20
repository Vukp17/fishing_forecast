import 'package:fishingapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fishingapp/widgets/main/bottom_navigation.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // Use AuthService to log in the user
      AuthService().login(_username, _password);
      if (!AuthService().isLoggedIn) {
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Login',
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
                      foregroundColor: Colors.white, backgroundColor: Color(0xFF42d9c8), // foreground
                    ),
                    onPressed: _trySubmit,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton.icon( 
                    //C:\Dev\fishingapp\lib\assets\google_logo.png  // Copy the google_logo.png file
                    //to  C:\Dev\fishingapp\lib\screens\login_screen.dart // Paste the google_logo.png file
                    icon: Image.asset('assets/google_logo.png', height: 18.0),
                    label: Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                      elevation: 1,
                    ),
                    onPressed: () {
                      // Handle Google sign in
                    },
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton.icon(
                    icon: Icon(Icons.phone_iphone),
                    label: Text('Sign in with Apple'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.black,
                      elevation: 1,
                    ),
                    onPressed: () {
                      // Handle Apple sign in
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