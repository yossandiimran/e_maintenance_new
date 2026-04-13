// ignore_for_file: constant_identifier_names, sort_child_properties_last, avoid_print, prefer_const_constructors, use_build_context_synchronously, file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, prefer_typing_uninitialized_variables
part of '../header.dart';

class ConfigSettingPage extends StatefulWidget {
  const ConfigSettingPage({Key? key}) : super(key: key);
  @override
  ConfigSettingPageState createState() => ConfigSettingPageState();
}

class ConfigSettingPageState extends State<ConfigSettingPage> {
  final addressIpController = TextEditingController();

  bool isRestart = false, checkConn = false, isConnect = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  checkConnection() async {
    var globalIp = await preference.getData("globalIp") ?? global.baseIp;
    var checkedIp = globalIp.split(":")[0];
    if (!checkConn) {
      setState(() => checkConn = true);
      await Socket.connect(checkedIp, 80, timeout: Duration(seconds: 5)).then((socket) {
        alert.alertSuccess(context: context, text: "IP Tersambung !");
        socket.destroy();
        setState(() => checkConn = false);
        setState(() => isConnect = true);
      }).catchError((error) {
        alert.alertWarning(context: context, text: "IP tidak tersambung, pastikan VPN aktif !");
        setState(() => checkConn = false);
        setState(() => isConnect = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui = CustomWidget();
    return Scaffold(
      backgroundColor: linearBg,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.pop(context);
        },
        child: Container(
          decoration: BoxDecoration(gradient: global.heroGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: global.surfaceL1,
                          side: BorderSide(color: global.borderSubtle),
                        ),
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: linearTextPrimary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text("Pengaturan App", style: textStyling.linearDisplay(28)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Kontrol koneksi backend, restart layanan, dan akses pengelolaan user dari satu panel.",
                    style: textStyling.linearBody(15, color: linearTextSecondary),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: ui.linearHeroDecoration(),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ui.linearPill(
                          icon: isConnect ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                          label: isConnect ? "Host tersambung" : "Host belum tersambung",
                          color: (isConnect ? linearSuccess : defRed).withValues(alpha: 0.14),
                          textColor: isConnect ? linearSuccessPill : defRed,
                        ),
                        ui.linearPill(
                          icon: Icons.link_rounded,
                          label: "Default ${global.baseIp}",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildSettingTile(
                    icon: Icons.http_rounded,
                    color: linearAccent,
                    title: "Setting IP",
                    subtitle: "Atur host API aktif untuk kebutuhan VPN atau server lokal.",
                    trailing: Text(
                      (preference.getData("globalIp") ?? global.baseIp).toString(),
                      style: textStyling.linearCaption(11),
                    ),
                    onTap: _showHostDialog,
                  ),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    icon: Icons.restart_alt_rounded,
                    color: defOrange,
                    title: "Restart Koneksi",
                    subtitle: "Restart layanan backend jika koneksi SAP atau API mengalami timeout.",
                    trailing: isRestart
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.4, color: linearAccent),
                          )
                        : null,
                    onTap: () async {
                      if (preference.getData("groupUser").toString() != "4") {
                        isRestart = true;
                        setState(() {});
                        await RestartGlassfish(context: context, obj: {}).restartConnection();
                        isRestart = false;
                        setState(() {});
                      } else {
                        alert.alertWarning(context: context, text: "Anda tidak memiliki akses !");
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    icon: Icons.cast_connected_rounded,
                    color: isConnect ? linearSuccess : linearAccent,
                    title: "Test Koneksi",
                    subtitle: "Periksa apakah host saat ini dapat dijangkau dari perangkat.",
                    trailing: checkConn
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.4, color: linearAccent),
                          )
                        : null,
                    onTap: () async {
                      checkConnection();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    icon: Icons.manage_accounts_rounded,
                    color: linearBrand,
                    title: "Setting User",
                    subtitle: "Masuk ke modul pengelolaan akun dan hak akses.",
                    onTap: () async {
                      if (preference.getData("groupUser").toString() != "4") {
                        Navigator.pushNamed(context, '/user');
                      } else {
                        alert.alertWarning(context: context, text: "Anda tidak memiliki akses !");
                      }
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

  Future<void> _showHostDialog() async {
    var globalIp = await preference.getData("globalIp") ?? global.baseIp;
    addressIpController.text = globalIp.toString();
    if (!mounted) return;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final ui = CustomWidget();
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Host aktif",
                  style: textStyling.linearTitle(18, color: linearTextPrimary, strong: true),
                ),
                const SizedBox(height: 8),
                Text(
                  "Default : ${global.baseIp}",
                  style: textStyling.linearBody(13, color: linearTextTertiary),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressIpController,
                  style: textStyling.linearBody(15, color: linearTextPrimary),
                  decoration: ui.linearInputDecoration(
                    label: "Host / IP",
                    hint: global.baseIp,
                    icon: Icons.http_rounded,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          await preference.setString("globalIp", addressIpController.text);
                          Navigator.pop(context);
                          checkConnection();
                        },
                        style: ui.linearPrimaryButtonStyle(),
                        child: const Text("Simpan"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ui.linearGhostButtonStyle(),
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

  Widget _buildSettingTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    final ui = CustomWidget();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ui.linearPanelDecoration(radius: 22),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: ui.linearCardDecoration(
                radius: 18,
                color: color.withValues(alpha: 0.14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textStyling.linearTitle(16, color: linearTextPrimary, strong: true)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textStyling.linearBody(13, color: linearTextTertiary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 16, color: linearTextQuaternary),
          ],
        ),
      ),
    );
  }
}
