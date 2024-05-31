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
  bool _obscureText = true;
  bool _isLoading = false; // Add this

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void performLogin() async {
    setState(() {
      _isLoading = true; // Set loading to true when login starts
    });

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
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }

    setState(() {
      _isLoading = false; // Set loading to false when login ends
    });
  }
  void googleSignIn() async {
   final userData = await AuthService().googleSignIn();

      if (userData != null) {
        final userModel = Provider.of<UserModel>(context, listen: false);
        userModel.setUser(userData);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BottomNavigationExample()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'FIshing Forecast', // Add logo text
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Pacifico',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Login to your account',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(),
                    ),
                  ),
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
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: _obscureText,
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
                const SizedBox(height: 10.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Login', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF42d9c8), // foreground
                    ),
                    onPressed: _isLoading ? null : performLogin,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0), // Add this
                        border: Border.all(
                          color: const Color(0xFF42d9c8),
                        ),
                      ),
                      child: IconButton(
                        icon:
                            Image.asset('assets/apple_logo.png', height: 18.0),
                        onPressed: () {
                          // Handle Google sign in
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0), // Add this
                        border: Border.all(
                          color: const Color(0xFF42d9c8),
                        ),
                      ),
                      child: IconButton(
                        icon:
                            Image.asset('assets/google_logo.png', height: 18.0),
                        onPressed: () async {
                              googleSignIn();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0), // Add this
                        border: Border.all(
                          color: const Color(0xFF42d9c8),
                        ),
                      ),
                      child: IconButton(
                        icon: Image.asset('assets/facebook_logo.png',
                            height: 18.0),
                        onPressed: () {
                          // Handle Facebook sign in
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF42d9c8), // foreground
                  ),
                  child: const Text('Create Account'),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                    // Handle account creation
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
