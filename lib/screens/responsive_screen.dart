
import 'package:aynachat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ResponsiveChatScreen extends StatelessWidget {
  const ResponsiveChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: 
    (context, constraints) {

      if(constraints.maxWidth>600){
        return Scaffold(
          body: Row(children: [
            Expanded(
                flex: 1,
              child: ChatScreen()),
              Expanded(
                flex:2,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                child: ChatRoomPlaceholder()))
          ],),
        );
      }else{
        return ChatScreen();
      }
      
    }
    
    ,);
  }
}

class ChatRoomPlaceholder extends StatelessWidget {
  const ChatRoomPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Select a chat to start messaging",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}