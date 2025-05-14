import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> requestTrackingPermission() async {
    try {
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      print('Статус відстеження: $status');
    } catch (e) {
      print('Помилка запиту відстеження: $e');
    }
  }

  AuthBloc() : super(AuthInitial()) {
    on<CheckUserAuthStatus>((event, emit) async {
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
    on<LoginRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(userCredential.user!));
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        debugPrint('FirebaseAuthException: ${e.code}');

        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Користувача з такою поштою не знайдено';
            break;
          case 'wrong-password':
            errorMessage = 'Неправильний пароль';
            break;
          case 'invalid-credential':
            errorMessage = 'Не вірний email або пароль';
            break;
          case 'user-disabled':
            errorMessage = 'Цей акаунт деактивовано';
            break;
          default:
            errorMessage = 'Сталася помилка. Спробуйте ще раз.';
        }
        emit(AuthError(errorMessage));
      } catch (e) {
        debugPrint('Unknown error: $e');
        emit(AuthError('Невідома помилка. Спробуйте пізніше.'));
      }
    });
    on<RegisterRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );
        emit(AuthAuthenticated(userCredential.user!));
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
                'Цей email вже використовується. Спробуйте увійти або використайте інший email.';
            break;
          case 'invalid-email':
            errorMessage = 'Невірний формат email.';
            break;
          case 'weak-password':
            errorMessage =
                'Занадто слабкий пароль. Використовуйте хоча б 6 символів, великі та малі літери, цифри та спецсимволи.';
            break;
          case 'operation-not-allowed':
            errorMessage =
                'Реєстрація через email наразі вимкнена. Зверніться до підтримки.';
            break;
          case 'too-many-requests':
            errorMessage = 'Забагато спроб. Спробуйте пізніше.';
            break;
          default:
            errorMessage =
                'Сталася помилка. Спробуйте ще раз. Код помилки: ${e.code}';
        }
        emit(AuthError(errorMessage));
      } catch (e) {
        emit(AuthError("Error: $e"));
      }
    });
    on<LogoutRequest>((event, emit) async {
      emit(AuthLoading());
      emit(AuthUnauthenticated());
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
    });
    on<LoginViaGoogle>((event, emit) async {
      emit(AuthLoading());
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        UserCredential user = await _auth.signInWithCredential(credential);
        emit(AuthAuthenticated(user.user!));
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'account-exists-with-different-credential':
            errorMessage =
                'Обліковий запис вже існує з іншими обліковими даними.';
            break;
          case 'invalid-credential':
            errorMessage = 'Невірні облікові дані Google. Спробуйте ще раз.';
            break;
          case 'user-disabled':
            errorMessage = 'Цей акаунт було деактивовано.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Вхід через Google наразі вимкнено.';
            break;
          case 'network-request-failed':
            errorMessage =
                'Помилка мережі. Перевірте підключення до інтернету.';
            break;
          default:
            errorMessage = 'Сталася помилка. Спробуйте ще раз. Код: ${e.code}';
        }
        emit(AuthError(errorMessage));
      } on PlatformException catch (e) {
        if (e.code == 'sign_in_failed') {
          emit(
            AuthError(
              "Доступ до акаунта відхилено. Будь ласка, спробуйте ще раз.",
            ),
          );
        } else {
          emit(AuthError("Помилка платформи: ${e.message}"));
        }
      } catch (e) {
        emit(AuthError("Невідома помилка: $e"));
      }
    });
    on<LoginViaFacebook>((event, emit) async {
      emit(AuthLoading());
      try {
        await AppTrackingTransparency.requestTrackingAuthorization();

        final LoginResult result = await FacebookAuth.instance.login(
          loginBehavior: LoginBehavior.webOnly,
        );
        if (result.status == LoginStatus.success) {
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
          emit(AuthAuthenticated(userCredential.user!));
        } else if (result.status == LoginStatus.cancelled) {
          emit(AuthUnauthenticated());
        } else {
          emit(AuthError(result.message ?? 'Facebook login failed'));
        }
      } catch (e) {
        emit(AuthError('Facebook login error: $e'));
      }
    });
    on<ClearAuthData>((event, emit) {
      emit(AuthInitial());
    });
  }
}
