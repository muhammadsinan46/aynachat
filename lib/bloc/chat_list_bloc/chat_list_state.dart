part of 'chat_list_bloc.dart';

sealed class ChatListState  {
  const ChatListState();
  
  List<Object> get props => [];
}

final class ChatListInitial extends ChatListState {}
final class ChatListLoaded extends ChatListState {
  final List<ChatSession> chatlist;

  const ChatListLoaded(this.chatlist);

  @override
  List<Object> get props =>[chatlist];

}
final class ChatListFailure extends ChatListState {}
