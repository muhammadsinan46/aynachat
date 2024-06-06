import 'dart:convert';

import 'package:aynachat/model/models.dart';
import 'package:hive/hive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

   Box<Message>? _chatBox;

   final String receiverId;

  WebSocketService(String url,  this.receiverId)
      : channel = WebSocketChannel.connect(Uri.parse(url)){
             openChatBox(receiverId);
      }
     //   _chatBox = Hive.box<Message>('messages');
  openChatBox(String receiverId)async{
      _chatBox =await Hive.openBox<Message>('messages $receiverId');
  }

  Stream<Message> get messages async*{


    await for (var message in channel.stream){

      await ensureOpen();
       try{
         if (message.startsWith('{') || message.startsWith('[')) {
        final jsonMessage = jsonDecode(message);
        print('Decoded JSON message: $jsonMessage'); 
        final receivedMessage = Message.fromJson(jsonMessage);
        await _savedMessage(receivedMessage,isSent: false );
        yield receivedMessage;
      } 
    }catch(e){
      print("error in $e");
      
    }

    }
  }
  
 




  sendMessage(Message message) {

   final encodeMessage  = jsonEncode(message); 

    channel.sink.add(encodeMessage);

    _savedMessage(message, isSent: true);
  }

 Future<void> _savedMessage(Message message,{required bool isSent} )async {
  
    await ensureOpen();

        final newMessage =Message(message: message.message, isSent: isSent);
  
    _chatBox!.add(newMessage);
      
  }

  Future <List<Message>>getMessages()async {
    await ensureOpen();
  
    return _chatBox?.values.toList() ??[];
  }

  ensureOpen()  async {

    if(_chatBox==null || !_chatBox!.isOpen){
       _chatBox =await Hive.openBox<Message>('messages $receiverId');
    }

  }

  void dispose() {
    channel.sink.close();
  }
  
  
}
