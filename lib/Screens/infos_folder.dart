// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nokosu2023/Components/SubComponents/group_add_form.dart';
import 'package:nokosu2023/Components/bar_bottom.dart';
import 'package:nokosu2023/Components/bar_top.dart';
import 'package:nokosu2023/Components/info_preview.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/group_provider.dart';
import 'package:nokosu2023/providers/home_state.dart';
import 'package:nokosu2023/providers/info_provider.dart';
import 'package:nokosu2023/providers/profile_provider.dart';
import 'package:nokosu2023/providers/token_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class InfoFolderScreen extends StatefulWidget {
  final Group group;

  const InfoFolderScreen({
    Key? key,
    required this.group,
  }) : super(key: key);
  @override
  InfoFolderScreenState createState() => InfoFolderScreenState();
}

class InfoFolderScreenState extends State<InfoFolderScreen> {
  List<Info> infos = [];
  bool infosReady = false;
  String creator = '';
  late List<Widget> infoWidgets;

  late AppLocalizations locale;

  Future<void> getInfos() async {
    await apiGetProfile(context, widget.group.createdBy!);
    await apiGetGroup(context, widget.group.id!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    Provider.of<HomeStateProvider>(context, listen: false).setState(1);
    getInfos().then((_) async {
      try {
        infos = Provider.of<InfosProvider>(context, listen: false).models;

        creator = Provider.of<ProfileProvider>(context, listen: false)
            .profile
            .user!
            .username!;

        infosReady = true;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int currentId = Provider.of<TokenProvider>(context, listen: false).id;
    infoWidgets = infos
        .map((info) => InfoPrevFolder(
              info: info,
            ))
        .toList();
    return WillPopScope(
        onWillPop: () async {
          RedirectFunctions.redirectFolders(context);
          return false;
        },
        child: Scaffold(
          appBar: null,
          backgroundColor: ThemeColours.bgBlueWhite,
          body: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: infosReady
                      ? Column(
                          children: [
                            Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: ThemeColours.bgBlueWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                      color: ThemeColours.shadowDark
                                          .withOpacity(0.5),
                                    ),
                                  ]),
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: IconButton(
                                        onPressed: () {
                                          RedirectFunctions.redirectFolders(
                                              context);
                                        },
                                        icon: const Icon(Icons.arrow_back)),
                                  ),
                                  Center(
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      constraints: const BoxConstraints(
                                        maxWidth: 200,
                                      ),
                                      child: Text(
                                        widget.group.name!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: ThemeColours.txtBlack,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.none,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: GridView.count(
                                padding: const EdgeInsets.all(20),
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                crossAxisCount: 3,
                                childAspectRatio: 0.58,
                                children: infoWidgets,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${locale.createdby} : $creator',
                                      style: const TextStyle(
                                        color: ThemeColours.txtGrey,
                                        decoration: TextDecoration.none,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd HH:mm')
                                          .format(widget.group.created!),
                                      style: const TextStyle(
                                        color: ThemeColours.txtGrey,
                                        decoration: TextDecoration.none,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const LoadingOverlay(),
                ),
              ),
              TopBar(
                backBtn: const SizedBox(),
                camkey: GlobalKey(),
                rightmiddleIcon: currentId == widget.group.createdBy
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          if (infosReady) {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) => GroupFormAdd(
                                      isUpdate: true,
                                      gid: widget.group.id!,
                                    ));

                            if (Provider.of<GroupProvider>(context,
                                        listen: false)
                                    .model
                                    .name !=
                                null) {
                              setState(() {
                                widget.group.name = Provider.of<GroupProvider>(
                                        context,
                                        listen: false)
                                    .model
                                    .name;
                              });
                            }
                          }
                        },
                      )
                    : const SizedBox(),
                middleIcon: IconButton(
                  icon: const Icon(Icons.download_sharp),
                  onPressed: () async {
                    OverlayEntry overlayEntry = OverlayEntry(
                        builder: (context) => const LoadingOverlay());

                    if (infosReady) {
                      Overlay.of(context).insert(overlayEntry);
                      String msg = '';
                      int e = await Gallery.saveFolder(
                          context, infos, widget.group.name!, locale);
                      if (e == 0) {
                        msg = locale.savedimage;
                      } else {
                        msg = locale.errnosave;
                      }
                      Fluttertoast.showToast(
                        msg: msg,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: ThemeColours.bgWhite,
                        textColor: ThemeColours.txtGrey,
                        fontSize: 16.0,
                      );
                      overlayEntry.remove();
                    }
                  },
                ),
                leftmiddleIcon: currentId == widget.group.createdBy
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          if (infosReady) {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      '${locale.deleteconf} : ${widget.group.name!}'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        RedirectFunctions.redirectInfoFolders(
                                            context, widget.group);
                                      },
                                      child: Text(locale.no),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        OverlayEntry overlayEntry =
                                            OverlayEntry(
                                                builder: (context) =>
                                                    const LoadingOverlay());
                                        Overlay.of(context)
                                            .insert(overlayEntry);

                                        String msg = '';
                                        int e = await apiDelGroup(
                                            context, widget.group.id!);
                                        if (e == Errors.none) {
                                          msg = locale.deleted;
                                        } else {
                                          msg = locale.errcrs;
                                        }
                                        Fluttertoast.showToast(
                                          msg: msg,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: ThemeColours.bgWhite,
                                          textColor: ThemeColours.txtGrey,
                                          fontSize: 16.0,
                                        );
                                        overlayEntry.remove();
                                      },
                                      child: Text(locale.yes),
                                    ),
                                  ],
                                );
                              },
                            );
                            RedirectFunctions.redirectFolders(context);
                          }
                        },
                      )
                    : const SizedBox(),
              ),
              const BottomBar(),
            ],
          ),
        ));
  }
}
