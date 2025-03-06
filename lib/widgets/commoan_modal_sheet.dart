import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ticket/widgets/mediaquery.dart';

//Common Model Sheet to show failure, success etc. sheets
class CommonModalSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isButtonAvailable;
    final Function()? buttonOnTap;
  final String? buttonTitle;
  final String? imagePath;
  final Widget? loadingWidget;
  final Color? buttonFontColor;

  final Widget? subtitleWidget;
  final Widget? titleWidget;

  final Widget? buttonWidget;

  const CommonModalSheet(
      {super.key,
      required this.title,
      this.subtitle,
      this.isButtonAvailable = false,
      this.buttonOnTap,
      this.buttonTitle= "OK",
      this.imagePath,
      this.loadingWidget,
      this.buttonFontColor,
      this.subtitleWidget,
      this.titleWidget,
      this.buttonWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 32,
          ),
          loadingWidget != null ? loadingWidget! : const SizedBox(),
         
          const SizedBox(
            height: 12,
          ),
          titleWidget ??
              Text(title),
          const SizedBox(
            height: 6,
          ),
          subtitleWidget != null
              ? subtitleWidget!
              : subtitle != null
                  ?            Text(subtitle!)
                  : const SizedBox(),
          const SizedBox(
            height: 32,
          ),
       
        ],
      ),
    );
  }
}

//Common Loading Sheet whenever there is an ongoing process like API calls
class CommonLoadingSheet extends StatelessWidget {
  final String title;
  final String subtitle;

  final double? height;
  const CommonLoadingSheet({super.key, required this.title, required this.subtitle, this.height});

  @override
  Widget build(BuildContext context) {
    return CommonModalSheet(
      title: title,
      loadingWidget: const Center(
        child: SpinKitCircle(
          color: Colors.blue,
        ),
      ),
      subtitle: subtitle,
    );
  }
}
