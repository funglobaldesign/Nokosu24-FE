import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nokosu2023/Components/SubComponents/error_field.dart';
import 'package:nokosu2023/Components/button_submit.dart';
import 'package:nokosu2023/Components/categories.dart';
import 'package:nokosu2023/Components/groups_select.dart';
import 'package:nokosu2023/Components/input_field.dart';
import 'package:nokosu2023/Components/preview.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:geolocator/geolocator.dart';

class InfoEditPage extends StatefulWidget {
  final Info info;
  final Image image;
  final Group group;

  const InfoEditPage({
    Key? key,
    required this.info,
    required this.image,
    required this.group,
  }) : super(key: key);
  @override
  State<InfoEditPage> createState() => _InfoEditPageState();
}

class _InfoEditPageState extends State<InfoEditPage> {
  TextEditingController topicController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();

  TextEditingController formErrorController = TextEditingController();
  late AppLocalizations locale;
  late Position position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  Future<void> getGroups() async {
    await apiGetGroups(context);
  }

  @override
  void initState() {
    topicController.text = widget.info.topic!;
    descController.text = widget.info.description!;
    locationController.text = widget.info.location!;
    groupController.text = widget.info.group!.toString();
    groupNameController.text = widget.group.name!;

    super.initState();
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
                          image: widget.image,
                          info: widget.info,
                          isUpdate: true,
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
                                child: SizedBox(width: 1, child: widget.image),
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
                        widget.info.topic = topicController.text;
                        widget.info.description = descController.text;
                        widget.info.location = locationController.text;
                        widget.info.group = int.parse(groupController.text);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => Categories(
                            info: widget.info,
                            imagePath: '',
                            group: widget.group,
                            isupdate: true,
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
