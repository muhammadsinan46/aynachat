import 'dart:async';

import 'package:aynachat/model/models.dart';
import 'package:aynachat/services/websocket.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
 late WebSocketService websocket;
   late StreamSubscription _messageSubscription;
 
  ChatMessageBloc() : super(ChatInitial()) {

    on<ChatConnectEvent>(onConnect);
    on<ChatSendEvent>(onSentMessage);
    on<ChatReceivedEvent>(onReceiveMessage);
  }

  FutureOr<void> onConnect(ChatConnectEvent event, Emitter<ChatMessageState> emit) async{

   websocket=WebSocketService('wss://echo.websocket.org',event.userId );
    await websocket.ensureOpen();
 
  _messageSubscription = websocket.messages.listen((message){

   
  add(ChatReceivedEvent(message));
});

final messages = await websocket.getMessages();
Future.delayed(Duration(milliseconds: 3));
  emit(ChatConnected(event.userId, messages: messages));
  }

  FutureOr<void> onSentMessage(ChatSendEvent event, Emitter<ChatMessageState> emit) {
 
    
    websocket.sendMessage(event.sentMessage);
    if(state is ChatConnected){
      final message = List<Message>.from((state as ChatConnected).messages)..add(event.sentMessage);



      emit(ChatConnected((state as ChatConnected).userId,messages: message),);
    }
  }

  FutureOr<void> onReceiveMessage(ChatReceivedEvent event, Emitter<ChatMessageState> emit) {
    if(state is ChatConnected){
      final message = List<Message>.from((state as ChatConnected).messages)..add(event.receivedMessage);
   

      emit(ChatConnected((state as ChatConnected).userId, messages: message));
    }
  }



@override
  Future<void> close(){
_messageSubscription.cancel();
websocket.dispose();
    return super.close();
  }
}
