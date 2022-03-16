import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../helpers/auth_validator.dart';
import '../models/http_exception.dart';
// import './show_dialog.dart';
import '../theme/palette.dart';

// enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

//signle ticker for animations
class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  // ignore: prefer_final_fields
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _adminStatus = false; //collects admin status
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _verifyPasswordFocusNode = FocusNode();
  AnimationController? _controller;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    //runs forms validation process
    final isValid = _formKey.currentState?.validate();
    if (isValid == null) {
      return;
    } else if (!isValid) {
      return;
    }

    //collects data from all forms and show progress indicator
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'] as String,
            _authData['password'] as String,
            _adminStatus);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'] as String,
            _authData['password'] as String,
            _adminStatus);
      }
    } on HttpException catch (error) {
      //Error handling
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }

      _showErrorDialog(errorMessage);
      // showAuthError(context, errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  //show sign/login form
  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    //screen size optimizations
    bool isLargeScreen = deviceSize.width > Palette.deviceScreenThreshold;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        height: _authMode == AuthMode.signup ? 400 : 260,
        // height: _heightAnimation!.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signup ? 400 : 260,
        ),
        // width: deviceSize.width * 0.75,
        width: isLargeScreen ? 450 : deviceSize.width * 0.75,

        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  validator: (value) => AuthValidator.email(value),
                  onSaved: (value) {
                    if (value != null) {
                      _authData['email'] = value;
                    }
                  },
                ),
                //configured to automatically navigate the fields
                //using TextInputActions and FocusNodes
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  textInputAction: _authMode == AuthMode.signup
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (_authMode == AuthMode.signup) {
                      FocusScope.of(context)
                          .requestFocus(_verifyPasswordFocusNode);
                    } else {
                      _submit();
                    }
                  },
                  validator: (value) => AuthValidator.password(value),
                  onSaved: (value) {
                    if (value != null) {
                      _authData['password'] = value;
                    }
                  },
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      //add extra height for the error messges.
                      minHeight: _authMode == AuthMode.signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.signup ? 180 : 0),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: TextFormField(
                      focusNode: _verifyPasswordFocusNode,
                      enabled: _authMode == AuthMode.signup,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (value) => AuthValidator.confirmPassword(
                          value, _authMode, _passwordController.text),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      //add extra height for the error messges.
                      minHeight: _authMode == AuthMode.signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.signup ? 180 : 0),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signup,
                      decoration: const InputDecoration(
                          labelText: '[Optional] Admin Key'),
                      obscureText: true,
                      validator: (value) => AuthValidator.confirmAdminKey(
                          value, _authMode, Auth.adminSignUpKey),
                      onSaved: (value) {
                        if (value != null) {
                          _adminStatus = true;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //isloading replace...
                _isLoading
                    ? const CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(
                            _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        // textColor: Theme.of(context).primaryTextTheme.button.color,
                      ),

                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
