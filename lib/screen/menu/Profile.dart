// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables
part of "../../header.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
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
        resizeToAvoidBottomInset: false,
        backgroundColor: linearBg,
        body: Container(
          decoration: BoxDecoration(gradient: global.heroGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Akun Pengguna", style: textStyling.linearDisplay(30)),
                  const SizedBox(height: 8),
                  Text(
                    "Kelola informasi akun, preferensi aplikasi, dan sesi aktif Anda.",
                    style: textStyling.linearBody(15, color: linearTextSecondary),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: ui.linearHeroDecoration(),
                    child: Column(
                      children: [
                        Container(
                          width: 108,
                          height: 108,
                          decoration: ui.linearCardDecoration(
                            radius: 30,
                            color: linearAccent.withValues(alpha: 0.14),
                          ),
                          child: Icon(Icons.person_rounded, size: 48, color: linearTextPrimary),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          preference.getData("nama"),
                          style: textStyling.linearTitle(22, color: linearTextPrimary, strong: true),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            ui.linearPill(icon: Icons.verified_user_rounded, label: "User aktif"),
                            ui.linearPill(icon: Icons.terminal_rounded, label: "Version $appVersion"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ui.linearPanelDecoration(),
                    child: Column(
                      children: [
                        _buildProfileTile(
                          icon: Icons.lock_rounded,
                          color: linearAccent,
                          title: "Ganti Password",
                          subtitle: "Segera aktifkan alur reset yang lebih aman untuk akun operator.",
                          onTap: () {},
                        ),
                        const SizedBox(height: 12),
                        _buildProfileTile(
                          icon: Icons.settings_rounded,
                          color: linearSuccess,
                          title: "Pengaturan App",
                          subtitle: "Atur koneksi backend, test host, dan preferensi app.",
                          onTap: () => Navigator.pushNamed(context, '/configSetting'),
                        ),
                        const SizedBox(height: 12),
                        _buildProfileTile(
                          icon: Icons.logout_rounded,
                          color: defRed,
                          title: "Logout",
                          subtitle: "Akhiri sesi di perangkat ini dan kembali ke halaman login.",
                          onTap: () => alert.alertLogout(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final ui = CustomWidget();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ui.linearCardDecoration(radius: 20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: ui.linearCardDecoration(
                radius: 16,
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
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: linearTextQuaternary),
          ],
        ),
      ),
    );
  }
}
