import 'package:get/get.dart';
import 'firebase_user_auth.dart';
import 'package:flutter/foundation.dart';

class LoginController extends GetxController {
  var email = ''.obs; // Use Rx variables for reactive updates
  var password = ''.obs;
  var alerts = ''.obs;
  var email_alerts = '';
  var password_alerts = '';// Use Rx variables for reactive updates
  FirebaseUserAuth auth = FirebaseUserAuth();
  
  void updateEmail(String email) {
    if (email.isEmpty) {
      this.email_alerts = 'Please enter a email address';
      this.alerts.value = '$email_alerts\n$password_alerts';
    } else if (!GetUtils.isEmail(email)) {
      this.email_alerts = 'Please enter a valid email address';
      this.alerts.value = '$email_alerts\n$password_alerts';
    }else{
      this.email_alerts = '';
      this.alerts.value = '$email_alerts\n$password_alerts';
    }
    this.email.value = email;

  }

  void updatePassword(String password){
    if (password.isEmpty) {
      this.password_alerts = 'Please enter a password';
      this.alerts.value = '$email_alerts\n$password_alerts';
    } else if (password.length < 6) {
      this.password_alerts = 'Please enter a password with at least 6 characters';
      this.alerts.value = '$email_alerts\n$password_alerts';
    }else {
      this.password_alerts = '';
      this.alerts.value = '$email_alerts\n$password_alerts';
    }
    
    this.password.value = password;
  }

  void submit() async {
    print("Submit method called");
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        print("Attempting to sign in");
        var userCredential = await auth.signInWithEmailAndPassword(email.value, password.value);
        if (userCredential != null) {
          debugPrint('Login successful for email: ${email.value}');
          Get.offNamed('/second'); // Navigate to second page after successful login
        } else {
          // If sign in fails, attempt to create a new user
          userCredential = await auth.createUserWithEmailAndPassword(email.value, password.value);
          if (userCredential != null) {
            debugPrint('New user created and logged in with email: ${email.value}');
            Get.offNamed('/second'); // Navigate to second page after successful account creation and login
          } 
        }       
      } catch (e) {
        debugPrint('Error during authentication: $e');
        Get.snackbar('Error', 'An error occurred during authentication: $e');
      }
    } else {
      Get.snackbar('Error', 'Please enter both email and password');
    }

  }

  
}