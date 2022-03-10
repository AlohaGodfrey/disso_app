import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //bundle in http prefix
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../helpers/firebase_service.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  bool _isAdmin = false;
  static const dbUrl =
      'https://disso-7229a-default-rtdb.europe-west1.firebasedatabase.app';

  //key for admin sign up
  static const adminSignUpKey = 'dissoAdminKey';

  //check if user is authenticated
  bool get isAuth {
    return token != null;
  }

  bool get isAdmin {
    //debug admin sliver
    // return true;
    return _isAdmin;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> signup(String email, String password, bool isAdmin) async {
    final _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCN1YGy3V2Lq3zaMowbVU6jPV9RGZnLTjs');
    return _authenticate(email, password, _url, setProfileData, isAdmin);
  }

  Future<void> login(String email, String password, bool isAdmin) async {
    final _url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCN1YGy3V2Lq3zaMowbVU6jPV9RGZnLTjs');
    return _authenticate(email, password, _url, fetchProfileData, isAdmin);
  }

  Future<void> setProfileData([bool isAdmin = false]) async {
    final url = firebaseUrl(_token as String, '/role/$userId.json');

    //send admin status to server
    // final response =
    await http.post(
      url,
      body: json.encode({
        'adminStatus': isAdmin,
      }),
    );
    //set isadmin to...
    _isAdmin = isAdmin;
    //update job list tool and profile sliver
    notifyListeners();
  }

  Future<void> fetchProfileData(bool isAdmin) async {
    final url = firebaseUrl(_token as String, '/role/$userId.json');
    final response = await http.get(url);

    final rawBody = json.decode(response.body);
    try {
      if (rawBody == null) {
        //when profile data is empty, user is not an admin
        //used for the legacy accounts... new accounts
        //will have a valid entry in table
        _isAdmin = false;
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      extractedData.forEach((profileId, profileData) {
        _isAdmin = profileData['adminStatus'];
      });

      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }

  Future<void> _authenticate(String email, String password, Uri url,
      Function checkAdmin, bool isAdmin) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      //throw custom exception if data is successfully transmitted
      //to the database however the data fails validation protocols
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      await checkAdmin(isAdmin); //prints and sets is admin status
      _autoLogout(); //starts timer for autologout
      notifyListeners();

      //connects to user device storage on the device
      final prefs = await SharedPreferences.getInstance();
      //stores auth data as json map in string
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate?.toIso8601String()
      });
      //stores data on user device
      prefs.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      //cannot find data
      return false;
    }
    //extracts the data
    final extractedUserData = json.decode(prefs.getString('userData')!);
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      //token was found but was expired
      return false;
    }

    //logs the user in
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    notifyListeners();

    //bug caused logout button to fail due to the autologin feature.
    //the data stores in shareprefs need to be deleted upon logout request
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    //clear purges all the appdata. be careful if storing critical data.
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer?.cancel();
      //cancel exisiting timer
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    //auto logout at the end of the timer calculated from the authData
    Timer(Duration(seconds: timeToExpiry), logout);
  }
}
