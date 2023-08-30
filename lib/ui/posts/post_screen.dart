import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post Screen'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){
              auth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }, icon: Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
          ],
        ),
      ),
    );
  }
}
