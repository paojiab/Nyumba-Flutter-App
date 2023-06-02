import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

class firebaseAuth {
  Future<void> verifyEmail() async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  Future resetPassword(email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future signUp(String email, String password, String name) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await auth.currentUser?.updateDisplayName(name);
      verifyEmail();
      return "user-created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email';
      }
    } catch (e) {
      print(e);
      return "Unknown error";
    }
  }

  signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "user-found";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      }
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Map<String, dynamic> getUser() {
    final String? id = auth.currentUser?.uid;
    final String? name = auth.currentUser?.displayName;
    final String? email = auth.currentUser?.email;
    final String? photo = auth.currentUser?.photoURL;
    final String? phone = auth.currentUser?.phoneNumber;
    final bool? emailVerified = auth.currentUser?.emailVerified;
    final user = {
      "id": id,
      "name": name,
      "email": email,
      "photo": photo,
      "phoneNumber": phone,
      "emailVerified": emailVerified
    };
    return user;
  }

  Future<bool> updateUser(
      String? name, String? photo, String email, String password) async {
    try {
      await signIn(email, password);
      await auth.currentUser?.updateDisplayName(name);
      await auth.currentUser?.updatePhotoURL(photo);
      await auth.currentUser?.updateEmail(email);
      await auth.currentUser?.updatePassword(password);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  passwordReset(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<bool> deleteUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await auth.currentUser?.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
