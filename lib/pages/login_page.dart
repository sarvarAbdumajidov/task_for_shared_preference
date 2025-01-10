import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_for_shared_preference/model/user_model.dart';
import 'package:task_for_shared_preference/pages/sign_up_page.dart';
import 'package:task_for_shared_preference/service/log_service.dart';
import 'package:task_for_shared_preference/service/pref_service.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    User? user = await PrefService.loadUser();
    if (user != null) {
      setState(() {
        _emailController.text = user.email!;
        _passwordController.text = user.password!;
      });
    }
  }

  Future<void> _fetchData() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(email, password);
      await PrefService.storeUser(user);
      LogService.i(user.toJson().toString());

      setState(() {
        _emailController.clear();
        _passwordController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User data saved successfully!')),
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
    _emailController.dispose();
    _passwordController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 200,
                child: Image.asset('assets/images/welcome_img.png'),
              ),
              const SizedBox(height: 15),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Log in to your existing account of Q Allure',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              UniversalTextField(
                _emailController,
                CupertinoIcons.person,
                'Email',
                TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              UniversalTextField(
                _passwordController,
                CupertinoIcons.lock,
                'Password',
                TextInputType.visiblePassword,
                obscureText: true,
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              loginButton('LOG IN', _fetchData),
              const SizedBox(height: 30),
              const Text(
                "Or connect using",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  connectButton('Facebook', Colors.indigo, Icons.facebook),
                  connectButton('Google', Colors.red, Icons.apple_outlined),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don\'t have an account?",
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                  TextButton(
                    onPressed: () {
                      _emailController.clear();
                      _passwordController.clear();
                      Navigator.pushNamed(context, SignUpPage.id);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget connectButton(String text, Color color, IconData iconData) {
    return Container(
      height: 40,
      width: 170,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: Colors.white, size: 27),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

Widget loginButton(String text, VoidCallback onPressed) {
  return SizedBox(
    height: 60,
    width: 200,
    child: CupertinoButton(
      borderRadius: BorderRadius.circular(50),
      color: CupertinoColors.activeBlue,
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      ),
    ),
  );
}

Widget UniversalTextField(
  TextEditingController controller,
  IconData iconData,
  String text,
  TextInputType textInputType, {
  bool obscureText = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    alignment: Alignment.center,
    margin: const EdgeInsets.symmetric(horizontal: 25),
    height: 70,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300, width: 2),
    ),
    child: TextField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(iconData, color: Colors.grey),
        hintText: text,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
      ),
    ),
  );
}
