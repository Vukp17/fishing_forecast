import 'package:fishingapp/models/user_model.dart';
import 'package:fishingapp/services/auth_service.dart';
import 'package:fishingapp/widgets/main/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

performRegister() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // Use AuthService to register the user
      final userData = await AuthService().register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
      final userModel = Provider.of<UserModel>(context, listen: false);
      userModel.setUser(userData);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavigationExample()),
      );
        }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform registration
                    performRegister();
                    
                  }
                },
                child: Text('Register'),
              ),
              const SizedBox(height: 20),
              Text('Or register with'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: Icon(Icons.face),
                    label: Text('Facebook'),
                    onPressed: () {
                      // Perform Facebook registration
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.g_translate),
                    label: Text('Google'),
                    onPressed: () {
                      // Perform Google registration
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.apple),
                    label: const  Text('Apple'),
                    onPressed: () {
                      // Perform Apple registration
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
