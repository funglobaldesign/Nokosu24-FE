import 'package:flutter/material.dart';
import 'package:nokosu2023/Components/SubComponents/group_add_form.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupAddFolder extends StatefulWidget {
  final bool folderView;

  const GroupAddFolder({
    Key? key,
    this.folderView = false,
  }) : super(key: key);

  @override
  State<GroupAddFolder> createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAddFolder> {
  late AppLocalizations locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  GroupFormAdd(isFolderview: widget.folderView));
        },
        child: SizedBox(
          height: widget.folderView ? 120 : 80,
          width: widget.folderView ? 120 : 80,
          child: const Neumo(border: 10, child: Icon(Icons.add)),
        ),
      ),
    );
  }
}
