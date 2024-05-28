import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ma_bibliotheque_flutter/screens/home_screen.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final bool isNewUser = userCredential.additionalUserInfo!.isNewUser;
        if (isNewUser) {
          // Ajouter les données de l'utilisateur dans Firestore
          await FirebaseFirestore.instance.collection('lecteur').doc(user.uid).set({
            'nom': user.displayName?.split(" ").last,
            'prenom': user.displayName?.split(" ").first,
            'date_de_naissance': null, // Remplacer par une valeur réelle si disponible
            'email': user.email,
            'pass_word': null, // Le mot de passe n'est pas requis pour les connexions Google
          });
        }

        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }
}
