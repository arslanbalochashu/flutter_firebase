import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage ;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  File? _image ;
  final picker = ImagePicker();
  bool loading = false;

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  Future getGalleryImage()async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        if (kDebugMode) {
          print('no image picked');
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                getGalleryImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all()
                ),
                child: _image != null ? Image.file(_image!.absolute) :Center(child: Icon(Icons.image)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
                title: 'Upload',
                loading: loading,
                onPress: () async{

                  setState(() {
                    loading = true;
                  });

                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername/' + DateTime.now().millisecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

                  await Future.value(uploadTask).then((value) async {
                    var  newUrl  =  await ref.getDownloadURL();

                    databaseRef.child('1').set({
                      'id' : '1212',
                      'title' : newUrl.toString()
                    }).then((value){
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('Uploaded');
                    }).onError((error, stackTrace){
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                  });



            })
          ],
        ),
      ),
    );
  }
}
