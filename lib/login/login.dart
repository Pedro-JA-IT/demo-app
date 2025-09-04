import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fade_in_animation/fade_in_animation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }
    isLoading = true;
    setState(() {});
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      final userInfoDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final docSnapshot = await userInfoDocRef.get();

      if (!docSnapshot.exists || !docSnapshot.data()!.containsKey('role')) {
        await userInfoDocRef.set({
          'id': user.uid,
          'userName': user.displayName ?? 'N/A',
          'Email': user.email ?? 'N/A',
          'role': 'user',
        }, SetOptions(merge: true));
      }
    }
    isLoading = false;
    setState(() {});
    Navigator.of(context).pushReplacementNamed("homepage");
    return userCredential;
  }

  late GlobalKey<FormState> passwd = GlobalKey();
  late TextEditingController eml;
  late TextEditingController pass;
  late bool see = true;
  bool showEmailCloseIcon = false;
  bool showPasswordCloseIcon = false;
  bool isLoading = false;
  List text = [
    "Email Canno't Be Empty",
    "Password Canno't Be Empty",
    "Email and Password Cannot Be Empty"
  ];
  GlobalKey<FormState> form = GlobalKey();

  late GlobalKey<FormState> login;
  @override
  void initState() {
    eml = TextEditingController();
    pass = TextEditingController();
    passwd = GlobalKey();

    super.initState();
  }

  @override
  void dispose() {
    eml.dispose();
    pass.dispose();
    super.dispose();
  }

  void validateFields() {
    setState(() {
      showEmailCloseIcon = eml.text.isEmpty;
      showPasswordCloseIcon = pass.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    final sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: form,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/background.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    //to be continued...
                    Positioned.fill(
                      child: Container(
                        foregroundDecoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.black87,
                              Colors.black45,
                              Colors.black12,
                              Colors.black38,
                              Colors.black54,
                              Colors.black
                            ],
                          ),
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    /////////////////////sign in///////////////////////////////////
                    Positioned(
                      top: sheight * 0.078,
                      left: swidth * 0.074,
                      child: FadeInAnimation(
                          delayIndex: 1,
                          forwardCurve: Curves.easeOutCubic,
                          animationType: AnimationType.scaleTranslate,
                          scaleFactor: .9,
                          animationDuration: 1000,
                          direction: AnimationDirection.rightward,
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    ////////////////////welcome back////////////////////////

                    Positioned(
                        top: sheight * 0.175,
                        left: swidth * 0.08,
                        right: swidth * 0.299,
                        child: FadeInAnimation(
                            delayIndex: 1,
                            forwardCurve: Curves.easeOutCubic,
                            animationType: AnimationType.scaleTranslate,
                            scaleFactor: .9,
                            animationDuration: 1000,
                            direction: AnimationDirection.rightward,
                            delayFactor: 400,
                            child: FittedBox(
                              child: const Text(
                                "Welcome back",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))),
                    //////////////////email////////////////////////////////

                    Positioned(
                      top: sheight * 0.388,
                      left: swidth * 0.1,
                      right: swidth * 0.1,
                      bottom: sheight * 0.55,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        //height: 45,
                        width: 300,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 2),
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromRGBO(255, 255, 255, 0.9),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            if (showEmailCloseIcon) {
                              setState(() {
                                showEmailCloseIcon = val.isEmpty;
                              });
                            }
                          },
                          controller: eml,
                          maxLines: 1,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              size: 20,
                            ),
                            suffixIcon: showEmailCloseIcon
                                ? FadeInAnimation(
                                    direction: AnimationDirection.upward,
                                    animationType: AnimationType.scale,
                                    scaleFactor: .9,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  )
                                : null,
                            // contentPadding:
                            //     const EdgeInsets.only(left: 15, top: 8),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: "E-mail",
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),

                    /////////////////////////////////password//////////////////////////////////
                    Positioned(
                      top: sheight * 0.468,
                      left: swidth * 0.1,
                      right: swidth * 0.1,
                      bottom: sheight * 0.468,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 300,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 2),
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromRGBO(255, 255, 255, 0.9),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            if (showPasswordCloseIcon) {
                              setState(() {
                                showPasswordCloseIcon = val.isEmpty;
                              });
                            }
                          },
                          controller: pass,
                          maxLines: 1,
                          obscureText: see,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 20,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showPasswordCloseIcon)
                                  FadeInAnimation(
                                    direction: AnimationDirection.upward,
                                    animationType: AnimationType.scale,
                                    scaleFactor: .9,
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      see = !see;
                                    });
                                  },
                                  icon: Icon(
                                    see
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            // contentPadding:
                            //     const EdgeInsets.only(left: 15, top: 8),
                            errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Password",
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ////////////////////////////////////////login button//////////////////////////////////
                    Positioned(
                      top: sheight * 0.56,
                      left: swidth * 0.268,
                      right: swidth * 0.268,
                      bottom: sheight * 0.38,
                      child: MaterialButton(
                        minWidth: 200,
                        //height: 40,
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () async {
                          validateFields();
                          if (showEmailCloseIcon || showPasswordCloseIcon) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              showCloseIcon: true,
                              closeIconColor: Colors.red,
                              content: Text(
                                showEmailCloseIcon && showPasswordCloseIcon
                                    ? text[2]
                                    : showEmailCloseIcon
                                        ? text[0]
                                        : text[1],
                              ),
                            ));
                            return;
                          }

                          try {
                            isLoading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: eml.text
                                  .trim(), // Added trim() to remove whitespace
                              password: pass.text,
                            );

                            // Fetch user role after successful login
                            if (credential.user != null) {
                              final userDoc = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(credential.user!.uid)
                                  .get();
                              if (userDoc.exists &&
                                  !userDoc.data()!.containsKey('role')) {
                                // If role doesn't exist, set default to 'user'
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(credential.user!.uid)
                                    .set({'role': 'user'},
                                        SetOptions(merge: true)); //
                              }
                            }

                            isLoading = false;
                            setState(() {});
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "homepage", (route) => false);
                          } on FirebaseAuthException catch (e) {
                            isLoading = false;
                            setState(() {});

                            print('Full Error: $e'); // More detailed logging

                            // Handle specific error cases
                            if (e.code == 'user-not-found') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'No account found with this email',
                                btnOkOnPress: () {},
                              ).show();
                            } else if (e.code == 'wrong-password' ||
                                e.code == 'invalid-credential') {
                              // Added 'invalid-credential' to catch more cases
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Incorrect Password',
                                desc:
                                    'The password you entered is wrong. Please try again.',
                                btnOkOnPress: () {},
                              ).show();
                            } else if (e.code == 'invalid-email') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Invalid Email',
                                desc: 'The email format is incorrect',
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'An error occurred: ${e.message}',
                                btnOkOnPress: () {},
                              ).show();
                            }
                          } catch (e) {
                            isLoading = false;
                            setState(() {});
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Unexpected Error',
                              desc: 'Something went wrong. Please try again.',
                              btnOkOnPress: () {},
                            ).show();
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    //////////////////////forgot your password/////////////////////////////
                    Positioned(
                        top: sheight * 0.64,
                        left: swidth * 0.326,
                        right: swidth * 0.326,
                        child: InkWell(
                          onTap: () async {
                            if (eml.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Email Cannot Be Empty',
                                btnOkColor: Colors.orange,
                                btnOkOnPress: () {},
                              ).show();
                              return;
                            }
                            try {
                              isLoading = true;
                              setState(() {});
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: eml.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Requset Confirmed',
                                desc: 'Hit you\'r Email And Reset The password',
                                btnOkOnPress: () {},
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Error',
                                      desc: 'Account Doesn\'t Exists',
                                      btnOkOnPress: () {},
                                      btnOkColor: Colors.orange)
                                  .show();
                            }
                            isLoading = false;
                            setState(() {});
                          },
                          child: const FittedBox(
                            child: Text(
                              "Forgot your password?",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        )),
                    /////////////////////////// or  continue///////////////////////////
                    Positioned(
                        top: sheight * 0.646,
                        left: swidth * 0.14,
                        right: swidth * 0.14,
                        bottom: sheight - (sheight * 0.84),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 1,
                                  width: 75,
                                  color: Colors.white70,
                                ),
                                const Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: 75,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            MaterialButton(
                              height: 50,
                              color: Colors.deepOrangeAccent,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              minWidth: 300,
                              animationDuration:
                                  const Duration(milliseconds: 10),
                              onPressed: () {
                                signInWithGoogle();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sign in with Google     "),
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          child: Image.asset(
                                            "assets/images.png",
                                            fit: BoxFit.fill,
                                          )))
                                ],
                              ),
                            )
                          ],
                        )),
                    //////////////////////////////////dont have account////////////////////////////////
                    Positioned(
                        top: sheight * 0.88,
                        left: swidth * 0.266,
                        right: swidth * 0.266,
                        child: FittedBox(
                            child: Row(children: [
                          const Text(
                            "Don't have an account ?",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("signup");
                            },
                            child: const Text(
                              " Sign up",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ]))),
                  ],
                ),
              ),
            ),
            if (isLoading)
              Positioned(
                top: sheight * 0.0,
                left: swidth * 0.0,
                right: swidth * 0.0,
                bottom: sheight * 0.0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
