import 'package:aynachat/bloc/chat_message_bloc/chat_message_bloc.dart';
import 'package:aynachat/model/models.dart';
import 'package:aynachat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ChatRoom extends StatelessWidget {
  String receiverName;
  String receiverId;
  ChatRoom({super.key, required this.receiverId, required this.receiverName});

  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    context.read<ChatMessageBloc>().add(ChatConnectEvent(receiverId));
    return LayoutBuilder(

      builder: (context, constraints) {
        if(constraints.maxWidth>600){
          return Row(
            children: [
                Expanded(
                flex: 1,
              child: ChatScreen()),
              Expanded(
                  flex:2,
                child: ChatRoomScreen(receiverName: receiverName, message: _message)),
            ],
          );
        }
         return ChatRoomScreen(receiverName: receiverName, message: _message);
      },
     
    );
  }
}

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({
    super.key,
    required this.receiverName,
    required TextEditingController message,
  }) : _message = message;

  final String receiverName;
  final TextEditingController _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text(receiverName),
    ),
    body: Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatMessageBloc, ChatMessageState>(
            builder: (context, state) {
              if (state is ChatInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ChatConnected) {
                return ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final messages = state.messages[index];
                    return Align(
                      alignment: messages.isSent
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: messages.isSent
                                ? Colors.blueAccent
                                : Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(messages.message, style:const  TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    );
          
                    // ListTile(title: Text(messages.message),subtitle: Text(messages.isSent?'Sent':'Received'));
                  },
                );
              }
              return const Center(
                child: Text("No message yet."),
              );
            },
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 70,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(
                  
                    child: TextField(
                  controller: _message,
                  decoration:
                      const InputDecoration(hintText: "Send a Message",hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
                )),
                IconButton(
                    onPressed: () {
                      final message =
                          Message(message: _message.text, isSent: true);
            
                      context
                          .read<ChatMessageBloc>()
                          .add(ChatSendEvent(message));
                      _message.clear();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        )
      ],
    ));
  }
}
