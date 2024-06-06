import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseflutter/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:ndialog/ndialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Please"),
      ),
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
                ElevatedButton(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Login", style: TextStyle(
                        fontSize: 20
                    ),),
                  ),
                  onPressed: () async=>loginUser(),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not Registered Yet ",
                    style: TextStyle(color: Colors.black, fontSize: 16),),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen()));
                        },
                        child: Text("SignUp",
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
  Future loginUser() async{
    ProgressDialog progressDialog = ProgressDialog(context,
        title: Text("Logging In...."), message: Text("Please wait...."));
    progressDialog.show();
    if(formKey.currentState!.validate()){
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        progressDialog.dismiss();
      }on FirebaseAuthException catch(e){
        print(e);
      }
    }else{
      progressDialog.dismiss();
    }
  }
}
