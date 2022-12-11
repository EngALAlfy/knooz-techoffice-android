import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

goTo(context, screen, {trans: PageTransitionType.leftToRight}) {
  return Navigator.of(context).push(PageTransition(child: screen, type: trans));
}

goToReplace(context, screen, {trans: PageTransitionType.leftToRight}) {
  return Navigator.of(context)
      .pushReplacement(PageTransition(child: screen, type: trans));
}

goToRemove(context, screen, {trans: PageTransitionType.leftToRight}) {
  return Navigator.of(context).pushAndRemoveUntil(
      PageTransition(child: screen, type: trans), (_) => false);
}
