part of 'chat_message_bloc.dart';

sealed class ChatMessageState extends Equatable {
  const ChatMessageState();
  
  @override
  List<Object> get props => [];
}


final class ChatInitial extends ChatMessageState {}

class ChatConnected extends ChatMessageState{

  final String userId;
  final List<Message> messages;
 const ChatConnected( this.userId, {this.messages =const []});

 @override
  List<Object> get props =>[userId, messages];

}

