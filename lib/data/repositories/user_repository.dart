import 'dart:io';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';

class UserRepository {
  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;

  UserRepository(this._firebaseService, this._localStorageService);

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String address,
    required String idNumber,
  }) async {
    final user = await _firebaseService.signUpWithEmail(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      idNumber: idNumber,
    );
    await _localStorageService.saveUserData(user);
    return user;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _firebaseService.signInWithEmail(
      email: email,
      password: password,
    );
    await _localStorageService.saveUserData(user);
    return user;
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    await _localStorageService.clearUserData();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseService.resetPassword(email);
  }

  Future<UserModel?> getCurrentUser() async {
    return await _localStorageService.getUserData();
  }

  Future<bool> reloadUser() async {
    return await _firebaseService.reloadUser();
  }

  Future<void> sendEmailVerification() async {
    await _firebaseService.sendEmailVerification();
  }

  Future<bool> updateUserProfile(UserModel user) async {
    final result = await _firebaseService.updateUserProfile(user);
    if (result) {
      await _localStorageService.saveUserData(user);
    }
    return result;
  }

  Future<bool> uploadProfilePicture(File imageFile) async {
    final url = await _firebaseService.uploadProfilePicture(imageFile);
    if (url != null) {
      final user = await getCurrentUser();
      if (user != null) {
        final updatedUser = user.copyWith(profilePictureUrl: url);
        await _localStorageService.saveUserData(updatedUser);
      }
      return true;
    }
    return false;
  }
}
