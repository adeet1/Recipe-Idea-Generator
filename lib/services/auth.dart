import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipic/models/user.dart';
import 'package:recipic/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    if (user != null) {
      return User(uid: user.uid);
    } else {
      return null;
    }
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      await DatabaseService(uid: user.uid).updateUserData("pizza", 1, "how to make pizza");
      await DatabaseService(uid: user.uid).updateUserData("burritos", 2, "how to make burritos");
      await DatabaseService(uid: user.uid).updateUserData("sandwiches", 3, "how to make sandwiches");

      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      user.sendEmailVerification();

      // create new user document in database, here

      return _userFromFirebaseUser(user);
    } catch(e){
      log(e.toString());
      return null;
    }
  }

  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}