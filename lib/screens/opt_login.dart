import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hardwarestore/components/user.dart';
import 'package:hardwarestore/screens/home_admin.dart';
import 'package:hardwarestore/services/django_services.dart';
import 'package:provider/provider.dart';

class OTPLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Authentication',
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => HomeAdmin(),
        '/loginpage': (BuildContext context) => OTPLogin(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OTPLoginPage(title: 'Phone Authentication'),
    );
  }
}

class OTPLoginPage extends StatefulWidget {
  const OTPLoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _OTPLoginPageState createState() => _OTPLoginPageState();
}

class _OTPLoginPageState extends State<OTPLoginPage> {
  String phoneNo = "";
  String? smsOTP;
  String? verificationId;
  String errorMessage = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  String _status = "";

  Future<void> verifyPhone() async {
    final _codeController = TextEditingController();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!
          // Sign the user in (or link) with the auto-generated credential
          await auth.signInWithCredential(credential).then(
                (value) => print(value.user?.phoneNumber),
              );
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            setState(() {
              print(e.phoneNumber!);
              _status = "Incorrect code, please try again.";
            });
          }

          // Handle other errors
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          //show dialog to take input from the user
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: const Text("Enter SMS Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                        ),
                        Text(_status),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text("Done"),
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        onPressed: () {
                          try {
                            FirebaseAuth auth = FirebaseAuth.instance;

                            String smsCode = _codeController.text.trim();

                            PhoneAuthCredential _credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);
                            auth
                                .signInWithCredential(_credential)
                                .then((UserCredential result) {
                              print(result.user!.uid);
                              // There is a provider that hold current user
                              // Once a user is authenticated, call django send the uid and get the user object back.
                              DjangoServices().getUser(result.user!.uid).then(
                                  (value) => Provider.of<GetCurrentUser>(
                                          context,
                                          listen: false)
                                      .currentUser = value?.first);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeAdmin()));
                            }).catchError((e) {
                              print(e);
                            });
                          } catch (e) {
                            setState(() {
                              //    _status = "Incorrect code.";
                            });
                          }
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: 'Enter Phone Number Eg. 0501234567'),
                onChanged: (value) {
                  if (value.length == 10) {
                    phoneNo = ("+972" + value.substring(1, value.length));
                    print('phone is: ' + phoneNo);
                  }
                },
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
            TextButton(
              onPressed: () {
                if (phoneNo.length >= 13) {
                  verifyPhone();
                } else {
                  (e) {
                    setState(() {
                      print('phone: ' + phoneNo);
                      _status = "phone is correct";
                    });
                  };
                }
              },
              child: const Text('Lgin'),
            ),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
