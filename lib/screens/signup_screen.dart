import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/screens/home_task_screen.dart';
import 'package:firebaseflutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import '../models/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cnfrmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"),),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  controller: usernameController,
                  validator: (text){
                    return (text==null || text.isEmpty)?
                    "Please provide Username" :
                    null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  controller: emailController,
                  validator: (text){
                    return (text==null || text.isEmpty)?
                    "Please provide email" :
                    null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  obscureText: true,
                  controller: passwordController,
                  validator: (text){
                    return (text==null || text.isEmpty || text.length<6)?
                    "Please provide password" :
                    null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  obscureText: true,
                  controller: cnfrmPasswordController,
                  validator: (text){
                    return (text==null || text.isEmpty || text!=passwordController.text)?
                    "Please provide Confirm Password" :
                    null;
                  },
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Signup", style: TextStyle(
                        fontSize: 20
                    ),),
                  ),
                  onPressed: () async=>signupUser(),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                      style: TextStyle(color: Colors.black, fontSize: 16),),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                        },
                        child: Text("LoginUp",
                            style: TextStyle(fontSize: 17, color: Colors.blue,
                              decoration: TextDecoration.underline,))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future signupUser() async{
    ProgressDialog progressDialog = ProgressDialog(context,
        title: Text("Signing Up...."), message: Text("Please wait...."));
    progressDialog.show();
    if(formKey.currentState!.validate()){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        final docUser = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
        final user = FirebaseUser(FirebaseAuth.instance.currentUser!.uid,
        usernameController.text, emailController.text, passwordController.text, "");
        await docUser.set(user.toJson());
        progressDialog.dismiss();
        if(FirebaseAuth.instance.currentUser!=null){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
        }
      }on FirebaseAuthException catch(e){
        print(e);
      }
    }else{
      progressDialog.dismiss();
    }
  }
}
