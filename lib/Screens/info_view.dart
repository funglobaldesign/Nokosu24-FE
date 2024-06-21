// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nokosu2023/Components/SubComponents/info_render.dart';
import 'package:nokosu2023/Components/bar_top.dart';
import 'package:nokosu2023/Components/info_update.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/group_provider.dart';
import 'package:nokosu2023/providers/home_state.dart';
import 'package:nokosu2023/providers/profile_provider.dart';
import 'package:nokosu2023/providers/token_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:screenshot/screenshot.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InfoView extends StatefulWidget {
  final Info info;
  final Image image;

  const InfoView({
    Key? key,
    required this.info,
    required this.image,
  }) : super(key: key);

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  late AppLocalizations locale;

  bool infosReady = false;
  String creatroName = '';
  Image creatorpfp = Image.asset(Imgs.pfp);
  late Uint8List infoRenderedImageData;
  ScreenshotController screenshotController = ScreenshotController();
  Group thisgroup = Group();

  Future<void> getData() async {
    try {
      await apiGetProfile(context, widget.info.createdBy!);
      await apiGetGroups(context);

      creatroName = Provider.of<ProfileProvider>(context, listen: false)
          .profile
          .user!
          .username!;
      String pfp =
          Provider.of<ProfileProvider>(context, listen: false).profile.url!;
      if (pfp.isNotEmpty) {
        final response = await http.get(Uri.parse(pfp));
        if (response.statusCode == 200) {
          final imageData = response.bodyBytes;
          creatorpfp = Image.memory(
            imageData,
            fit: BoxFit.cover,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    Provider.of<HomeStateProvider>(context, listen: false).setState(1);
    getData().then((_) async {
      try {
        screenshotController
            .captureFromWidget(
          InfoRender.getRenderer(
              widget.info, creatroName, creatorpfp, widget.image),
        )
            .then((capturedImage) {
          infoRenderedImageData = capturedImage;
          List<Group> groups =
              Provider.of<GroupsProvider>(context, listen: false).models;
          for (var group in groups) {
            if (group.id == widget.info.group!) {
              thisgroup = group;
              break;
            }
          }
          infosReady = true;
          setState(() {});
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    int currentId = Provider.of<TokenProvider>(context, listen: false).id;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ScrollController scrollController = ScrollController();
    return WillPopScope(
      onWillPop: () async {
        if (infosReady) {
          RedirectFunctions.redirectHome(context);
        }
        return true;
      },
      child: Scaffold(
        appBar: null,
        backgroundColor: ThemeColours.bgBlueWhite,
        body: Scrollbar(
          controller: scrollController,
          thumbVisibility: false,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Stack(
                    children: [
                      TopBar(
                        backBtn: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            if (infosReady) {
                              RedirectFunctions.redirectInfoFolders(
                                  context, thisgroup);
                            }
                          },
                        ),
                        location: [
                          widget.info.latitude!,
                          widget.info.longitude!
                        ],
                        infoView: true,
                        camkey: GlobalKey(),
                        rightmiddleIcon: currentId == widget.info.createdBy
                            ? IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  if (infosReady) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          InfoEditPage(
                                        info: widget.info,
                                        image: widget.image,
                                        group: thisgroup,
                                      ),
                                    );
                                  }
                                },
                              )
                            : const SizedBox(),
                        middleIcon: IconButton(
                          icon: const Icon(Icons.download_sharp),
                          onPressed: () async {
                            if (infosReady) {
                              String msg = '';
                              int e = await Gallery.saveImage(
                                infoRenderedImageData,
                                DeviseMemory.foldername,
                              );
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
                            }
                          },
                        ),
                        leftmiddleIcon: currentId == widget.info.createdBy
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (infosReady) {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                              '${locale.deleteconf} : ${widget.info.topic!}'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                RedirectFunctions
                                                    .redirectInfoView(
                                                        context,
                                                        widget.info,
                                                        widget.image);
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
                                                int e = await apiDelInfo(
                                                    context, widget.info.id!);
                                                if (e == Errors.none) {
                                                  msg = locale.deleted;
                                                } else {
                                                  msg = locale.errcrs;
                                                }
                                                Fluttertoast.showToast(
                                                  msg: msg,
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      ThemeColours.bgWhite,
                                                  textColor:
                                                      ThemeColours.txtGrey,
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

                                    RedirectFunctions.redirectInfoFolders(
                                        context, thisgroup);
                                  }
                                },
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  height: height,
                  width: width,
                  child: infosReady
                      ? IntrinsicHeight(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0,
                                  color: Colors.transparent,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 8,
                                      offset: const Offset(-3, -3),
                                      color: ThemeColours.shadowDark
                                          .withOpacity(0.1)),
                                  BoxShadow(
                                    blurRadius: 8,
                                    offset: const Offset(3, 3),
                                    color: ThemeColours.shadowDark
                                        .withOpacity(0.1),
                                  ),
                                ]),
                            child: Image.memory(
                              infoRenderedImageData,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : const LoadingOverlay(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
