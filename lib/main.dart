import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// ignore: unused_import
import 'package:todo_auth_app/pages/add_todo_page.dart';
import 'package:todo_auth_app/pages/home_page.dart';
import 'package:todo_auth_app/pages/sign_up_page.dart';
import 'package:todo_auth_app/service/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //
  // firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  //
  //
  //  void signUp() async{
  //
  //    try{
  //      await firebaseAuth.createUserWithEmailAndPassword(email: 'mohsinksr@gmail.com', password: '12345678');
  //    }
  //    catch (e){
  //      if (kDebugMode) {
  //        print(e);
  //      }
  //    }

  // }

  Widget currentPage = const SignUpPage();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }


  void checkLogin() async {
    String? token = await authClass.getToken();

    if (token != null){
      setState(() {
        currentPage = const HomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentPage,
    );
  }
}
