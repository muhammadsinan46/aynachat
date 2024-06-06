part of 'chat_message_bloc.dart';

sealed class ChatMessageEvent extends Equatable {
  const ChatMessageEvent();

  @override
  List<Object> get props => [];
}


class ChatConnectEvent extends ChatMessageEvent{
  final String userId;
  const ChatConnectEvent(this.userId);
}

class ChatSendEvent extends ChatMessageEvent{
  final Message sentMessage;


  const ChatSendEvent(this.sentMessage,);

  @override
  List<Object> get props =>[sentMessage];
}

class ChatReceivedEvent extends ChatMessageEvent{
  final Message receivedMessage;

  const ChatReceivedEvent(this.receivedMessage);

  @override
  List<Object> get props =>[receivedMessage];

}