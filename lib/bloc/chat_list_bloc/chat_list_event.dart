part of 'chat_list_bloc.dart';

abstract class ChatListEvent  {
  const ChatListEvent();

  List<Object> get props => [];
}


class ChatlistLoadingEvent extends ChatListEvent{}
class ChatlistLoadEvent extends ChatListEvent{

  final ChatSession chatSession;

  const ChatlistLoadEvent(this.chatSession);

  @override
  List<Object> get props =>[chatSession];
}
