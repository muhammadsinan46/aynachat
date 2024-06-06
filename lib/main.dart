
import 'package:aynachat/bloc/chat_message_bloc/chat_message_bloc.dart';
import 'package:aynachat/bloc/chat_list_bloc/chat_list_bloc.dart';

import 'package:aynachat/screens/chat_screen.dart';
import 'package:aynachat/screens/login.dart';
import 'package:aynachat/model/models.dart';
import 'package:aynachat/services/auth_Services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ChatSessionAdapter());
  SharedPreferences pref =await SharedPreferences.getInstance();
  var email = pref.getString('username');

  final userBox = await Hive.openBox<User>('users');
  final sessionBox = await Hive.openBox<ChatSession>('sessions');
 final chatBox= await Hive.openBox<Message>('messages');

  runApp(MyApp(
    isLogged: email,
    authServices: AuthServices(userBox),
    sessionBox: sessionBox,
    chatBox: chatBox,
  ));
}

class MyApp extends StatelessWidget {

  MyApp({super.key, required this.authServices, required this.sessionBox, required this.isLogged, required this.chatBox});

  String? isLogged;
  final AuthServices authServices;
  final Box<ChatSession> sessionBox;
  final Box<Message> chatBox;
  

  @override
  Widget build(BuildContext context) {
  
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatListBloc(sessionBox)..add(ChatlistLoadingEvent()),),
        BlocProvider(create: (context) => ChatMessageBloc(),)
       
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home:LoginScreen(auth: authServices,)
          
     
           
           ),
    );
  }
}
