import 'package:aynachat/bloc/chat_list_bloc/chat_list_bloc.dart';

import 'package:aynachat/screens/chat_room.dart';
import 'package:aynachat/screens/login.dart';

import 'package:aynachat/model/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {


  ChatScreen({super.key, });


var receiverNameController =TextEditingController();


  @override
  Widget build(BuildContext context) {

  
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 230, 239),
      appBar: AppBar( 
        backgroundColor: Colors.black,
        title:const  Text("Ayna Chat",),titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),actions: [ CircleAvatar(
          child: IconButton(onPressed: (){
          showDialog(context: context, builder: (context) => AlertDialog(title:const Text("Log out"),content: Text("Are you sure to logout?"),actions: [
            InkWell(
              onTap: (){logout(context);},
              child: Container(
                decoration: BoxDecoration(borderRadius:BorderRadius.circular(5),color: Colors.black),
                height:30 ,width: 70,child: Center(child: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16),)),),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(height:30 ,width: 70,
                decoration: BoxDecoration(borderRadius:BorderRadius.circular(5), border: Border.all()),child: const Center(child: Text("Cancel")),
              ),
            )
          ],),);
                }, icon:const Icon(Icons.person)),
        )],),
      body:
      LayoutBuilder(
        builder: (context, constraints) {
          
          return BlocBuilder<ChatListBloc, ChatListState>(builder: (context, state) {
        
          if(state is ChatListInitial){
            return const CircularProgressIndicator();
          }else if(state is ChatListLoaded){
            final chats = state.chatlist;
            return     ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
        
            final session = chats[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
               ChatRoom(receiverId: session.id,receiverName: session.name,),));
            },
            child:   Card(
              child: ListTile(
                leading:const  CircleAvatar(child: Icon(Icons.person),),
                title:Text(session.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),)
              ),
            ));
        },) ;
          }else if(state is ChatListFailure){
            return Text("failed to load session");
          }
         return Container();
        },);
        },
        
      ),
      
  

floatingActionButton: FloatingActionButton(onPressed: (){
  newChat(context);
} ,child: Icon(Icons.person_add_alt),),
    );
    
  }
  


  logout(BuildContext context)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('username');
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
  }
  
  void deleteSession(String sessionName) {
 Hive.deleteBoxFromDisk(sessionName);
  }
  
  void newChat(BuildContext context) {
 
    showModalBottomSheet(context: context, builder: (builder){
      return Container(
        padding: EdgeInsets.all(8),
        height: 200,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
         const  SizedBox(height: 20,),
          TextFormField(controller: receiverNameController,decoration: const InputDecoration(border: OutlineInputBorder()),),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                     final sessionBox =Hive.box<ChatSession>('sessions');
                     final newChat = ChatSession("100${sessionBox.length}", receiverNameController.text, );

                     context.read<ChatListBloc>().add(ChatlistLoadEvent(newChat));
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(color:Colors.blue , borderRadius: BorderRadius.circular(8)),
                height: 50,width: 100,child:const Center(child: Text("Add", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),)),),
            ),
          )
        ],)

      );
    });
  }
}