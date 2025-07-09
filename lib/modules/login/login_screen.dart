//login screen
import 'package:order_app/modules/home/home_screen.dart';
import 'package:order_app/shared/components/components.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Login now to order your meals',
                    style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20.0),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'Email must not be empty';
                      }
                      return null;
                    },
                    label: 'Email Address',
                    prefix: Icons.email,
                  ),
                  const SizedBox(height: 20.0),
                  defaultFormField(
                    controller: passwordController,
                    suffix:
                        isPassword ? Icons.visibility : Icons.visibility_off,
                    suffixPrssed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    type: TextInputType.visiblePassword,
                    isPassword: isPassword,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'Password must not be empty';
                      }
                    },
                    label: 'Password',
                    prefix: Icons.lock,
                  ),
                  const SizedBox(height: 20.0),
                  defaultButton(
                    function: () {
                      if (formKey.currentState!.validate()) {
                        // print(emailController.text);
                        // print(passwordController.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      }
                    },
                    text: 'login',
                    radius: 50.0,
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
