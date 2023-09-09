import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/ui/auth/login_screen.dart';
import 'package:flutter_firebase/ui/posts/add_post.dart';
import 'package:flutter_firebase/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Screen'),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: searchFilter,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value){
                  setState(() {
                    
                  });
                },
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Center(child: CircularProgressIndicator(color: Colors.deepPurple,)),
                  query: ref,
                  itemBuilder: (BuildContext context, snapshot , animation , index){
                  
                  final title = snapshot.child('title').value.toString();

                  if(searchFilter.text.isEmpty){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert_rounded),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value : 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(
                                      title , snapshot.child('id').value.toString()
                                    );
                                  },
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            )),
                            PopupMenuItem(
                              value : 1,
                                child: ListTile(
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                              leading: Icon(Icons.delete_outline),
                              title: Text('Delete'),
                            )),
                          ]),
                    );
                  }else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toString())){
                    return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  }
                  else{
                    return Container();
                  }

                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
            onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
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
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
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
              ref.child(id).update({
                'title' : editController.text.toString()
              }).then((value){
                Utils().toastMessage('Post Updated');
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }, child: const Text('Update'),),
          ],
        );
      },
    );
  }
}



// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context , AsyncSnapshot<DatabaseEvent> snapshot){
//
// if(!snapshot.hasData){
// return const CircularProgressIndicator(color: Colors.deepPurple,);
// }else{
// Map<dynamic , dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [] ;
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context , index){
// return ListTile(
// title: Text(list[index]['title']),
// subtitle: Text(list[index]['id']),
// );
// });
// }
// }),),