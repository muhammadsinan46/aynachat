import 'package:aynachat/screens/chat_screen.dart';
import 'package:aynachat/screens/login.dart';
import 'package:aynachat/model/models.dart';
import 'package:aynachat/screens/responsive_screen.dart';

import 'package:aynachat/services/auth_Services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SignUp extends StatefulWidget {

  AuthServices authServices;

    SignUp({super.key,  required this.authServices});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {



 

  var usernameController =TextEditingController();
  var passwordController =TextEditingController();

  signupUser()async{
  final username = usernameController.text;
  final password = passwordController.text;
    
  if(widget.authServices.isUserExist(username)){

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("user is exist")));
  }else{

SharedPreferences pref = await SharedPreferences.getInstance();
await widget.authServices.registerUser(username, password);

    pref.setString('username', username);

  Future.delayed(const  Duration(milliseconds: 3)).whenComplete(() =>    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>const ResponsiveChatScreen(),), (Route<dynamic> route) => false ));
     
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           backgroundColor: Color.fromARGB(255, 205, 247, 233),
      body: LayoutBuilder(
        builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth>600;
          return Center(
          child: Container(
          margin: EdgeInsets.all(8),
                  height:  isWideScreen ? 500 : 400,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only( bottomRight:Radius.circular(30),topLeft:  Radius.circular(30))),
           
            width:isWideScreen ? 500 : constraints.maxWidth,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

               const Text("Sign Up", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
            
                Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                    
                        labelText: "username", border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid))),
                      controller: usernameController,
                    ),
                    SizedBox(height: 20,),
                                
                      TextFormField(controller: passwordController,
                      decoration:const  InputDecoration(
                         floatingLabelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                        labelText: "password", border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid))),
                      ),
                  ],
                ),
                        

                  InkWell(
                    onTap: signupUser,
                    child: Container(
          
                      height: 50,width: 180,
                      decoration: BoxDecoration(
                                    color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child:const Center(child:   Text("Sign Up", style: TextStyle(fontSize: 20,color: Colors.white , fontWeight: FontWeight.bold),)),),
                  ),

              GestureDetector(
                onTap: () {
                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen(),), (Route<dynamic> route) => false );
                  //push(MaterialPageRoute(builder: (context) => LoginScreen(),));
                },
                child: RichText(text: const TextSpan(children: [
                  TextSpan(text: "Already have an account? ",style: TextStyle(color: Colors.grey)),
                  TextSpan(text: "\tLogin",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16) )
                ])),
              )
            
            ],),
          ),
        );
        },
       
       
      ),
    );
  }
}