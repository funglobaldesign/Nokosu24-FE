import 'package:flutter/material.dart';
import 'package:nokosu2023/Components/SubComponents/group.dart';
import 'package:nokosu2023/Components/SubComponents/group_add.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/group_provider.dart';
import 'package:provider/provider.dart';

class GroupsSelect extends StatefulWidget {
  final TextEditingController groupController;
  final TextEditingController groupNameController;

  const GroupsSelect({
    Key? key,
    required this.groupController,
    required this.groupNameController,
  }) : super(key: key);

  @override
  State<GroupsSelect> createState() => _GroupsSelectState();
}

class _GroupsSelectState extends State<GroupsSelect> {
  List<Group> groups = [];
  late List<Widget> groupWidgets;

  bool groupsReady = false;

  Future<void> getGroups() async {
    await apiGetGroups(context);
  }

  @override
  void initState() {
    super.initState();
    getGroups().then((_) async {
      groups = Provider.of<GroupsProvider>(context, listen: false).models;
      groupsReady = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    groupWidgets = groups
        .map((group) => GroupFolder(
              group: group,
              groupController: widget.groupController,
              groupNameController: widget.groupNameController,
            ))
        .toList();

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Neumo(
          onlyBlackShaodw: true,
          border: 10,
          child: groupsReady
              ? GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: [...groupWidgets, const GroupAddFolder()])
              : const LoadingOverlay(),
        ),
      ),
    );
  }
}
