import 'package:ffb_fe_flutter/app/resources/text_style.dart';
import 'package:flutter/material.dart';
import '/app/resources/responsive_utils.dart';

class AppBarCustom extends StatelessWidget {
  final Function callback;
  final String title;
  final Widget? trailing;
  const AppBarCustom({super.key, required this.callback, required this.title,this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: UtilsReponsive.height(20, context),
          right: UtilsReponsive.height(10, context),
          left: UtilsReponsive.height(10, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
                  onTap: () {
                  callback();
                  },
                  child: const Icon(Icons.arrow_back_ios_new),
                ),
          TextConstant.titleH2(context,
              text: title, fontWeight: FontWeight.w700),
          trailing??const SizedBox.shrink(),
        ],
      ),
    );
  }
}