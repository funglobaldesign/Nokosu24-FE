import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:intl/intl.dart';

abstract class InfoRender {
  static Widget getRenderer(
      Info info, String creator, Image pfp, Image infoimage) {
    double fixedheight = 800;
    double fixedwidth = 400;
    return Container(
      height: fixedheight,
      width: fixedwidth,
      decoration: BoxDecoration(
        color: ThemeColours.bgBlueWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 0,
          color: Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 400,
            height: 550,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: infoimage,
            ),
          ),
          Container(
            height: 20,
            width: fixedwidth,
            color:
                info.positive! ? ThemeColours.positive : ThemeColours.negative,
            child: Text(
              info.positive! ? 'Positive' : 'Negative',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColours.txtWhite.withOpacity(0.3),
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            height: 50,
            width: fixedwidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: info.emotion!
                              ? ThemeColours.positive
                              : ThemeColours.negative,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: SvgPicture.asset(
                          info.emotion!
                              ? CustIcons.emotional
                              : CustIcons.emotionalnon,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn)),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: info.physical!
                              ? ThemeColours.positive
                              : ThemeColours.negative,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: SvgPicture.asset(
                          info.physical!
                              ? CustIcons.physical
                              : CustIcons.physicalnon,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn)),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: info.cultural!
                              ? ThemeColours.positive
                              : ThemeColours.negative,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: SvgPicture.asset(
                          info.cultural!
                              ? CustIcons.cultural
                              : CustIcons.culturalnon,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn)),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.add_location_alt_outlined),
                    Column(
                      children: [
                        Text(info.address!,
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w200,
                                color: ThemeColours.txtBlack)),
                        Text(info.location!,
                            style:
                                const TextStyle(color: ThemeColours.txtBlack)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            width: fixedwidth,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.topic!,
                  style: const TextStyle(
                    color: ThemeColours.txtBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    info.description!,
                    style: const TextStyle(
                      color: ThemeColours.txtBlack,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            width: fixedwidth,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d, y h:mm a').format(info.created!),
                  style: const TextStyle(
                    color: ThemeColours.txtBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    decoration: TextDecoration.none,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 0.6,
                        ),
                      ),
                      child: ClipOval(
                        child: pfp,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      creator,
                      style: const TextStyle(
                        color: ThemeColours.txtBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        decoration: TextDecoration.none,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
