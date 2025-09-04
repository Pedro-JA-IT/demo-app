import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fade_in_animation/fade_in_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/homepage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController pp = TextEditingController();
  late TextEditingController ee = TextEditingController();
  late TextEditingController user = TextEditingController();
  late TextEditingController confpass = TextEditingController();
  GlobalKey<FormState> form = GlobalKey();
  late bool confirm, see1 = true, see2 = true;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  int i = 0;
  bool isLoading = false;
  @override
  void initState() {
    user = TextEditingController();
    confirm = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    final sheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Form(
            key: form,
            child: SizedBox(
                child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/background.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
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
                    //height: MediaQuery.of(context).size.height - 200,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                    ),
                  ),
                ),
                Positioned(
                    top: sheight * 0.24,
                    left: swidth * 0.1,
                    right: swidth * 0.24,
                    child: FittedBox(
                      child: FadeInAnimation(
                          delayIndex: 1,
                          forwardCurve: Curves.easeOutCubic,
                          animationType: AnimationType.scaleTranslate,
                          scaleFactor: .9,
                          animationDuration: 1000,
                          direction: AnimationDirection.rightward,
                          delayFactor: 400,
                          child: const Text(
                            "Welcome to our community",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )),
                Positioned(
                    top: sheight * 0.11,
                    left: swidth * 0.08,
                    // right: swidth * 0.24,
                    child: FittedBox(
                      child: FadeInAnimation(
                          delayIndex: 1,
                          forwardCurve: Curves.easeOutCubic,
                          animationType: AnimationType.scaleTranslate,
                          scaleFactor: .9,
                          animationDuration: 1000,
                          direction: AnimationDirection.rightward,
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )),
                //========================username========================
                Positioned(
                  top: sheight * 0.42,
                  left: swidth * 0.1,
                  right: swidth * 0.1,
                  child: FadeInAnimation(
                    direction: AnimationDirection.upward,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      //height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            //color: Colors.deepPurpleAccent,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      child: TextFormField(
                        controller: user,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          contentPadding: EdgeInsets.only(left: 15, top: 10),
                          errorBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "User-name",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //===========================Email==================
                Positioned(
                  top: sheight * 0.509,
                  left: swidth * 0.1,
                  right: swidth * 0.1,
                  child: FadeInAnimation(
                    direction: AnimationDirection.upward,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      // height: 45,
                      // width: 300,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            //color: Colors.deepPurpleAccent,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      child: TextFormField(
                        controller: ee,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          contentPadding: EdgeInsets.only(left: 15, top: 10),
                          errorBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "E-mail",
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //====================password======================
                Positioned(
                  top: sheight * 0.598,
                  left: swidth * 0.1,
                  right: swidth * 0.1,
                  child: FadeInAnimation(
                    direction: AnimationDirection.upward,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      //height: 45,
                      //width: 300,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            //color: Colors.deepPurpleAccent,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      child: TextFormField(
                        controller: pp,
                        maxLines: 1,
                        obscureText: see1,
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                see1 = !see1;
                              });
                            },
                            icon: Icon(
                              see1 ? Icons.visibility_off : Icons.visibility,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.only(left: 15, top: 8),
                          errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //====================re-password==================
                Positioned(
                  top: sheight * 0.687,
                  left: swidth * 0.1,
                  right: swidth * 0.1,
                  child: FadeInAnimation(
                    direction: AnimationDirection.upward,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            //color: Colors.deepPurpleAccent,
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      child: TextField(
                        controller: confpass,
                        onChanged: (val) {
                          setState(() {
                            val = confpass.text;
                            if (val == pp.text) {
                              i = 1;
                            }
                            if (pp.text == '') {
                              i = 0;
                            }
                            if (val != pp.text && val != '' && pp.text != '') {
                              i = -1;
                            }
                            if (val == '') {
                              i = 0;
                            }
                          });
                        },
                        maxLines: 1,
                        obscureText: see2,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (i != 0)
                                i > 0
                                    ? FadeInAnimation(
                                        key: GlobalKey(),
                                        direction: AnimationDirection.upward,
                                        animationType: AnimationType.scale,
                                        scaleFactor: .9,
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ))
                                    : FadeInAnimation(
                                        direction: AnimationDirection.upward,
                                        animationType: AnimationType.scale,
                                        scaleFactor: .9,
                                        child: const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        )),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    see2 = !see2;
                                  });
                                },
                                icon: Icon(
                                  see2
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          contentPadding:
                              const EdgeInsets.only(left: 15, top: 8),
                          errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Confirm-Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //=================signup Button===============
                Positioned(
                    top: sheight * 0.770,
                    left: swidth * 0.158,
                    right: swidth * 0.158,
                    bottom: sheight * 0.16,
                    child: FadeInAnimation(
                        direction: AnimationDirection.upward,
                        child: MaterialButton(
                          onPressed: () async {
                            if (pp.text == '' &&
                                ee.text == '' &&
                                user.text == '') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error Occured',
                                desc:
                                    'All fields are required to create an account',
                                btnOkColor: Colors.redAccent,
                                btnOkOnPress: () {},
                              )..show();
                              return;
                            }
                            if (user.text.isEmpty) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error Occured',
                                desc: 'Username cannot be empty',
                                btnOkColor: Colors.redAccent,
                                btnOkOnPress: () {},
                              )..show();
                              return;
                            }
                            if (ee.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error Occured',
                                desc: 'Email cannot be empty',
                                btnOkColor: Colors.redAccent,
                                btnOkOnPress: () {},
                              )..show();
                              return;
                            }
                            if (pp.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error Occured',
                                desc: 'Password cannot be empty',
                                btnOkColor: Colors.redAccent,
                                btnOkOnPress: () {},
                              )..show();
                              return;
                            }
                            if (pp.text != confpass.text) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Error',
                                desc: 'Passwords do not match',
                                btnOkColor: Colors.redAccent,
                                btnOkOnPress: () {},
                              ).show();
                              return;
                            }

                            try {
                              isLoading = true;
                              setState(() {});
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: ee.text,
                                password: pp.text,
                              );
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(credential.user!.uid)
                                  .set({
                                // Set directly on the user's document for easier access
                                'id': credential.user!.uid,
                                'Email': ee.text,
                                'userName': user.text,
                                'role': 'user', // Default role for new sign-ups
                              });
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  'homepage', (Route) => false);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.rightSlide,
                                        title: 'Error Occured',
                                        desc:
                                            'The password provided is too weak.',
                                        btnOkOnPress: () {},
                                        btnOkColor: Colors.orange)
                                    .show();
                              } else if (e.code == 'email-already-in-use') {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.rightSlide,
                                        title: 'Warning',
                                        desc:
                                            'The account already exists for that email.',
                                        btnOkOnPress: () {},
                                        btnOkColor: Colors.orange)
                                    .show();
                              }
                            } catch (e) {
                              print(e);
                            }
                            isLoading = false;
                            setState(() {});
                          },
                          minWidth: 200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: Colors.redAccent,
                          child: const Text(
                            "Sign up",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ))),
                //======================back button========================
                Positioned(
                    top: sheight * 0.86,
                    left: swidth * 0.2,
                    right: swidth * 0.2,
                    bottom: sheight * 0.07,
                    child: FadeInAnimation(
                        direction: AnimationDirection.upward,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("login");
                          },
                          minWidth: 200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          color: Colors.blueGrey,
                          child: const Text(
                            "Back to login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
                if (isLoading)
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
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
            ))));
  }
}
