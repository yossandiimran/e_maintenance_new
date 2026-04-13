// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, no_logic_in_create_state, avoid_print, avoid_unnecessary_containers, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member, prefer_interpolation_to_compose_strings
part of '../../header.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List listPengajuan = ["pengajuan1"];
  @override
  void initState() {
    super.initState();
  }

  bool get _isRestrictedUser => preference.getData("id_jenis_user").toString() == "4";

  void _openProtectedRoute(String routeName) {
    if (_isRestrictedUser) {
      alert.alertWarning(context: context, text: "Anda tidak memiliki akses");
      return;
    }
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final ui = CustomWidget();
    final userName = preference.getData("nama").toString();
    final currentHost = preference.getData("globalIp") ?? global.baseIp;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        alert.alertConfirmExit(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: linearBg,
        body: Container(
          decoration: BoxDecoration(gradient: global.heroGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ui.linearPill(
                              icon: Icons.warehouse_rounded,
                              label: "Host $currentHost",
                            ),
                            const SizedBox(height: 16),
                            Text("Workspace", style: textStyling.linearDisplay(34)),
                            const SizedBox(height: 8),
                            Text(
                              "Selamat datang kembali, $userName",
                              style: textStyling.linearBody(16, color: linearTextSecondary),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_horiz_rounded, color: linearTextPrimary),
                        onSelected: (value) async {
                          if (value == "Logout") {
                            alert.alertLogout(context);
                          } else {
                            var token = await FirebaseMessaging.instance.getToken();
                            print(token);
                          }
                        },
                        itemBuilder: (BuildContext context) => widget.getChoicePopUp(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: ui.linearHeroDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Operasional harian kendaraan", style: textStyling.linearTitle(22, strong: true)),
                        const SizedBox(height: 8),
                        Text(
                          "Akses cepat ke checklist inspeksi, laporan transaksi, laporan user, dan administrasi akun.",
                          style: textStyling.linearBody(15, color: linearTextSecondary, height: 1.65),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildStatPill(Icons.qr_code_scanner_rounded, "Scan & inspeksi"),
                            _buildStatPill(Icons.assessment_rounded, "Report monitoring"),
                            _buildStatPill(
                              _isRestrictedUser ? Icons.lock_outline_rounded : Icons.verified_user_rounded,
                              _isRestrictedUser ? "Akses operator" : "Akses admin",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Menu utama", style: textStyling.linearTitle(18, strong: true)),
                  const SizedBox(height: 8),
                  Text(
                    "Setiap area kerja disusun sebagai card ringkas agar lebih cepat dipindai di mobile.",
                    style: textStyling.linearBody(14, color: linearTextTertiary),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 720;
                      return Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          SizedBox(
                            width: isWide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth,
                            child: _buildMenuCard(
                              icon: Icons.qr_code_scanner_rounded,
                              accent: linearAccent,
                              title: "Cek kendaraan",
                              subtitle: "Scan serial number dan lanjutkan checklist inspeksi rutin.",
                              asset: "assets/barcode.png",
                              onTap: openQrPage,
                            ),
                          ),
                          SizedBox(
                            width: isWide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth,
                            child: _buildMenuCard(
                              icon: Icons.receipt_long_rounded,
                              accent: linearBrand,
                              title: "Laporan transaksi",
                              subtitle: "Lihat dan ekspor histori transaksi inspeksi kendaraan.",
                              asset: "assets/printer.png",
                              onTap: () => _openProtectedRoute('/lap1'),
                            ),
                          ),
                          SizedBox(
                            width: isWide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth,
                            child: _buildMenuCard(
                              icon: Icons.people_alt_rounded,
                              accent: defOrange,
                              title: "Laporan user",
                              subtitle: "Audit aktivitas user dan ringkasan penggunaan aplikasi.",
                              asset: "assets/maintenance_planning.png",
                              onTap: () => _openProtectedRoute('/lap2'),
                            ),
                          ),
                          SizedBox(
                            width: isWide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth,
                            child: _buildMenuCard(
                              icon: Icons.manage_accounts_rounded,
                              accent: linearSuccess,
                              title: "Setting user",
                              subtitle: "Kelola akun dan hak akses untuk admin atau supervisor.",
                              asset:
                                  "assets/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png",
                              onTap: () => _openProtectedRoute('/user'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(IconData icon, String label) {
    return CustomWidget().linearPill(
      icon: icon,
      label: label,
      color: global.surfaceL1,
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required Color accent,
    required String title,
    required String subtitle,
    required String asset,
    required VoidCallback onTap,
  }) {
    final ui = CustomWidget();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: ui.linearPanelDecoration(radius: 24),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              padding: const EdgeInsets.all(12),
              decoration: ui.linearCardDecoration(
                radius: 22,
                color: accent.withValues(alpha: 0.14),
              ),
              child: Image.asset(asset),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: accent, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: textStyling.linearTitle(16, color: linearTextPrimary, strong: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: textStyling.linearBody(13, color: linearTextTertiary, height: 1.55),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: linearTextQuaternary),
          ],
        ),
      ),
    );
  }

  openQrPage() {
    qrCode = "-";
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => Container(
        height: global.getHeight(context),
        color: Colors.transparent,
        child: QrScanner(),
      ),
    ).then((value) {
      // qrCode = "1234560000AS010";
      // qrCode = "1C01ASTAUDT1428";
      // qrCode = "1C17AZ170919023";
      // qrCode = "1C001C03TEST0004";
      // qrCode = "100000000061702";
      if (!mounted) return;
      if (qrCode != "-") {
        Navigator.pushNamed(context, '/insert', arguments: {"qrCode": qrCode});
      }
      setState(() {});
    });
  }
}
