import 'package:flutter/material.dart';
import 'package:sendbirdsdk/sendbirdsdk.dart';
import '../styles/color.dart';
import '../styles/text_style.dart';
import 'package:sendbird_flutter/view_models/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userIdController = TextEditingController();
  final nicknameController = TextEditingController();
  bool enableSignInButton = false;

  bool _shouldEnableSignInButton() {
    if (userIdController.text == null || userIdController.text == "") {
      return false;
    }
    return true;
  }

  final model = LoginViewModel(appId: 'D56438AE-B4DB-4DC9-B440-E032D7B35CEB');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 56),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  child: Image(
                    image: AssetImage('assets/logoSendbird@3x.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                SizedBox(height: 20),
                Text('Sendbird Sample', style: TextStyles.sendbirdLogo),
                SizedBox(height: 40),
                _buildInputField(userIdController, 'User ID'),
                SizedBox(height: 16),
                _buildInputField(nicknameController, 'Nickname'),
                SizedBox(height: 32),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: _signInButton(context, enableSignInButton),
                ),
                _buildVersionLabel(),
              ],
            ),
          ),
        ));
  }

  // build helpers

  Widget _buildInputField(
      TextEditingController controller, String placeholder) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        setState(() {
          enableSignInButton = _shouldEnableSignInButton();
        });
      },
      style: TextStyles.sendbirdSubtitle1OnLight1,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: SBColors.primary_300, width: 2),
        ),
        border: InputBorder.none,
        labelText: placeholder,
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _signInButton(BuildContext context, bool enabled) {
    return FlatButton(
      height: 48,
      color: enabled ? Theme.of(context).buttonColor : Colors.grey,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      onPressed: !enabled
          ? null
          : () async {
              try {
                await model.login(
                  userIdController.text,
                  nicknameController.text,
                );

                Navigator.pushNamed(context, '/channel_list');
              } catch (e) {
                print('login_view.dart: _signInButton: ERROR: $e');
                _showLoginFailAlert(context);
              }
            },
      child: Text(
        "Sign In",
        style: TextStyles.sendbirdButtonOnDark1,
      ),
    );
  }

  Widget _buildVersionLabel() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Text(
          'SDK ' + SendbirdSdk().getSdkVersion(),
          style: TextStyles.sendbirdCaption1OnLight2,
        ),
      ),
    );
  }

  void _showLoginFailAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            textAlign: TextAlign.left,
            softWrap: true,
            text: TextSpan(
              text: 'Login Failed:  ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Check connectivity and App Id',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              textColor: Theme.of(context).buttonColor,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}