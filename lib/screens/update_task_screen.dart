import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import '../models/task.dart';

class UpdateTask extends StatefulWidget {
  final Task getTask;
  const UpdateTask({Key? key, required this.getTask}) : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {

  var formKey = GlobalKey<FormState>();
  var updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Task"),),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Update Task"
                  ),
                  controller: updateController,
                  validator: (text){
                    if(text==null || text.isEmpty){
                      return "Add some task";
                    }else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: () {
                      ProgressDialog progressDialog = ProgressDialog(context,
                      title: Text("Updating task...."), message: Text("Please wait...."));
                      progressDialog.show();
                      if(formKey.currentState!.validate()){
                        final taskPath = FirebaseFirestore.instance.collection('tasks')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('tasks')
                            .doc(widget.getTask.tskId);
                        taskPath.update({
                          'task' : updateController.text,
                        });
                        progressDialog.dismiss();
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Update")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
