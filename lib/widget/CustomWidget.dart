// ignore_for_file: file_names, prefer_const_constructors,, prefer_interpolation_to_compose_strings

part of '../header.dart';

class CustomWidget {
  radiusVal(radius) => Radius.circular(radius);

  BoxDecoration linearPanelDecoration({
    double radius = 24,
    Color? color,
    bool elevated = true,
    bool inset = false,
  }) {
    return BoxDecoration(
      color: color ?? global.surfaceL1,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: global.borderStandard),
      boxShadow: [
        if (elevated)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        if (inset)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 14,
            spreadRadius: -8,
          ),
      ],
    );
  }

  BoxDecoration linearCardDecoration({
    double radius = 20,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? global.surfaceL1,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: global.borderSubtle),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  BoxDecoration linearHeroDecoration() {
    return BoxDecoration(
      gradient: global.heroGradient,
      border: Border.all(color: global.borderSubtle),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: linearAccent.withValues(alpha: 0.08),
          blurRadius: 30,
          offset: const Offset(0, 18),
        ),
      ],
    );
  }

  InputDecoration linearInputDecoration({
    required String label,
    String? hint,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: linearTextTertiary) : null,
      suffixIcon: suffix,
    );
  }

  ButtonStyle linearPrimaryButtonStyle({Color? backgroundColor}) {
    return FilledButton.styleFrom(
      backgroundColor: backgroundColor ?? linearBrand,
      foregroundColor: linearTextPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: textStyling.linearBody(15, color: linearTextPrimary, emphasis: true),
    );
  }

  ButtonStyle linearGhostButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: linearTextSecondary,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      side: BorderSide(color: global.borderStandard),
      backgroundColor: global.surfaceL1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      textStyle: textStyling.linearBody(14, color: linearTextSecondary, emphasis: true),
    );
  }

  Widget linearPill({
    required IconData icon,
    required String label,
    Color? color,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? global.surfaceL1,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: global.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor ?? linearTextSecondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: textStyling.linearCaption(12, color: textColor ?? linearTextSecondary, emphasis: true),
          ),
        ],
      ),
    );
  }

  appBarTitle(context, title, color) {
    return AppBar(
      backgroundColor: color,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Container(
        margin: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
        decoration: linearCardDecoration(radius: 16, color: global.surfaceL1),
        padding: const EdgeInsets.all(10),
        child: Image.asset("assets/icon.png"),
      ),
      title: Text(
        title,
        style: textStyling.linearTitle(18, color: linearTextPrimary, strong: true),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_on_rounded, color: linearAccent),
        ),
      ],
    );
  }

  bgAppbar(context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: kToolbarHeight, left: 20, right: 20),
            height: kToolbarHeight * 2,
            decoration: BoxDecoration(
              gradient: global.heroGradient,
            ),
          ),
        ],
      ),
    );
  }

  getBottomApp({required context, required action}) {
    return Container(
      width: global.getWidth(context),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: decorationGradient3Color(Colors.lightBlue, defBlue, 0.0, 0.0, 50.0, 50.0),
      child: ListTile(
        title: Text(
          "Versi $appVersion ©2022 Central Developer",
          textAlign: TextAlign.center,
          style: textStyling.customColor(14, defWhite),
        ),
        trailing: IconButton(
          onPressed: () {
            if (action == 'pop') Navigator.pop(context);
            if (action == 'logout') alert.alertLogout(context);
          },
          icon: action == 'pop' ? Icon(Icons.arrow_back_ios, color: defWhite) : Icon(Icons.logout, color: Colors.red),
        ),
      ),
    );
  }

  getBottomApp2({required context, required action}) {
    return Container(
      width: global.getWidth(context),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: decorationGradient3Color(Colors.lightBlue, defBlue, 0.0, 0.0, 50.0, 0.0),
      child: ListTile(
        title: Text(
          "Versi $appVersion ©2023 Central Developer",
          textAlign: TextAlign.center,
          style: textStyling.customColor(14, defWhite),
        ),
        trailing: IconButton(
          onPressed: () {
            if (action == 'pop') Navigator.pop(context);
            if (action == 'logout') alert.alertLogout(context);
          },
          icon: action == 'pop' ? Icon(Icons.arrow_back_ios, color: defWhite) : Icon(Icons.logout, color: Colors.red),
        ),
      ),
    );
  }

  getWidgetMenu2({required context, routeName, title, color, icon, colorIcon, menuCode, image}) {
    return GestureDetector(
      onTap: () {
        if (routeName == 'back') {
          Navigator.pop(context);
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Container(
        decoration: decCont(defWhite, 20, 20, 20, 20),
        margin: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 5),
        height: kToolbarHeight + 30,
        width: global.getWidth(context),
        child: Row(
          children: [
            Container(
              height: kToolbarHeight + 30,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(image: image, fit: BoxFit.contain, scale: 0.5),
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Spacer(),
            Text(title, textAlign: TextAlign.center, style: textStyling.nunitoBold(16, colorIcon)),
            Spacer(),
          ],
        ),
      ),
    );
  }

  getWidgetMenu3({required context, routeName, title, color, icon, colorIcon, menuCode}) {
    return GestureDetector(
      onTap: () {
        if (routeName == 'back') {
          Navigator.pop(context);
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Container(
        decoration: decCont(defWhite, 20, 20, 20, 20),
        margin: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 5),
        height: kToolbarHeight + 30,
        width: global.getWidth(context),
        child: Row(
          children: [
            Container(
              height: kToolbarHeight + 30,
              width: 70,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(icon, color: defWhite, size: 30),
            ),
            Spacer(),
            Text(title, textAlign: TextAlign.center, style: textStyling.nunitoBold(16, colorIcon)),
            Spacer(),
          ],
        ),
      ),
    );
  }

  decorationContainer1(color, radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(radiusVal(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationContainer2(color, radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(radiusVal(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationContainerGradient(color1, color2, radius) {
    return BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color1, color2]),
      borderRadius: BorderRadius.all(radiusVal(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationGradient3Color(color1, color2, bl, br, tl, tr) {
    return BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color1, color2]),
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(bl),
        topLeft: radiusVal(tl),
        topRight: radiusVal(tr),
        bottomRight: radiusVal(br),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationGradient4Color(color1, color2, color3, bl, br, tl, tr) {
    return BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color1, color2, color3]),
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(bl),
        topLeft: radiusVal(tl),
        topRight: radiusVal(tr),
        bottomRight: radiusVal(br),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decCont(color, double radiusBl, double radiusBr, double radiusTl, double radiusTr) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(radiusBl),
        bottomRight: radiusVal(radiusBr),
        topLeft: radiusVal(radiusTl),
        topRight: radiusVal(radiusTr),
      ),
    );
  }

  decCont2(color, double radiusBl, double radiusBr, double radiusTl, double radiusTr) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(radiusBl),
        bottomRight: radiusVal(radiusBr),
        topLeft: radiusVal(radiusTl),
        topRight: radiusVal(radiusTr),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decCont3(color, double radiusBl, double radiusBr, double radiusTl, double radiusTr) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(radiusBl),
        bottomRight: radiusVal(radiusBr),
        topLeft: radiusVal(radiusTl),
        topRight: radiusVal(radiusTr),
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 3),
        ),
      ],
    );
  }

  textInputDecoration(name, icon, colors) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: colors) : null,
      labelText: name,
      labelStyle: TextStyle(color: defBlue),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
    );
  }

  textInputDecoration2(name, icon, colors) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: colors) : null,
      hintText: name,
      labelStyle: TextStyle(color: defBlue),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
    );
  }

  getChoicePopUp(context) {
    return {'Logout'}.map((String choice) {
      return PopupMenuItem<String>(
        value: choice,
        child: Row(
          children: [
            Icon(
              choice == "Logout" ? Icons.logout : Icons.settings,
              color: choice == "Logout" ? defRed : defBlue,
            ),
            Text("  $choice")
          ],
        ),
      );
    }).toList();
  }

  getImageBgSugar(context) {
    return Positioned(
      top: kToolbarHeight * 2,
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(left: global.getWidth(context) / 2),
            height: kToolbarHeight * 4,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/ic1bg.png")),
            ),
          )
        ],
      ),
    );
  }

  getItemsDropdown(selection, data) {
    List<DropdownMenuItem<String>> widget = [];
    if (selection == "server") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Server", style: textStyling.defaultBlack(13))));
      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          widget.add(
            DropdownMenuItem(
              value: (i + 1).toString(),
              child: Text(data[i]["description"], style: textStyling.defaultBlack(13)),
            ),
          );
        }
      }
    } else if (selection == "jenisVendor") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Jenis Vendor", style: textStyling.defaultBlack(13))));
      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          widget.add(
            DropdownMenuItem(
              value: (i + 1).toString(),
              child: Text(data[i]["jenis_vendor"], style: textStyling.defaultBlack(13)),
            ),
          );
        }
      }
    } else if (selection == "compCode") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Company Code", style: textStyling.defaultBlack(13))));
      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          widget.add(
            DropdownMenuItem(
              value: (i + 1).toString(),
              child: Text(data[i]["deskripsi"], style: textStyling.defaultBlack(13)),
            ),
          );
        }
      }
    } else if (selection == "purchOrg") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Purch Org", style: textStyling.defaultBlack(13))));
      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          widget.add(
            DropdownMenuItem(
              value: (i + 1).toString(),
              child: Text(data[i]["deskripsi"], style: textStyling.defaultBlack(13)),
            ),
          );
        }
      }
    } else if (selection == "kodeNegara") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Kode Negara", style: textStyling.defaultBlack(13))));
      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          widget.add(
            DropdownMenuItem(
              value: (i + 1).toString(),
              child: Text(data[i]["name"], style: textStyling.defaultBlack(13)),
            ),
          );
        }
      }
    } else if (selection == "kodeBank") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Kode Bank", style: textStyling.defaultBlack(13))));
      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          widget.add(
            DropdownMenuItem(
              value: (i + 1).toString(),
              child: Text(data[i]["deskripsi"], style: textStyling.defaultBlack(13)),
            ),
          );
        }
      }
    } else if (selection == "lamaPembayaran") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Lama Pembyayaran", style: textStyling.defaultBlack(13))));
      if (data != null) {
        for (var i = 0; i < data.length; i++) {
          widget.add(
            DropdownMenuItem(
              value: (i + 1).toString(),
              child: Text(data[i]["deskripsi"], style: textStyling.defaultBlack(13)),
            ),
          );
        }
      }
    } else if (selection == "mataUang") {
      widget.add(DropdownMenuItem(value: "0", child: Text("Mata Uang", style: textStyling.defaultBlack(13))));
      widget.add(DropdownMenuItem(value: "USD", child: Text("USD - US Dollar", style: textStyling.defaultBlack(13))));
      widget.add(DropdownMenuItem(value: "RP", child: Text("Rp - IDR Rupiah", style: textStyling.defaultBlack(13))));
      widget.add(DropdownMenuItem(value: "YEN", child: Text("¥ - Yen Japan", style: textStyling.defaultBlack(13))));
      widget
          .add(DropdownMenuItem(value: "YUAN", child: Text("YUAN - Yuan China", style: textStyling.defaultBlack(13))));
      widget.add(
        DropdownMenuItem(value: "MYR", child: Text("MYR - Malaysia Ringgit", style: textStyling.defaultBlack(13))),
      );
    }
    return widget;
  }
}
