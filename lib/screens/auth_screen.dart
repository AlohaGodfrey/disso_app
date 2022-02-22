import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../theme/clip_shadow_path.dart';
import '../theme/custom_clippers_bezier.dart';
import '../theme/palette.dart';
import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.kToLight,
      body: Stack(
        children: [
          ClipShadowPath(
            shadow: const BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 8,
            ),
            clipper: BigClipper(),
            child: Container(color: Palette.bToLight),
          ),
          ClipShadowPath(
            shadow: const BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 8,
            ),
            clipper: SmallClipper(),
            child: Container(color: Palette.kToLight),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        FontAwesomeIcons.clipboardCheck,
                        size: 100,
                        color: Palette.bToLight.shade100,
                      ),
                    ),
                  ),
                  Flexible(
                    // flex: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    flex: 4,
                    child: AuthCard(),
                    fit: FlexFit.loose,
                  ),
                  // Flexible(
                  //     child: SizedBox(
                  //   height: 10,
                  // ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

//signle ticker for animations
class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
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
  Animation<Size>? _heightAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 260),
      end: Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeIn),
    );
    // _heightAnimation!.addListener(() => setState(() {}));
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
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'] as String,
            _authData['password'] as String,
            _adminStatus);
      } else {
        //delay introduced to allow time to appreciate spinner
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'] as String,
            _authData['password'] as String,
            _adminStatus);
      }
    } on HttpException catch (error) {
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
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        height: _authMode == AuthMode.Signup ? 400 : 260,
        // height: _heightAnimation!.value.height,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.Signup ? 400 : 260,
        ),
        width: deviceSize.width * 0.75,
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
                  validator: (value) {
                    if (value == null) {
                      return 'Value is Null';
                    }
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
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
                  textInputAction: _authMode == AuthMode.Signup
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (_authMode == AuthMode.Signup) {
                      FocusScope.of(context)
                          .requestFocus(_verifyPasswordFocusNode);
                    } else {
                      _submit();
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Value is Null';
                    }
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _authData['password'] = value;
                    }
                  },
                ),

                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      //add extra height for the error messges.
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 180 : 0),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: TextFormField(
                      focusNode: _verifyPasswordFocusNode,
                      enabled: _authMode == AuthMode.Signup,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                          : null,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      //add extra height for the error messges.
                      minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                      maxHeight: _authMode == AuthMode.Signup ? 180 : 0),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: const InputDecoration(
                          labelText: '[Optional] Admin Key'),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != 'dissoAdminKey') {
                                return 'Invalid Admin Key!';
                              }
                            }
                          : null,
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
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
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
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
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
