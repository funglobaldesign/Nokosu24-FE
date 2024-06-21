// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLogin _$UserLoginFromJson(Map<String, dynamic> json) => UserLogin(
      username: json['username'] as String? ?? "",
      password: json['password'] as String? ?? "",
    );

Map<String, dynamic> _$UserLoginToJson(UserLogin instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

UserReg _$UserRegFromJson(Map<String, dynamic> json) => UserReg(
      username: json['username'] as String? ?? "",
      email: json['email'] as String? ?? "",
      first_name: json['first_name'] as String? ?? "",
      last_name: json['last_name'] as String? ?? "",
      password1: json['password1'] as String? ?? "",
      password2: json['password2'] as String? ?? "",
    );

Map<String, dynamic> _$UserRegToJson(UserReg instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'password1': instance.password1,
      'password2': instance.password2,
    };

FormErrResponse _$FormErrResponseFromJson(Map<String, dynamic> json) =>
    FormErrResponse(
      message: json['message'] as String? ?? "",
      code: json['code'] as String? ?? "",
    );

Map<String, dynamic> _$FormErrResponseToJson(FormErrResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
    };

UserRegResponse _$UserRegResponseFromJson(Map<String, dynamic> json) =>
    UserRegResponse(
      username: json['username'] == null
          ? null
          : FormErrResponse.fromJson(
              json['username'][0] as Map<String, dynamic>),
      email: json['email'] == null
          ? null
          : FormErrResponse.fromJson(json['email'][0] as Map<String, dynamic>),
      first_name: json['first_name'] == null
          ? null
          : FormErrResponse.fromJson(
              json['first_name'][0] as Map<String, dynamic>),
      last_name: json['last_name'] == null
          ? null
          : FormErrResponse.fromJson(
              json['last_name'][0] as Map<String, dynamic>),
      password1: json['password1'] == null
          ? null
          : FormErrResponse.fromJson(
              json['password1'][0] as Map<String, dynamic>),
      password2: json['password2'] == null
          ? null
          : FormErrResponse.fromJson(
              json['password2'][0] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserRegResponseToJson(UserRegResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'password1': instance.password1,
      'password2': instance.password2,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? "",
      email: json['email'] as String? ?? "",
      first_name: json['first_name'] as String? ?? "",
      last_name: json['last_name'] as String? ?? "",
      is_active: json['is_active'] as bool? ?? false,
      is_staff: json['is_staff'] as bool? ?? false,
      is_superuser: json['is_superuser'] as bool? ?? false,
      date_joined: json['date_joined'] == null
          ? DateTime.now()
          : DateTime.parse(json['date_joined'] as String).toLocal(),
      last_login: json['last_login'] == null
          ? DateTime.now()
          : DateTime.parse(json['last_login'] as String).toLocal(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'is_active': instance.is_active,
      'is_staff': instance.is_staff,
      'is_superuser': instance.is_superuser,
      'date_joined': instance.date_joined?.toIso8601String(),
      'last_login': instance.last_login?.toIso8601String(),
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      id: json['id'] as int? ?? 0,
      photo: json['photo'] as String? ?? "",
      url: json['url'] as String? ?? "",
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'photo': instance.photo,
      'url': instance.url,
      'user': instance.user,
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? "",
      createdBy: json['createdBy'] as int? ?? 0,
      created: json['created'] == null
          ? DateTime.now()
          : DateTime.parse(json['created'] as String).toLocal(),
      logo: json['logo'] as String? ?? "",
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdBy': instance.createdBy,
      'created': instance.created?.toIso8601String(),
      'logo': instance.logo,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      id: json['id'] as int? ?? 0,
      topic: json['topic'] as String? ?? "",
      description: json['description'] as String? ?? "",
      created: json['created'] == null
          ? DateTime.now()
          : DateTime.parse(json['created'] as String).toLocal(),
      photo: json['photo'] as String? ?? "",
      url: json['url'] as String? ?? "",
      group: json['group'] as int? ?? -1,
      createdBy: json['createdBy'] as int? ?? 0,
      positive: json['positive'] as bool? ?? false,
      emotion: json['emotion'] as bool? ?? false,
      cultural: json['cultural'] as bool? ?? false,
      physical: json['physical'] as bool? ?? false,
      location: json['location'] as String? ?? "",
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? "",
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'description': instance.description,
      'created': instance.created?.toIso8601String(),
      'photo': instance.photo,
      'url': instance.url,
      'group': instance.group,
      'createdBy': instance.createdBy,
      'positive': instance.positive,
      'emotion': instance.emotion,
      'cultural': instance.cultural,
      'physical': instance.physical,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
    };
