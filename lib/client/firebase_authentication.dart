import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var logger = Logger();

final userIdProvider = StateProvider<String?>((ref) => null);
final firebaseAuthStateProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.userChanges());

Future<UserCredential?> createAccount(
    String email, String password, WidgetRef ref) async {
  // UserCredential
  //  (additionalUserInfo:
  //    AdditionalUserInfo
  //      (isNewUser: true,
  //        profile: {},
  //        providerId: null,
  //        username: null,
  //        authorizationCode: null),
  //  credential: null,
  //  user:
  //    User
  //      ( displayName: null,
  //        email: test2@gmail.com,
  //        isEmailVerified: false,
  //        isAnonymous: false,
  //        metadata: UserMetadata(creationTime: 2023-11-10 01:33:22.715Z, lastSignInTime: 2023-11-10 01:33:22.715Z),
  //        phoneNumber: null,
  //        photoURL: null,
  //        providerData,
  //        [UserInfo
  //          (displayName: null,
  //            email: test2@gmail.com,
  //            phoneNumber: null,
  //            photoURL: null,
  //            providerId: password,
  //            uid: test2@gmail.com)],
  //        refreshToken: null,
  //        tenantId: null,
  //        uid: wFWS4ZF9ChcxLLk9Y2vLtixyWiw1))
  UserCredential? credential;
  try {
    /// credential にはアカウント情報が記録される
    credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    logger.d(credential.user!.uid);
    ref.watch(userIdProvider.notifier).state = credential.user!.uid;
  }

  /// アカウントに失敗した場合のエラー処理
  on FirebaseAuthException catch (e) {
    /// パスワードが弱い場合
    if (e.code == 'weak-password') {
      logger.d('パスワードが弱いです');

      /// メールアドレスが既に使用中の場合
    } else if (e.code == 'email-already-in-use') {
      logger.d('すでに使用されているメールアドレスです');
    }

    /// その他エラー
    else {
      logger.d('アカウント作成エラー');
    }
  } catch (e) {
    logger.d(e);
  }
  return credential;
}

Future<UserCredential?> signIn(String id, String pass, WidgetRef ref) async {
  UserCredential? credential;
  try {
    // credential にはアカウント情報が記録される
    credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: id,
      password: pass,
    );
    logger.d(credential!.user!.uid);
    ref.watch(userIdProvider.notifier).state = credential.user!.uid;
  } on FirebaseAuthException catch (e) {
    // サインインに失敗した場合のエラー処理
    // メールアドレスが無効の場合
    if (e.code == 'invalid-email') {
      logger.d('メールアドレスが無効です');
    }

    /// ユーザーが存在しない場合
    else if (e.code == 'user-not-found') {
      logger.d('ユーザーが存在しません');
    }

    /// パスワードが間違っている場合
    else if (e.code == 'wrong-password') {
      logger.d('パスワードが間違っています');
    }

    /// その他エラー
    else {
      logger.d(e);
      logger.d('サインインエラー');
    }
  }
  return credential;
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
