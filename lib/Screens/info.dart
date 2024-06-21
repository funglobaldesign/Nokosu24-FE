import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:nokosu2023/Components/SubComponents/error_field.dart';
import 'package:nokosu2023/Components/button_submit.dart';
import 'package:nokosu2023/Components/categories.dart';
import 'package:nokosu2023/Components/groups_select.dart';
import 'package:nokosu2023/Components/input_field.dart';
import 'package:nokosu2023/Components/preview.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:geolocator/geolocator.dart';

class InfoPage extends StatefulWidget {
  final String image;

  const InfoPage({
    Key? key,
    required this.image,
  }) : super(key: key);
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  TextEditingController topicController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  double longitude = 0;
  double latitude = 0;
  String address = "-";

  TextEditingController formErrorController = TextEditingController();
  late AppLocalizations locale;
  late Position position;
  bool _isLocationAvailable = false;

  Future<void> getCurrentPosition() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      longitude = position.longitude;
      latitude = position.latitude;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition().then((_) async {
      _isLocationAvailable = true;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      String tempAddress = placemarks[0].country ?? '';
      tempAddress +=
          placemarks[0].locality != null && placemarks[0].locality!.isNotEmpty
              ? ', ${placemarks[0].locality}'
              : '';
      tempAddress += placemarks[0].subLocality != null &&
              placemarks[0].subLocality!.isNotEmpty
          ? ', ${placemarks[0].subLocality}'
          : '';

      if (tempAddress.isNotEmpty) address = tempAddress;

      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    bool? show = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(locale.photodel),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(locale.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(locale.ok),
            ),
          ],
        );
      },
    );
    return show;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? shouldPop = await _showConfirmationDialog(context);
        if (shouldPop != null) {
          return shouldPop;
        }
        return false;
      },
      child: Scaffold(
        appBar: null,
        backgroundColor: ThemeColours.bgBlueWhite,
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => PreviewPage(
                          image: Image.file(File(widget.image)),
                          info: Info(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.height * 0.3
                              : MediaQuery.of(context).size.width * 0.6,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: ThemeColours.bgBlueWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 0,
                              color: Colors.transparent,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                offset: const Offset(-6, -6),
                                color: ThemeColours.shadowDark.withOpacity(0.3),
                              ),
                              BoxShadow(
                                blurRadius: 6,
                                offset: const Offset(6, 6),
                                color: ThemeColours.shadowDark.withOpacity(0.3),
                              )
                            ],
                          ),
                          child: ClipRect(
                            child: OverflowBox(
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: SizedBox(
                                  width: 1,
                                  child: Image.file(File(widget.image)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            locale.taptoviewim,
                            style: const TextStyle(
                              color: ThemeColours.txtGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    label: locale.topic,
                    controller: topicController,
                    prefixicon: SvgPicture.asset(CustIcons.topic),
                    border: 10,
                    isErr: false,
                  ),
                  InputField(
                    label: locale.desc,
                    controller: descController,
                    prefixicon: SvgPicture.asset(CustIcons.comment),
                    border: 10,
                    isErr: false,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => GroupsSelect(
                          groupController: groupController,
                          groupNameController: groupNameController,
                        ),
                      );
                    },
                    child: InputField(
                      label: locale.group,
                      controller: groupNameController,
                      prefixicon: SvgPicture.asset(CustIcons.groups),
                      border: 10,
                      isErr: false,
                      isEnabled: false,
                    ),
                  ),
                  InputField(
                    label: locale.locname,
                    controller: locationController,
                    prefixicon: SvgPicture.asset(CustIcons.location),
                    border: 10,
                    isErr: false,
                  ),
                  if (_isLocationAvailable)
                    Text('${locale.address} : $address'),
                  const SizedBox(height: 30),
                  ErrorField(err: formErrorController.text),
                  ButtonSubmit(
                    text: locale.next,
                    onPressed: () {
                      if (topicController.text.isEmpty ||
                          descController.text.isEmpty ||
                          locationController.text.isEmpty ||
                          groupController.text.isEmpty) {
                        formErrorController.text = locale.allFieldsRequired;
                      } else {
                        formErrorController.text = '';
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Categories(
                            info: Info(
                              topic: topicController.text,
                              description: descController.text,
                              group: int.parse(groupController.text),
                              location: locationController.text,
                              longitude: longitude,
                              latitude: latitude,
                              address: address,
                            ),
                            group: Group(),
                            imagePath: widget.image,
                          ),
                        );
                      }
                      setState(() {});
                    },
                    border: 10,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
