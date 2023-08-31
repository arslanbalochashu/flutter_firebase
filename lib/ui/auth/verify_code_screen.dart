import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/posts/post_screen.dart';

import '../../utils/utils.dart';
import '../../widget/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verifyController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            TextFormField(
              controller: verifyController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '6 digit code',
              ),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(
                loading: loading,
                title: 'Login',
                onPress: () async {
                  setState(() {
                    loading = true ;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyController.text.toString());

                  try  {
                    await auth.signInWithCredential(credential);
                    setState(() {
                      loading = false ;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
                  }catch(e){
                    setState(() {
                      loading = false ;
                    });
                    Utils().toastMessage(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
