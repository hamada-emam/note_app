import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

var isDialOpen = ValueNotifier<bool>(false);
var customDialRoot = false;
var visible = true;
var switchLabelPosition = true;
var extend = false;
var rmicons = false;
var closeManually = false;
var useRAnimation = true;
var speedDialDirection = SpeedDialDirection.down;
var buttonSize = const Size(56.0, 56.0);
var childrenButtonSize = const Size(56.0, 56.0);
var selectedfABLocation = FloatingActionButtonLocation.startFloat;
var renderOverlay = false;
//خد بالك من الايرور اللي هيجي هنا لو جيت تدي الكونتينير او اي وعاد طول انفينيتي لان هنا انت بتسكرول فخد بالك ان الاسكرول ملهوش نهايه فلازم تحددان الطول هعلي حسب حجم الجهاز وده مكتوب ف الملف اللي فيه حساب الطول والعرض بتاع الجهاز
SliverAppBar sliverCustomAppBar(context, List<SpeedDialChild> list) {
  return SliverAppBar(

     leading:  Padding(
       padding: const EdgeInsets.only(left: 8.0),
       child: floatingActionbuttonAnimate(context, list),
     ),


    elevation: 30,
    forceElevated: true,
    shadowColor: Colors.black87,
    expandedHeight: 60,
    // use Expanded to have more space
    title: Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        "Tasks",
        style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade900),
      ),
    ),
     centerTitle: true,
    backgroundColor: Colors.transparent,
  );
}

SpeedDial floatingActionbuttonAnimate(
    BuildContext context, List<SpeedDialChild> list) {
  return SpeedDial(
    //backgroundColor: Colors.blueGrey.shade900,
    animatedIcon: AnimatedIcons.menu_close,
    animatedIconTheme: const IconThemeData(size: 25.0),
    // / This is ignored if animatedIcon is non null
    child: const Text("open"),
    activeChild: const Text("close"),
    icon: Icons.add,
    activeIcon: Icons.close,
    spacing: 3,
    openCloseDial: isDialOpen,
    childPadding: const EdgeInsets.all(5),
    spaceBetweenChildren: 4,
    dialRoot: customDialRoot
        ? (ctx, open, toggleChildren) {
            return ElevatedButton(
              onPressed: toggleChildren,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[900],
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              ),
              child: const Text(
                "Custom Dial Root",
                style: TextStyle(fontSize: 17),
              ),
            );
          }
        : null,
    buttonSize: buttonSize,
    // it's the SpeedDial size which defaults to 56 itself
    // iconTheme: IconThemeData(size: 22),
    label: extend ? const Text("Open") : null,
    // The label of the main button.
    /// The active label of the main button, Defaults to label if not specified.
    activeLabel: extend ? const Text("Close") : null,

    /// Transition Builder between label and activeLabel, defaults to FadeTransition.
    // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
    /// The below button size defaults to 56 itself, its the SpeedDial childrens size
    childrenButtonSize: childrenButtonSize,
    visible: visible,
    direction: speedDialDirection,
    switchLabelPosition: switchLabelPosition,

    /// If true user is forced to close dial manually
    closeManually: closeManually,

    /// If false, backgroundOverlay will not be rendered.
    renderOverlay: renderOverlay,
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    onOpen: () => debugPrint('OPENING DIAL'),
    onClose: () => debugPrint('DIAL CLOSED'),
    useRotationAnimation: useRAnimation,
    tooltip: 'Open Speed Dial',
    heroTag: 'speed-dial-hero-tag',
    // foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    activeForegroundColor: Colors.red,
    activeBackgroundColor: Colors.blueGrey.shade900,
    elevation: 20.0,
    isOpenOnStart: false,
    animationSpeed: 100,
    shape:
        customDialRoot ? const RoundedRectangleBorder() : const StadiumBorder(),
    // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    children: list,
  );
}
