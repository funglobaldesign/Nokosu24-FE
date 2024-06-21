import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/form_err_res_provider.dart';
import 'package:nokosu2023/providers/group_provider.dart';
import 'package:nokosu2023/providers/info_provider.dart';
import 'package:nokosu2023/providers/profile_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/providers/token_provider.dart';
import 'package:provider/provider.dart';

// Private utility functions
void _setProfile(context, json) {
  Provider.of<TokenProvider>(context, listen: false)
      .setToken(json['token'], json['profile']['id']);
  Provider.of<ProfileProvider>(context, listen: false)
      .setModel(Profile.fromJson(json['profile']));
}

Future<int> confirmToken(String token, int did) async {
  final response = await http.get(Uri.parse('${APILinks.base}profiles/$did/'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
        'Authorization': 'Token $token',
      });

  int id = 0;

  if (response.statusCode == 200) {
    Profile prof = Profile.fromJson(jsonDecode(response.body));
    if (prof.id != null) {
      id = Profile.fromJson(jsonDecode(response.body)).id!;
    }
  }

  return id;
}

// User
Future<int> apiRegister(context, UserReg data) async {
  try {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${APILinks.base}users/register/'));
    data.toJson().forEach((key, value) {
      request.fields[key] = value.toString();
    });
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';
    final response = await request.send();
    if (response.statusCode == 200) {
      _setProfile(context, jsonDecode(await response.stream.bytesToString()));
      Provider.of<FormErrProvider>(context, listen: false)
          .setModel(UserRegResponse());
      return Errors.none;
    } else if (response.statusCode == 400) {
      UserRegResponse userres = UserRegResponse.fromJson(
          jsonDecode(await response.stream.bytesToString()));
      Provider.of<FormErrProvider>(context, listen: false).setModel(userres);
      return Errors.badreq;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiLogin(context, UserLogin data) async {
  try {
    final response = await http.post(
      Uri.parse('${APILinks.base}users/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
      body: jsonEncode(data.toJson()),
    );

    if (response.statusCode == 200) {
      _setProfile(context, jsonDecode(response.body));
      return Errors.none;
    } else if (response.statusCode == 400) {
      return Errors.badreq;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiLogout(context) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;

    final response = await http.post(
      Uri.parse('${APILinks.base}users/logout/'),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      Provider.of<TokenProvider>(context, listen: false)
          .setToken("", Errors.none);
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

// Profile
// apiGetProfiles : Not required atm
Future<int> apiGetProfile(context, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;

    final response = await http.get(Uri.parse('${APILinks.base}profiles/$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': 'Token $token',
        });

    if (response.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false)
          .setModel(Profile.fromJson(jsonDecode(response.body)));
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiUpdateProfile(context, UserReg data, String file, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    var request = http.MultipartRequest(
        'PUT', Uri.parse('${APILinks.base}profiles/$id/'));

    data.toJson().forEach((key, value) {
      if (key != 'password1' &&
          key != 'password2' &&
          value != null &&
          value.isNotEmpty) {
        request.fields[key] = value.toString();
      }
    });
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';
    request.headers['Authorization'] = 'Token $token';
    request.files.add(await http.MultipartFile.fromPath('photo', file));

    final response = await request.send();

    if (response.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false).setModel(
          Profile.fromJson(jsonDecode(await response.stream.bytesToString())));
      Provider.of<FormErrProvider>(context, listen: false)
          .setModel(UserRegResponse());
      return Errors.none;
    } else if (response.statusCode == 400) {
      UserRegResponse userres = UserRegResponse.fromJson(
          jsonDecode(await response.stream.bytesToString()));
      Provider.of<FormErrProvider>(context, listen: false).setModel(userres);
      return Errors.badreq;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiDelProfile(context, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    var request = http.MultipartRequest(
        'DELETE', Uri.parse('${APILinks.base}profiles/$id/'));

    request.headers['Authorization'] = 'Token $token';
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();

    if (response.statusCode == 200) {
      Provider.of<ProfileProvider>(context, listen: false).setModel(Profile());
      return Errors.none;
    } else if (response.statusCode == 400) {
      return Errors.badreq;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

// Group
Future<int> apiGetGroups(context) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    final response = await http
        .get(Uri.parse('${APILinks.base}groups/'), headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      Provider.of<GroupsProvider>(context, listen: false).setModels([]);
      // var json = jsonDecode(response.body);
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      for (var each in jsonResponse) {
        Provider.of<GroupsProvider>(context, listen: false)
            .addModel(Group.fromJson(each));
      }
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiGetGroup(context, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;

    final response = await http.get(Uri.parse('${APILinks.base}groups/$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': 'Token $token',
        });

    if (response.statusCode == 200) {
      Provider.of<InfosProvider>(context, listen: false).setModels([]);
      // var json = jsonDecode(response.body);
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      for (var each in jsonResponse) {
        Provider.of<InfosProvider>(context, listen: false)
            .addModel(Info.fromJson(each));
      }
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiAddgroup(context, String data) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;

    var request =
        http.MultipartRequest('POST', Uri.parse('${APILinks.base}groups/'));

    request.fields['name'] = data;
    request.headers['Authorization'] = 'Token $token';
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();

    if (response.statusCode == 200) {
      Group group =
          Group.fromJson(jsonDecode(await response.stream.bytesToString()));
      Provider.of<GroupProvider>(context, listen: false).setModel(group);
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else if (response.statusCode == 400) {
      return Errors.badreq;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiUpdateGroup(context, String data, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    var request =
        http.MultipartRequest('PUT', Uri.parse('${APILinks.base}groups/$id/'));

    request.fields['name'] = data;
    request.headers['Authorization'] = 'Token $token';
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();
    if (response.statusCode == 200) {
      Group group =
          Group.fromJson(jsonDecode(await response.stream.bytesToString()));
      Provider.of<GroupProvider>(context, listen: false).setModel(group);
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else if (response.statusCode == 400) {
      return Errors.badreq;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiDelGroup(context, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    var request = http.MultipartRequest(
        'DELETE', Uri.parse('${APILinks.base}groups/$id/'));

    request.headers['Authorization'] = 'Token $token';
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();

    if (response.statusCode == 200) {
      return Errors.none;
    } else if (response.statusCode == 400) {
      return Errors.badreq;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

// Info
Future<int> apiGetInfos(context) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;

    final response = await http
        .get(Uri.parse('${APILinks.base}infos/'), headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      Provider.of<InfosProvider>(context, listen: false).setModels([]);
      // var json = jsonDecode(response.body);
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      for (var each in jsonResponse) {
        Provider.of<InfosProvider>(context, listen: false)
            .addModel(Info.fromJson(each));
      }
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiGetInfo(context, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;

    final response = await http
        .get(Uri.parse('${APILinks.base}infos/$id/'), headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      Provider.of<InfoProvider>(context, listen: false)
          .setModel(Info.fromJson(jsonDecode(response.body)));
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiAddInfo(context, Info data, String file) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    var request =
        http.MultipartRequest('POST', Uri.parse('${APILinks.base}infos/'));

    data.toJson().forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });
    request.files.add(await http.MultipartFile.fromPath('photo', file));
    request.headers['Authorization'] = 'Token $token';
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();
    if (response.statusCode == 200) {
      Provider.of<InfoProvider>(context, listen: false).setModel(
          Info.fromJson(jsonDecode(await response.stream.bytesToString())));
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiUpdateInfo(context, Info data, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    var request =
        http.MultipartRequest('PUT', Uri.parse('${APILinks.base}infos/$id/'));
    data.toJson().forEach((key, value) {
      if (key == 'topic' ||
          key == 'description' ||
          key == 'location' ||
          key == 'group' ||
          key == 'positive' ||
          key == 'emotion' ||
          key == 'cultural' ||
          key == 'physical') {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      }
    });
    request.headers['Authorization'] = 'Token $token';
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();
    if (response.statusCode == 200) {
      Provider.of<InfoProvider>(context, listen: false).setModel(
          Info.fromJson(jsonDecode(await response.stream.bytesToString())));
      return Errors.none;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

Future<int> apiDelInfo(context, int id) async {
  try {
    String token = Provider.of<TokenProvider>(context, listen: false).token;
    var request = http.MultipartRequest(
        'DELETE', Uri.parse('${APILinks.base}infos/$id/'));

    request.headers['Authorization'] = 'Token $token';
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();

    if (response.statusCode == 200) {
      return Errors.none;
    } else if (response.statusCode == 400) {
      return Errors.badreq;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}

// Email
Future<int> apigetMail(context, String data) async {
  try {
    var request = http.MultipartRequest(
        'POST', Uri.parse('${APILinks.base}password_reset/'));

    request.fields['email'] = data;
    request.headers['Content-Type'] =
        'application/x-www-form-urlencoded; charset=utf-8';

    final response = await request.send();

    if (response.statusCode == 200) {
      return Errors.none;
    } else if (response.statusCode == 400) {
      return Errors.badreq;
    } else if (response.statusCode == 401) {
      return Errors.unAuth;
    } else {
      return Errors.unknown;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Exception : $e");
    }
    return Errors.unknown;
  }
}
// apiUpdatePw : Not required atm
