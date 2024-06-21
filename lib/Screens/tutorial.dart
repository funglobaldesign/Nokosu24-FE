import 'package:flutter/material.dart';
import 'package:nokosu2023/Components/Tutorial/page.dart';
import 'package:nokosu2023/Components/button_submit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:nokosu2023/utils/constants.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);
  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  late PageController _pageController;
  int currentPage = 0;
  late AppLocalizations locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
          });
        },
        children: const [
          TPage(
            img: Imgs.p1,
          ),
          TPage(
            img: Imgs.p2,
          ),
          TPage(
            img: Imgs.p3,
          ),
          TPage(
            img: Imgs.p4,
          ),
          TPage(
            img: Imgs.p5,
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 15),
        child: Stack(
          children: [
            Positioned(
                left: width * 0.05,
                bottom: height * 0.01,
                child: GestureDetector(
                  onTap: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Container(
                    height: height * 0.22,
                    width: width * 0.42,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(bottom: height * 0.16, left: 20),
                    child: const Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('< Back'),
                    ),
                  ),
                )),
            Positioned(
              right: width * 0.05 - 15,
              bottom: height * 0.01,
              child: GestureDetector(
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
                child: Container(
                  height: height * 0.22,
                  width: width * 0.42,
                  color: Colors.transparent,
                  padding: EdgeInsets.only(bottom: height * 0.16, right: 20),
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: Text('Next >'),
                  ),
                ),
              ),
            ),
            Positioned(
              width: width,
              bottom: height * 0.05,
              child: Center(
                child: ButtonSubmit(
                  text: locale.home,
                  onPressed: () {
                    RedirectFunctions.redirectHome(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
