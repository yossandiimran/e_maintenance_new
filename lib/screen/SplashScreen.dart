// ignore_for_file: file_names, prefer_const_constructors, avoid_print

part of '../header.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSplashScreen();
    fbmessaging.initFirebase(context: context);
  }

  checkSplashScreen() async {
    try {
      await preference.initialization();
      var name = await preference.getData("id");
      if (name != null) {
        if (mounted) Navigator.pushNamed(context, "/home");
      } else {
        if (mounted) Navigator.pushNamed(context, "/login");
      }
    } catch (err) {
      // print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui = CustomWidget();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        alert.alertConfirmExit(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: linearBg,
        body: Container(
          decoration: BoxDecoration(gradient: global.heroGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 24 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ui.linearPill(
                        icon: Icons.directions_car_filled_rounded,
                        label: "Vehicle routine monitoring",
                        color: global.surfaceL1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: ui.linearHeroDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 108,
                              height: 108,
                              padding: const EdgeInsets.all(18),
                              decoration: ui.linearCardDecoration(
                                radius: 30,
                                color: linearAccent.withValues(alpha: 0.12),
                              ),
                              child: Image.asset("assets/icon.png"),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            "E-Maintenance",
                            style: textStyling.linearDisplay(34),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Pusat kerja lapangan untuk inspeksi kendaraan, pelaporan, dan kontrol akses pengguna dalam satu alur yang lebih rapi.",
                            style: textStyling.linearBody(16, color: linearTextSecondary, height: 1.65),
                          ),
                          const SizedBox(height: 22),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ui.linearPill(icon: Icons.qr_code_scanner_rounded, label: "Scan serial kendaraan"),
                              ui.linearPill(icon: Icons.inventory_2_rounded, label: "Checklist inspeksi"),
                              ui.linearPill(icon: Icons.assessment_rounded, label: "Laporan transaksi"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        style: ui.linearPrimaryButtonStyle(),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: const Text("Mulai Sekarang"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Version $appVersion",
                      style: textStyling.linearCaption(12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
