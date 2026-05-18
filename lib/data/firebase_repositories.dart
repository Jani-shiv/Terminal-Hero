import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/models/user_profile.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// Firebase email sign-in wrapper kept out of UI widgets for clean architecture.
  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) throw StateError('Google sign-in cancelled');
    final googleAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();
}

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// All profile documents use the authenticated Firebase user id.
  DocumentReference<Map<String, dynamic>> _doc(String userId) {
    return _firestore.collection('users').doc(userId);
  }

  Future<void> upsert(UserProfile profile) {
    return _doc(profile.id).set(profile.toFirestore(), SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watch(String userId) {
    return _doc(userId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchLeaderboard() {
    return _firestore.collection('users').orderBy('xp', descending: true).limit(50).snapshots();
  }
}
