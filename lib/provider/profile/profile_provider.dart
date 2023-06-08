// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fb_auth/models/custom_error.dart';
import 'package:flutter/material.dart';

import 'package:fb_auth/provider/profile/profile_state.dart';
import 'package:fb_auth/repositories/profile_repository.dart';

import '../../models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  ProfileState _state = ProfileState.initial();
  ProfileState get state => _state;
  final ProfileRepository profileRepository;
  ProfileProvider({
    required this.profileRepository,
  });
  Future<void> getProfile({required String uid}) async {
    _state = _state.copyWith(profileStatus: ProfileStatus.loading);
    notifyListeners();
    try {
      // ignore: unused_local_variable
      final User user = await profileRepository.getProfile(uid: uid);
    } on CustomError catch (e) {
      _state = _state.copyWith(profileStatus: ProfileStatus.error, error: e);
      notifyListeners();
    }
  }
}
