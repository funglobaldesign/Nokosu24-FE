import 'package:flutter/material.dart';
import 'package:nokosu2023/Components/SubComponents/group.dart';
import 'package:nokosu2023/Components/SubComponents/group_add.dart';
import 'package:nokosu2023/Components/bar_bottom.dart';
import 'package:nokosu2023/Components/bar_top.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/group_provider.dart';
import 'package:nokosu2023/providers/home_state.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:provider/provider.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({Key? key}) : super(key: key);
  @override
  FolderScreenState createState() => FolderScreenState();
}

class FolderScreenState extends State<FolderScreen> {
  List<Group> groups = [];
  late List<Widget> groupWidgets;

  bool groupsReady = false;

  Future<void> getGroups() async {
    await apiGetGroups(context);
  }

  @override
  void initState() {
    Provider.of<HomeStateProvider>(context, listen: false).setState(1);

    getGroups().then((_) async {
      groups = Provider.of<GroupsProvider>(context, listen: false).models;
      groupsReady = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    groupWidgets = groups
        .map((group) => GroupFolder(
              group: group,
              groupController: TextEditingController(),
              groupNameController: TextEditingController(),
              folderView: true,
            ))
        .toList();
    return WillPopScope(
      onWillPop: () async {
        Provider.of<HomeStateProvider>(context, listen: false).setState(0);
        RedirectFunctions.redirectHome(context);
        return true;
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
                child: groupsReady
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Expanded(
                            child: GridView.count(
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              crossAxisCount: 3,
                              children: [
                                ...groupWidgets,
                                const GroupAddFolder(folderView: true)
                              ],
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
              middleIcon: const SizedBox(),
              rightmiddleIcon: const SizedBox(),
              leftmiddleIcon: const SizedBox(),
            ),
            const BottomBar(),
          ],
        ),
      ),
    );
  }
}
