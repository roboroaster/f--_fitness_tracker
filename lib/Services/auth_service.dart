import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  signInWithGoogle() async{
      // begin interactive signin process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      // obtain auth details from request
      final GoogleSignInAuthentication gAuth  = await gUser!.authentication;
      // create credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
      // then use cred to sign in
    }
  }
