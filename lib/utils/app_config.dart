import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Environment declare here
class Env {
  Env._({@required this.apiBaseUrl});

  factory Env.dev() {
    return Env._(apiBaseUrl: 'https://data.gov.sg/api/action');
  }

  final String apiBaseUrl;
}

/// Config env
class Config {
  factory Config({Env environment}) {
    if (environment != null) {
      instance.env = environment;
    }
    return instance;
  }

  Config._private();

  static final Config instance = Config._private();

  Env env;
}