import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipic/models/constants.dart';
import 'package:recipic/models/user.dart';
import 'package:recipic/services/database.dart';

class AuthService {

  FirebaseAuth _auth;
  String currentUserID;

  AuthService() {
    this._auth = FirebaseAuth.instance;
    this.currentUserID = "";
  }

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    if (user != null) {
      Constants().setCurrentUserID(user.uid);
      log("_userFromFirebaseUser(FirebaseUser user) : currentUserID = ${Constants().getCurrentUserID()}");
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
      Constants().setCurrentUserID(user.uid);
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

      Constants().setCurrentUserID(user.uid);

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

      Constants().setCurrentUserID(user.uid);
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