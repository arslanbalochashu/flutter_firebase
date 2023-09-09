import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:flutter_firebase/ui/firestore/add_firestore_data.dart';
import 'package:flutter_firebase/utils/utils.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  final CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FireStore'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){
              auth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }, icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(stream: fireStore, builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              if(snapshot.hasError){
                return Text('Sum error');
              }
              return  Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context , index){
                      return ListTile(
                        onTap: (){
                          // ref.doc(
                          //     snapshot.data!.docs[index]['id'].toString()).update(
                          //     {
                          //       'title': 'i am not good in flutter',
                          //     }).then((value){
                          //       Utils().toastMessage('updated');
                          // }).onError((error, stackTrace){
                          //   Utils().toastMessage(error.toString());
                          // });

                          ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                        },
                        title: Text(snapshot.data!.docs[index]['title'].toString()),
                        subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                      );
                    }),
              );
            }),

          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddFireStoreDataScreen()));
            }),
      ),
    );
  }
  Future<void> showMyDialog( String title, String id) async {
    editController.text = title ;
    return showDialog(
      context : context,
      builder : (BuildContext context){
        return AlertDialog(
          title: const Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: const InputDecoration(
                  hintText: 'Edit'
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Cancel'),),
            TextButton(onPressed: (){
              Navigator.pop(context);

            }, child: const Text('Update'),),
          ],
        );
      },
    );
  }
}
