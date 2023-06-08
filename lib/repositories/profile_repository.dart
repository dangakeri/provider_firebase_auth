// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_auth/constants/db_constants.dart';
import 'package:fb_auth/models/custom_error.dart';

import '../models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;
  ProfileRepository({
    required this.firebaseFirestore,
  });
  Future<User> getProfile({required String uid}) async {
    try {
      final DocumentSnapshot userDoc = await userRef.doc(uid).get();
      final User currentUser = User.fromDoc(userDoc);
      return currentUser;
    } on FirebaseException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error');
    }
  }
}