import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/screens/home_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import '../models/task.dart';
class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  var formKey = GlobalKey<FormState>();
  var addTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task"),),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Add Task"
                  ),
                  controller: addTaskController,
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
                    onPressed: () async =>addTasks(addTaskController.text),
                    child: Text("Save")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future addTasks(String text) async{
    ProgressDialog progressDialog = ProgressDialog(context,
        title: Text("Adding task...."), message: Text("Please wait...."));
    progressDialog.show();
    if(formKey.currentState!.validate()){
      try {
        final addTask = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('tasks').doc();
        final taskID = addTask.id;
        final nowDate = DateTime.now();
        final formatter = DateFormat('dd MMM yyyy');
        final timeStamp = formatter.format(nowDate);
        final task = Task(taskID, FirebaseAuth.instance.currentUser!.uid, text, timeStamp);
        await addTask.set(task.toJson());
        progressDialog.dismiss();
        addTaskController.text = "";
        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
        Navigator.pop(context);
      }on FirebaseException catch(e){
        print(e);
      }
    }else{
      progressDialog.dismiss();
    }
  }
}
