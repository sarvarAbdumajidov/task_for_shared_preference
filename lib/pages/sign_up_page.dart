import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_for_shared_preference/model/account_model.dart';
import 'package:task_for_shared_preference/pages/login_page.dart';
import 'package:task_for_shared_preference/service/flutter_secure_storage_service.dart';
import 'package:task_for_shared_preference/service/log_service.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'sign_ip_page';

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  _clearFunc() {
    _fullNameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedAccount();
  }

  Future<void> _loadSavedAccount() async {
    Account? account = await SecureService.loadUser();
    if (account != null) {
      setState(() {
        _fullNameController.text = account.fullName!;
        _emailController.text = account.email!;
        _phoneController.text = account.phone!;
        _passwordController.text = account.password!;
      });
    }
  }

  Future<void> _fetchData() async {
    String email = _emailController.text.trim();
    String fullName = _fullNameController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (email.isNotEmpty &&
        password.isNotEmpty &&
        phone.isNotEmpty &&
        fullName.isNotEmpty &&
        password == confirmPassword) {
      Account account = Account(fullName, email, phone, password);
      await SecureService.storeUser(account);
      LogService.i(account.toJson().toString());
      setState(() {
        _clearFunc();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account data saved successfully!')),
      );
    } else {
      LogService.w('Login yoki parol bo\'sh');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: AlignmentDirectional.centerStart,
                color: Colors.grey.shade100,
                child: BackButton(
                  onPressed: () {
                    _clearFunc();
                    Navigator.pop(context);
                  }, //!!!!!!!!!!!!!!!
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Let\'s Get Started',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              const SizedBox(height: 10),
              Text(
                'Create an account to Q Allure to get all features',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              // Full Name
              UniversalTextField(_fullNameController, CupertinoIcons.person,
                  'Full Name', TextInputType.name),
              const SizedBox(height: 20),
              // Email
              UniversalTextField(_emailController, CupertinoIcons.mail, 'Email',
                  TextInputType.emailAddress),
              const SizedBox(height: 20),
              // Phone
              UniversalTextField(_phoneController, CupertinoIcons.phone,
                  'Phone', TextInputType.phone),
              const SizedBox(height: 20),
              // Password
              UniversalTextField(_passwordController, CupertinoIcons.lock,
                  'Password', TextInputType.visiblePassword),
              const SizedBox(height: 20),
              // Confirm Password
              UniversalTextField(
                  _confirmPasswordController,
                  CupertinoIcons.lock,
                  'Confirm Password',
                  TextInputType.visiblePassword),
              const SizedBox(height: 40),
              loginButton('Create', _fetchData),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                  TextButton(
                      onPressed: () {
                        _clearFunc();
                        Navigator.pushNamed(context, LoginPage.id);
                      },
                      child: Text(
                        'Login here',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
