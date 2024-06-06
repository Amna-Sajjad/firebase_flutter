import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/models/task.dart';
import 'package:flutter/material.dart';

import 'add_task_screen.dart';
import 'update_task_screen.dart';
import 'user_update_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task List"),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateUser()));
              },
              icon: Icon(Icons.person)
          ),
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return Padding(padding: EdgeInsets.all(15),
                  child: AlertDialog(
                    title: Text("Confirmation!!", style: TextStyle(fontSize: 20),),
                    content: Text("Are you sure to Logout?"),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: (){
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                        },
                        child: Text("Yes"),
                      ),
                    ],
                  ),);
                });
              },
              icon: Icon(Icons.logout)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddTask()));
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: StreamBuilder<List<Task>>(
          stream: readTasks(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              final task = snapshot.data;
              return ListView.builder(
                itemCount: task!.length,
                itemBuilder: (context, index){
                  if(task!=null){
                    final singleTask = task[index];
                    return Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15),),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${singleTask.task}", style: TextStyle(fontSize: 18),),
                                    SizedBox(height: 5,),
                                    Text("${singleTask.timeStamp}"),
                                  ],
                                ),
                              ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                IconButton(
                                    onPressed: () async{
                                      await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UpdateTask(getTask: singleTask,)));
                                    },
                                    icon: Icon(Icons.edit)
                                ),
                                IconButton(
                                    onPressed: (){
                                      showDialog(context: context, builder: (context){
                                        return Padding(
                                          padding: EdgeInsets.all(15),
                                          child: AlertDialog(
                                            title: Text("Confirmation!!", style: TextStyle(fontSize: 20),),
                                            content: Text("Are you sure to delete?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: (){
                                                  final taskPath = FirebaseFirestore.instance.collection('tasks')
                                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                                      .collection('tasks')
                                                      .doc(singleTask.tskId);
                                                  taskPath.delete();
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Yes"),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                    icon: Icon(Icons.delete)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }else{
                    return Center(child: Text("No Task Yet"),);
                  }
                },
              );
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
  Stream<List<Task>> readTasks() => FirebaseFirestore.instance.collection('tasks')
  .doc(FirebaseAuth.instance.currentUser!.uid)
  .collection('tasks')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
}
