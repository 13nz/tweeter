import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/apis/auth_api.dart';
import 'package:twitter/apis/user_api.dart';
import 'package:twitter/core/utils.dart';
import 'package:twitter/features/auth/view/signup_view.dart';
import 'package:twitter/features/home/view/home_view.dart';
import 'package:appwrite/models.dart' as model;
import 'package:twitter/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authAPI: ref.watch(authAPIProvider), userAPI: ref.watch(userAPIProvider));
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentuser();
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

class AuthController extends StateNotifier<bool> {
  //bool isLoading
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<model.Account?> currentuser() => _authAPI.currentUserAccount();

  void signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // state = isLoading
    state = true;
    final res = await _authAPI.signup(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
            email: email,
            name: getNameFromEmail(email),
            followers: const [],
            following: const [],
            profilePic: '',
            bannerPic: '',
            uid: r.$id,
            bio: '',
            isTwitterBlue: false);
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Account created. Please login.');
          Navigator.push(context, SignupView.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // state = isLoading
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);

    return updatedUser;
  }
}
