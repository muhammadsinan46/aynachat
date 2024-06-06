import 'package:aynachat/model/models.dart';
import 'package:aynachat/screens/responsive_screen.dart';
import 'package:aynachat/services/auth_Services.dart';
import 'package:aynachat/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  AuthServices? auth;
  Box<User>? userBox;

  LoginScreen({super.key, this.auth, this.userBox});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  bool isLoading =false;

  checkUserLoggedIn()async{
     SharedPreferences pref = await SharedPreferences.getInstance();
     String ?username = pref.getString('username');

     if(username!=null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveChatScreen(),));
      
     }


  }

  void loginUser() async {

    setState(() {
      isLoading =true;
    });
    final username = usernameController.text;
    final password = passwordController.text;

    if (widget.auth == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Auth service is not available. Please try again later.")));

              setState(() {
                isLoading =false;
              });
      return;
    }
try{
   SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', username);

    final user =  widget.auth!.authentication(username, password);

  

    if (user != null) {
       Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const ResponsiveChatScreen(),
              ),
              (Route<dynamic> route) => false)
;    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("invalid usename and password. please try agian")));
    }

}catch (e){
   ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}"))
      );
}finally{
  setState(() {
    isLoading =false;
  });
}
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 205, 247, 233),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;
          return Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              height: isWideScreen ? 500 : 400,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              width: isWideScreen ? 500 : constraints.maxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Log In",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Column(
                
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            labelText: "username",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.solid))),
                        controller: usernameController,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        floatingLabelStyle: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "password",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid))),
                  ),
                    ],
                  ),
                  
                  InkWell(
                    onTap:isLoading ? null : loginUser,
                    child: Container(
                      height: 50,
                      width: 180,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                        "Log In",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp(authServices: widget.auth?? AuthServices(widget.userBox!),),));

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            SignUp(authServices: widget.auth!),
                      ));
                    },
                    child: RichText(
                        text: const TextSpan(children: [
                      TextSpan(
                          text: "New user? ",
                          style: TextStyle(color: Colors.grey)),
                      TextSpan(
                          text: "\tSign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16))
                    ])),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
