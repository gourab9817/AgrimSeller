import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../models/auth_exception.dart';
import 'dart:io';
// Add your Firebase imports here
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      if (_auth.currentUser == null) {
        throw AuthException(code: 'user-not-logged-in', message: 'User not logged in');
      }
      final userId = _auth.currentUser!.uid;
      final storageRef = _storage.ref().child('buyersprofilepicture').child(userId);
      final uploadTask = storageRef.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
      final snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        await _firestore.collection('buyers').doc(userId).update({'profilePictureUrl': downloadUrl});
        return downloadUrl;
      } else {
        throw Exception('Upload failed with state: ${snapshot.state}');
      }
    } catch (e, st) {
      developer.log('FirebaseService: Error uploading profile picture: $e', error: e, stackTrace: st);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchListedCrops() async {
    try {
      final querySnapshot = await _firestore.collection('Listed crops').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e, st) {
      developer.log('FirebaseService: Error fetching listed crops: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> createClaimedListing({
    required String farmerId,
    required String buyerId,
    required DateTime claimedDateTime,
    required String listingId,
  }) async {
    try {
      final docRef = _firestore.collection('claimedlist').doc();
      await docRef.set({
        'id': docRef.id,
        'farmerId': farmerId,
        'buyerId': buyerId,
        'claimedDateTime': claimedDateTime.toIso8601String(),
        'listingId': listingId,
      });
    } catch (e, st) {
      developer.log('FirebaseService: Error creating claimed listing: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> updateCropClaimedStatus({
    required String listingId,
    required bool claimed,
  }) async {
    try {
      await _firestore.collection('Listed crops').doc(listingId).update({'claimed': claimed});
    } catch (e, st) {
      developer.log('FirebaseService: Error updating crop claimed status: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> fetchFarmerDataById(String farmerId) async {
    try {
      final doc = await _firestore.collection('farmers').doc(farmerId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e, st) {
      developer.log('FirebaseService: Error fetching farmer data: $e', error: e, stackTrace: st);
      return null;
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
