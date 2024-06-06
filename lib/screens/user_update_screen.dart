import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

import '../models/user.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update User"),),
      body: FutureBuilder<FirebaseUser?>(
        future: readUser(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            var userData = snapshot.data;
            print("img: ${userData!.img}");
            return Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: imageFile!=null?
                       CircleAvatar(
                         radius: 80,
                          backgroundImage: FileImage(imageFile!,),
                        ):CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage("${userData!.img}"),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          showModalBottomSheet(context: context, builder: (context){
                            return Container(
                              child: Wrap(
                                children: [
                                  ListTile(
                                    title: Text("From Gallery"),
                                    leading: Icon(Icons.browse_gallery),
                                    onTap: (){
                                      pickGalleryImg(0);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    title: Text("From Camera"),
                                    leading: Icon(Icons.camera_alt),
                                    onTap: (){
                                      pickGalleryImg(1);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                        icon: Icon(Icons.camera_alt, size: 30),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white,),
                    child: Column(
                      children: [
                        Text("${userData!.name}"),
                        Text("${userData.email}"),
                        Text("Password ${userData.password}"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }

        },
      ),
    );
  }
  Future<FirebaseUser?>readUser() async{
    final userPath = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await userPath.get();

    if(snapshot.exists){
      return FirebaseUser.fromJson(snapshot.data()!);
    }
  }
  Future pickGalleryImg(int source) async{
    try{
      final image = source==0
          ? await ImagePicker().pickImage(source: ImageSource.gallery)
          : await ImagePicker().pickImage(source: ImageSource.camera);
      ProgressDialog progressDialog = ProgressDialog(context,
          title: Text("Uploading...."), message: Text("Please wait...."));
      progressDialog.show();
      if(image==null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.imageFile = imageTemp;
      });

      final path = "files/${image.name}";
      final ref  = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(imageTemp);
      TaskSnapshot snapshot = await uploadTask;
      String profileImageUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'img' : profileImageUrl
      });
      progressDialog.dismiss();

    }on PlatformException catch(e){
      print(e);
    }
  }
}
