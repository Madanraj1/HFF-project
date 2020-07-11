import 'package:flutter/material.dart';
import 'package:homely_fresh_food/pages/authenticate/signin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class Otp_Screen extends StatefulWidget {
  @override
  _Otp_ScreenState createState() => _Otp_ScreenState();
}

class _Otp_ScreenState extends State<Otp_Screen> {
  String phoneNo, verficationId, smsCode;
  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    Color orange_color = Color(0xFFF95E21);

    return Scaffold(
        appBar: AppBar(
          title:
              codeSent ? Text("OTP Verification") : Text('Enter Mobile Number'),
          backgroundColor: orange_color,
        ),
        backgroundColor: Color(0xFFeaeaea),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 20.0, right: 16.0),
                      child: codeSent
                          ? Text('We have sent OTP to your mobile')
                          : Text(
                              "We need to text your OTP to authenticate your account",
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: new Container(),
                          flex: 1,
                        ),
                        Flexible(
                          child: new Container(),
                          flex: 1,
                        ),
                        Flexible(
                          child: codeSent
                              ? Container(
                                  child: PinEntryTextField(
                                    showFieldAsBox: false,
                                    fields: 6,
                                    onSubmit: (String pin) {
                                      setState(() {
                                        smsCode = pin;
                                      });
                                      signInWithOTP(smsCode, verficationId);
                                      print('hey there maddy $smsCode');
                                    },
                                  ),
                                )
                              : TextFormField(
                                  textAlign: TextAlign.start,
                                  autofocus: false,
                                  enabled: true,
                                  keyboardType: TextInputType.number,
                                  initialValue: '+91 ',
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: 'Mobile Number',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          end: 12.0),
                                      child: Icon(
                                        MdiIcons.phone,
                                        color: orange_color,
                                      ), // myIcon is a 48px-wide widget.
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                  onChanged: (val) {
                                    setState(() {
                                      this.phoneNo = val;
                                    });
                                  },
                                ),
                          flex: 25,
                        ),
                        Flexible(
                          child: new Container(),
                          flex: 1,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                      child: new Container(
                        width: 150.0,
                        height: 40.0,
                        child: new RaisedButton(
                            onPressed: () {
                              verifyPhone(phoneNo);
                            },
                            child:
                                codeSent ? Text('Resent otp') : Text("Get OTP"),
                            textColor: Colors.white,
                            color: orange_color,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                      ),
                    )
                  ])
            ],
          ),
        ));
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified =
        (AuthCredential authResult) async {
      setState(() {
        this.codeSent = false;
      });
      AuthResult result =
          await FirebaseAuth.instance.signInWithCredential(authResult);
      FirebaseUser user = result.user;
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Signin()),
            (Route<dynamic> route) => false);
      } else {
        print('error');
      }
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('faild because ${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verficationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verficationId = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        // this is the variable to store phone number
        phoneNumber: phoneNo,
        // timeout for otp
        timeout: const Duration(seconds: 100),
        // this is used when the user's  phone number  is already registered on the google services then no need to receive the otp
        verificationCompleted: verified,
        // suppose the user give any wrong phone number or anything goes wrong
        verificationFailed: verificationfailed,
        // this  is where we have to receive and store the otp and enter manually
        codeSent: smsSent,
        // this is something something
        codeAutoRetrievalTimeout: autoTimeout);
  }

  signInWithOTP(smsCode, verId) async {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    FirebaseUser user = result.user;
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Signin()),
          (Route<dynamic> route) => false);
    } else {
      print('error');
    }
  }
}
