import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:state_management/exception/HttpException.dart';
import '';

class Auth with ChangeNotifier {
  String _token ;
  DateTime _expiryDate ;
  String _user_id;

  bool get isAuth {
    // print("Auth value: ${_token}");
    // print("Auth condition: ${_token != null}");
    return _token != null;
  }

  String get userId {
    if (_user_id != null) {
      return _user_id;
    }
    return null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String segmentUrl) async {
    final uriSignup = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=AIzaSyALS4aYjPv2d3_2yErDstylI5t8MnfCejU");
    try {
      print(email);
      print(password);
      final response = await http.post(uriSignup,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseDecode = json.decode(response.body);
      if (responseDecode['error'] != null) {
        throw HttpException(responseDecode['error']["message"]);
      }
      _token = responseDecode["idToken"];
      _user_id = responseDecode["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseDecode["expiresIn"])));
      // print(token);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    await _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    await _authenticate(email, password, "signInWithPassword");
  }
}
