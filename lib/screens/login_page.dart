import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hardwarestore/controllers/navigation.dart';
import 'package:hardwarestore/models/user.dart';

import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import '../components/user.dart';
import '../services/api.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  LoginPage({Key? key}) : super(key: key);
  String phoneNumber = "548004990"; //enter your 10 digit number
  int minNumber = 1000;
  int maxNumber = 6000;
  String countryCode = "+972";
  String authCodeVerId = "";
  bool errorOccored = false;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNo = "";
  String? smsOTP;
  String? verificationId;
  String errorMessage = '';
  String _status = "";
  final _codeController = TextEditingController();

  bool isPasswordVisible = false;
  Future<Null> loginUser(User user) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', "0" + user.phoneNumber!.substring(4));

      List<AppUser>? users = await Repository()
          .getUserByLogin("0" + user.phoneNumber!.substring(4));

      if (users!.isNotEmpty) {
        Provider.of<GetCurrentUser>(context, listen: false)
            .updateUser(users.first);

        SharedPreferences.getInstance().then((value) {
          switch (Provider.of<GetCurrentUser>(context, listen: false)
              .currentUser!
              .userType
              .toString()) {
            case 'dev':
              if (Platform.isIOS)
                value.setString('ipAddress', 'http://127.0.0.1:8000');
              else
                value.setString('ipAddress', 'http://10.0.2.2:8000');
              break;
            case 'test':
              value.setString('ipAddress', 'http://139.162.139.161:8000');
              break;
            default:
              value.setString('ipAddress', 'http://www.arabapps.biz:8000');
          }
        });

        Provider.of<NavigationController>(context, listen: false)
            .changeScreen('/');
      }
    } catch (e) {
      print('loginUser: $e');
    }
  }

  Future<void> verifyPhone() async {
    print('starting to  verifyPhone ');

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('starting to  verifyPhone verificationCompleted ');

          // ANDROID ONLY!
          // Sign the user in (or link) with the auto-generated credential
          await widget.auth.signInWithCredential(credential).then(
                (value) => print(value.user?.phoneNumber),
              );
        },
        verificationFailed: (FirebaseAuthException e) {
          print('starting to  verifyPhone verificationFailed ');

          if (e.code == 'invalid-phone-number') {
            setState(() {
              _status = "Incorrect code, please try again.";
            });
          }
          print('verificationFailed verifyPhone ${e.message}');

          // Handle other errors
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          print('codeSent verifyPhone $verificationId');

          widget.authCodeVerId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('timeout verifyPhone');
          // Auto-resolution timed out...
        },
      );
    } catch (e) {
      print('error in verifyPhone():' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/iraqi_no_background.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 100,
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 3,
                                color: Colors.red)
                          ],
                          borderRadius: BorderRadius.circular(100).copyWith(
                              bottomRight: const Radius.circular(0),
                              topLeft: const Radius.circular(0))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (!isPasswordVisible)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30)
                                      .copyWith(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: TextFormField(
                                  onChanged: (value) {
                                    if (value.length == 10) {
                                      phoneNo = ("+972" +
                                          value.substring(1, value.length));
                                    }
                                  },
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.5),
                                  decoration: InputDecoration(
                                      prefixIconConstraints:
                                          const BoxConstraints(minWidth: 45),
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(right: 18.0),
                                        child: Icon(
                                          Icons.phone_iphone,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      hintText:
                                          'Enter Phone Number e.g 0548004990',
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 10.5),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(
                                                  bottomRight:
                                                      const Radius.circular(0),
                                                  topLeft:
                                                      const Radius.circular(0)),
                                          borderSide: const BorderSide(
                                              color: Colors.white38)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30)
                                              .copyWith(
                                                  bottomRight:
                                                      const Radius.circular(0),
                                                  topLeft:
                                                      const Radius.circular(0)),
                                          borderSide: const BorderSide(
                                              color: Colors.white))),
                                ),
                              ),
                            ),
                          if (isPasswordVisible)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30)
                                      .copyWith(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: TextField(
                                  controller: _codeController,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.5),
                                  decoration: InputDecoration(
                                      prefixIconConstraints:
                                          const BoxConstraints(minWidth: 45),
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(right: 18.0),
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                      hintText:
                                          'Enter 6 digits code, e.g 123456',
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 10.5),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(
                                                  bottomRight:
                                                      const Radius.circular(0),
                                                  topLeft:
                                                      const Radius.circular(0)),
                                          borderSide: const BorderSide(
                                              color: Colors.white38)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30)
                                              .copyWith(
                                                  bottomRight:
                                                      const Radius.circular(0),
                                                  topLeft:
                                                      const Radius.circular(0)),
                                          borderSide: const BorderSide(
                                              color: Colors.white))),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    if (!isPasswordVisible)
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 3,
                                color: Colors.red)
                          ],
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 120)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            // elevation: MaterialStateProperty.all(3),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            //onpressed();

                            if (phoneNo.length >= 13) {
                              verifyPhone();
                            } else {
                              (e) {
                                setState(() {
                                  _status = "phone is correct";
                                });
                              };
                            }
                            setState(() {
                              isPasswordVisible = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              translation!.requestCode,
                              style: const TextStyle(
                                  fontSize: 18,
                                  // fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    if (isPasswordVisible)
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 3,
                                color: Colors.red)
                          ],
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 120)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            // elevation: MaterialStateProperty.all(3),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () async {
                            try {
                              FirebaseAuth auth = FirebaseAuth.instance;

                              String smsCode = _codeController.text.trim();

                              PhoneAuthCredential _credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: widget.authCodeVerId,
                                      smsCode: smsCode);
                              try {
                                await auth
                                    .signInWithCredential(_credential)
                                    .then((UserCredential result) {
                                  // There is a provider that hold current user
                                  // Once a user is authenticated, call django send the uid and get the user object back.
                                  // Repository()
                                  //     .getUserByLogin("0" +
                                  //         result.user!.phoneNumber!
                                  //             .substring(4))
                                  //     .then((value) {
                                  //   Provider.of<GetCurrentUser>(context,
                                  //           listen: false)
                                  //       .currentUser = value?.first;

                                  //   Provider.of<NavigationController>(context,
                                  //           listen: false)
                                  //       .changeScreen('/');

                                  // });

                                  loginUser(result.user!);
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'invalid-verification-code') {
                                  //print('error wrong code');
                                }
                                setState(() {
                                  errorMessage =
                                      'יש תקלה בהתחברות, יש לצור קשר עם גסאן';
                                });
                              } catch (e) {
                                print(e.toString());
                                setState(() {
                                  errorMessage =
                                      'יש תקלה בהתחברות, יש לצור קשר עם גסאן';
                                });
                              }
                            } catch (e) {
                              print(e.toString());

                              setState(() {
                                setState(() {
                                  errorMessage =
                                      'יש תקלה בהתחברות, יש לצור קשר עם גסאן';
                                });
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              translation!.login,
                              style: const TextStyle(
                                  fontSize: 18,
                                  // fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    (errorMessage != ''
                        ? Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          )
                        : Container()),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
