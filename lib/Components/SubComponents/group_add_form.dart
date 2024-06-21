import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nokosu2023/Components/SubComponents/error_field.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nokosu2023/Components/button_submit.dart';
import 'package:nokosu2023/Components/input_field.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/group_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:provider/provider.dart';

class GroupFormAdd extends StatefulWidget {
  final bool isUpdate;
  final int gid;
  final bool isFolderview;

  const GroupFormAdd({
    Key? key,
    this.isUpdate = false,
    this.gid = 0,
    this.isFolderview = false,
  }) : super(key: key);

  @override
  State<GroupFormAdd> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupFormAdd> {
  late AppLocalizations locale;

  TextEditingController groupController = TextEditingController();
  TextEditingController errCont = TextEditingController();
  bool isloading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<GroupProvider>(context, listen: false).setModel(Group());
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: 300,
            height: 220,
            child: Material(
              color: Colors.transparent,
              child: Neumo(
                onlyBlackShaodw: true,
                border: 10,
                child: Stack(
                  children: [
                    Positioned(
                      top: 30,
                      left: 10,
                      child: InputField(
                        label: locale.group,
                        controller: groupController,
                        prefixicon: SvgPicture.asset(CustIcons.groups),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 10,
                      child: ButtonSubmit(
                          text: locale.submit,
                          onPressed: () async {
                            int err = 0;
                            if (groupController.text.isNotEmpty) {
                              setState(() {
                                isloading = true;
                              });
                              if (widget.isUpdate) {
                                err = await apiUpdateGroup(
                                    context, groupController.text, widget.gid);
                              } else {
                                err = await apiAddgroup(
                                    context, groupController.text);
                              }

                              if (err == Errors.unAuth) {
                                errCont.text = locale.errunauth;
                              } else if (err == Errors.none) {
                                errCont.text = '';
                                // ignore: use_build_context_synchronously
                                Group g = Provider.of<GroupProvider>(context,
                                        listen: false)
                                    .model;
                                // ignore: use_build_context_synchronously
                                Provider.of<GroupsProvider>(context,
                                        listen: false)
                                    .addModel(g);
                                g.name = groupController.text;
                                // ignore: use_build_context_synchronously
                                Provider.of<GroupProvider>(context,
                                        listen: false)
                                    .setModel(g);
                              } else if (err == Errors.badreq) {
                                errCont.text = locale.exists;
                              } else {
                                errCont.text = locale.errcrs;
                              }

                              setState(() {
                                isloading = false;
                              });
                            }
                            if (err == 0) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            }
                          }),
                    ),
                    Positioned(
                        top: 96,
                        left: 10,
                        child: ErrorField(err: errCont.text)),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isloading) const LoadingOverlay()
      ],
    );
  }
}
