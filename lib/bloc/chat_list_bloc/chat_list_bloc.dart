import 'dart:async';

import 'package:aynachat/model/models.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';


part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final Box<ChatSession> sessionBox;
  ChatListBloc(this.sessionBox) : super(ChatListInitial()) {
    on<ChatlistLoadingEvent>(sessionLoading);
    on<ChatlistLoadEvent>(loadChatSession);

  }
    FutureOr<void> sessionLoading(ChatlistLoadingEvent event, Emitter<ChatListState> emit) {

      emit(ChatListInitial());
      try{
        final session = sessionBox.values.toList();
        emit(ChatListLoaded(session.cast<ChatSession>()));

      }catch(_){
        emit(ChatListFailure());
      }
  }

  FutureOr<void> loadChatSession(ChatlistLoadEvent event, Emitter<ChatListState> emit) {
    sessionBox.add(event.chatSession);
    add(ChatlistLoadingEvent());
   
  }


}
