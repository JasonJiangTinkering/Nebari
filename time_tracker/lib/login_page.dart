import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key}) : loginController = Get.put(LoginController());

  final LoginController loginController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Column(
        children: [
          Container(
            width: 318,
            height: 78,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 190, 133, 133),
            ),
            child: Center(
              child: Obx(() => Text(
                widget.loginController.alerts.value,
                style: const TextStyle(
                  fontSize: 10.63636016845703,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              )),
            ),
          ),
          const Text(
            "login/create account.",
            style: TextStyle(
              fontSize: 46.63636016845703,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
              child: Text(
                "email.",
                style: TextStyle(
                  fontSize: 28.80000114440918,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            width: 318,
            height: 78,
            child: TextField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffd9d9d9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your email',
              ),
              onChanged: (value) => widget.loginController.updateEmail(value),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
              child: Text(
                "password.",
                style: TextStyle(
                  fontSize: 28.80000114440918,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            width: 318,
            height: 78,
            child: TextField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xffd9d9d9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your password',
              ),
              obscureText: true,
              onChanged: (value) => widget.loginController.updatePassword(value),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add login logic here
              widget.loginController.submit(); // Navigate to second page after login
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "Sign In",
              style: TextStyle(
                fontSize: 28.80000114440918,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "nothing down here to see.. Sign in first",
              style: TextStyle(
                fontSize: 28.80000114440918,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      
    );
    
  }
}