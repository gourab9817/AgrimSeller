import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/auth_exception.dart';
// Add your Firebase imports here
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isUserLoggedIn => currentUser != null;
  bool get isEmailVerified => currentUser?.emailVerified ?? false;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<bool> reloadUser() async {
    try {
      if (_auth.currentUser == null) return false;
      await _auth.currentUser!.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } catch (e, st) {
      developer.log('FirebaseService: Error in reloadUser: $e', error: e, stackTrace: st);
      throw AuthException(code: 'reload-failed', message: 'Failed to reload user data: $e');
    }
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String address,
    required String idNumber,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw AuthException(code: 'null-user', message: 'User creation failed');
      }
      final user = UserModel(
        uid: firebaseUser.uid,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        idNumber: idNumber,
        isEmailVerified: firebaseUser.emailVerified,
      );
      await _firestore.collection('buyers').doc(user.uid).set(user.toJson());
      return user;
    } on FirebaseAuthException catch (e, st) {
      developer.log('FirebaseService: Auth error during signup: ${e.code}', error: e, stackTrace: st);
      throw _handleFirebaseAuthException(e);
    } catch (e, st) {
      developer.log('FirebaseService: Unknown error during signup: $e', error: e, stackTrace: st);
      throw AuthException(code: 'unknown', message: e.toString());
    }
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final firebaseUser = cred.user;
      if (firebaseUser == null) {
        throw AuthException(code: 'null-user', message: 'Sign-in failed');
      }
      final docRef = _firestore.collection('buyers').doc(firebaseUser.uid);
      final snapshot = await docRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        data['isEmailVerified'] = firebaseUser.emailVerified;
        return UserModel.fromJson(data);
      } else {
        final minimal = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          isEmailVerified: firebaseUser.emailVerified,
        );
        await docRef.set(minimal.toJson(), SetOptions(merge: true));
        return minimal;
      }
    } on FirebaseAuthException catch (e, st) {
      developer.log('FirebaseService: Auth error during signin: ${e.code}', error: e, stackTrace: st);
      throw _handleFirebaseAuthException(e);
    } catch (e, st) {
      developer.log('FirebaseService: Unknown error during signin: $e', error: e, stackTrace: st);
      throw AuthException(code: 'unknown', message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e, st) {
      developer.log('FirebaseService: Error during signout: ${e.code}', error: e, stackTrace: st);
      throw _handleFirebaseAuthException(e);
    } catch (e, st) {
      developer.log('FirebaseService: Unknown error during signout: $e', error: e, stackTrace: st);
      throw AuthException(code: 'unknown', message: e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e, st) {
      developer.log('FirebaseService: Error sending reset: ${e.code}', error: e, stackTrace: st);
      throw _handleFirebaseAuthException(e);
    } catch (e, st) {
      developer.log('FirebaseService: Unknown error sending reset: $e', error: e, stackTrace: st);
      throw AuthException(code: 'unknown', message: e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
      await _auth.currentUser!.sendEmailVerification();
    }
  }

  Future<bool> updateUserProfile(UserModel user) async {
    try {
      if (_auth.currentUser == null || _auth.currentUser!.uid != user.uid) {
        throw AuthException(code: 'user-mismatch', message: 'Cannot update another user\'s profile');
      }
      await _firestore.collection('buyers').doc(user.uid).update(user.toJson());
      return true;
    } catch (e, st) {
      developer.log('FirebaseService: Error updating user profile: $e', error: e, stackTrace: st);
      return false;
    }
  }

  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException(code: e.code, message: 'No user found with this email.');
      case 'wrong-password':
        return AuthException(code: e.code, message: 'Incorrect password.');
      case 'invalid-email':
        return AuthException(code: e.code, message: 'Invalid email address.');
      case 'user-disabled':
        return AuthException(code: e.code, message: 'This user is disabled.');
      case 'email-already-in-use':
        return AuthException(code: e.code, message: 'Email already in use.');
      case 'operation-not-allowed':
        return AuthException(code: e.code, message: 'Operation not allowed.');
      case 'weak-password':
        return AuthException(code: e.code, message: 'Password is too weak.');
      case 'too-many-requests':
        return AuthException(code: e.code, message: 'Too many attempts; try again later.');
      default:
        return AuthException(code: e.code, message: e.message ?? 'Unknown auth error');
    }
  }
}
