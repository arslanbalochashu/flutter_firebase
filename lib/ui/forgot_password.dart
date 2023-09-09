
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 40,),
            RoundButton(title: 'Send Resend Link', onPress: (){
              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                Utils().toastMessage('We have sent you an to reset password please check your email inbox');
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }),
          ],
        ),
      ),
    );
  }
}
