// ignore_for_file: prefer_const_constructors, file_names, avoid_print, use_build_context_synchronously

part of '../header.dart';

class Alert {
  alertWarning({required context, required text}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: widget.linearCardDecoration(
                  radius: 20,
                  color: defOrange.withValues(alpha: 0.14),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: defOrange,
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "$text",
                textAlign: TextAlign.center,
                style: textStyling.linearBody(15, color: linearTextPrimary),
              ),
            ],
          ),
        );
      },
    );
  }

  alertSuccess({required context, required text}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: widget.linearCardDecoration(
                  radius: 20,
                  color: linearSuccess.withValues(alpha: 0.14),
                ),
                child: Icon(
                  Icons.check_circle_outline_outlined,
                  color: linearSuccess,
                  size: 32,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "$text",
                textAlign: TextAlign.center,
                style: textStyling.linearBody(15, color: linearTextPrimary),
              ),
            ],
          ),
        );
      },
    );
  }

  loadingAlert({required context, required text, required isPop}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: isPop,
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            content: SizedBox(
              width: 220,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 54,
                    height: 54,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: linearAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "$text",
                    textAlign: TextAlign.center,
                    style: textStyling.linearBody(15, color: linearTextPrimary),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  alertConfirmExit(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: SizedBox(
            width: 260,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Keluar dari aplikasi?",
                  textAlign: TextAlign.center,
                  style: textStyling.linearTitle(18, color: linearTextPrimary, strong: true),
                ),
                const SizedBox(height: 10),
                Text(
                  "Sesi saat ini akan ditutup di perangkat ini.",
                  textAlign: TextAlign.center,
                  style: textStyling.linearBody(14, color: linearTextTertiary),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => exit(0),
                        style: widget.linearPrimaryButtonStyle(backgroundColor: defRed),
                        child: const Text("Keluar"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: widget.linearGhostButtonStyle(),
                        child: const Text("Batal"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  alertLogout(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: SizedBox(
            width: 260,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Keluar dari akun Anda?",
                  textAlign: TextAlign.center,
                  style: textStyling.linearTitle(18, color: linearTextPrimary, strong: true),
                ),
                const SizedBox(height: 10),
                Text(
                  "Token perangkat akan dibersihkan lalu aplikasi kembali ke halaman masuk.",
                  textAlign: TextAlign.center,
                  style: textStyling.linearBody(14, color: linearTextTertiary),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                        var userId = preference.getData("id");
                        var url = await global.getBapiManualServiceUrl('unregdes?USERID=$userId');
                        print(url);
                        try {
                          await http.post(url).then((res) async {
                            print(res.statusCode);
                            var data = json.decode(res.body);
                            print(data);
                            if (res.statusCode == 200) {
                              preference.clearPreference();
                              return Navigator.pushReplacementNamed(context, '/');
                            }
                          }).timeout(const Duration(seconds: 100), onTimeout: () {
                            preference.clearPreference();
                            return Navigator.pushReplacementNamed(context, '/');
                          }).catchError((err1) {
                            preference.clearPreference();
                            return Navigator.pushReplacementNamed(context, '/');
                          });
                        } catch (err2) {
                          preference.clearPreference();
                          Navigator.pushReplacementNamed(context, '/');
                        }
                        },
                        style: widget.linearPrimaryButtonStyle(backgroundColor: defRed),
                        child: const Text("Logout"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: widget.linearGhostButtonStyle(),
                        child: const Text("Batal"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BadgeIconNotif extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;
  final int notificationCount;

  const BadgeIconNotif({
    Key? key,
    required this.onTap,
    required this.iconData,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData),
              ],
            ),
            notificationCount != 0
                ? Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                      alignment: Alignment.center,
                      child: Text('$notificationCount'),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
