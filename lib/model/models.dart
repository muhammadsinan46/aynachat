import 'package:hive/hive.dart';

part 'models.g.dart';


@HiveType(typeId: 0)
class User extends HiveObject{


@HiveField(0)
String username;

@HiveField(1)
String password;

User({required this.username, required this.password});

}

@HiveType(typeId: 1)
class Message extends HiveObject{


@HiveField(0)
String message;

@HiveField(1)
bool isSent;
Message({required this.message,required this.isSent});

factory Message.fromJson(Map<String, dynamic>json){
  return Message(message: json['message'] as String, isSent: json['isSent'] as bool);
}

Map<String , dynamic> toJson(){
  return{
    'message':message,
    'isSent':isSent
  };
}

}

@HiveType(typeId: 2)
class ChatSession extends HiveObject{


@HiveField(0)
String id;

@HiveField(1)
String name;




ChatSession(this.id, this.name);

}