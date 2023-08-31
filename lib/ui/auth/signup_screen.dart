import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:flutter_firebase/ui/auth/login_with_phone_number.dart';
import 'package:flutter_firebase/widget/round_button.dart';

import '../../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  signUp(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(email: _emailController.text.toString(), password: _passwordController.text.toString()).then((value){
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace){
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController;
    _passwordController;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),

                    ),
                  ),
                  SizedBox(height: 40,),
                ],
              ),),
            RoundButton(
              loading: loading,
                title: 'SignUp',
                onPress: (){
              if(_formKey.currentState!.validate()){
                signUp();
              }
            }),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an Account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }, child: const Text('Login here',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),)),
              ],
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWithPhoneNumber()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black),
                ),
                child: const Center(
                  child: Text('Login with phone'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
