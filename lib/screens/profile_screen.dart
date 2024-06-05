import 'package:fishingapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:fishingapp/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:fishingapp/providers/language_provider.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String? _selectedLocation;
  String? _selectedLanguage;
  bool _isEditing = false;
  final Map<String, String> _languageMap = {
    'en': 'English',
    'sr': 'Serbian',
    'sl': 'Slovenian',
    'hr': 'Croatian',
  };
  Future _updateUser() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final user = userModel.user;
    if (user != null) {
      await UserService().updateUser(
        user,
        _usernameController.text,
        _emailController.text,
        _languageMap.entries.firstWhere((entry) => entry.value == _selectedLanguage).key,
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user?.username);
    _emailController = TextEditingController(text: widget.user?.email);
    _passwordController = TextEditingController(text: '********');
    if (widget.user?.language_id != null) {
      _selectedLanguage = _languageMap[widget.user!.language_id];
    }
    print('Language: ${widget.user!.language_id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const CircleAvatar(
            radius: 50,
            // Replace with your user's profile image
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_isEditing) {
                _updateUser();
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Text(_isEditing ? 'Done' : 'Edit'),
          ),
          const SizedBox(height: 16.0),
          _buildTextField('Username', _usernameController, !_isEditing),
          _buildTextField('Email', _emailController, !_isEditing),
          _buildTextField('Password', _passwordController, !_isEditing),
          _buildDropdown('Favorite Location', ['Location 1', 'Location 2'],
              _selectedLocation),
          _buildLanguageDropdown(
            'Languages',
            ['English', 'Serbian', 'Slovenian', 'Croatian'],
            _selectedLanguage,
            (String? newValue) {
              if (newValue != null) {
                Locale newLocale;
                switch (newValue) {
                  case 'English':
                    newLocale = const Locale('en', 'US');
                    break;
                  case 'Serbian':
                    newLocale = const Locale('sr', 'RS');
                    break;
                  case 'Slovenian':
                    newLocale = const Locale('sl', 'SI');
                    break;
                  case 'Croatian':
                    newLocale = const Locale('hr', 'HR');
                    break;
                  default:
                    newLocale = const Locale('en', 'US'); // Default to English
                }
                Provider.of<LanguageProvider>(context, listen: false)
                    .changeLocale(newLocale);
                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool readOnly) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label, List<String> items, String? selectedItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          isExpanded: true,
          hint: Text(label),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: _isEditing
              ? (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown(String label, List<String> items,
      String? selectedItem, ValueChanged<String?>? onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          isExpanded: true,
          hint: Text(label),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
