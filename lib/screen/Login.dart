// ignore_for_file: file_names, prefer_const_constructors, avoid_print, use_build_context_synchronously

part of '../header.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  bool obsText = false;
  final addressIpController = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController(text: "centr@l1001");
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () async {
                        var globalIp = await preference.getData("globalIp") ?? global.baseIp;
                        addressIpController.text = globalIp.toString();
                        changeIPAddress();
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: global.surfaceL1,
                        side: BorderSide(color: global.borderSubtle),
                      ),
                      icon: Icon(Icons.settings_rounded, color: linearTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: ui.linearHeroDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          padding: const EdgeInsets.all(14),
                          decoration: ui.linearCardDecoration(
                            radius: 22,
                            color: linearAccent.withValues(alpha: 0.12),
                          ),
                          child: Image.asset("assets/icon.png"),
                        ),
                        const SizedBox(height: 22),
                        Text("Masuk ke E-Maintenance", style: textStyling.linearDisplay(30)),
                        const SizedBox(height: 10),
                        Text(
                          "Lanjutkan pekerjaan inspeksi, pengelolaan laporan, dan administrasi kendaraan dengan workspace yang lebih fokus.",
                          style: textStyling.linearBody(15, color: linearTextSecondary, height: 1.65),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ui.linearPill(icon: Icons.qr_code_2_rounded, label: "QR inspection"),
                            ui.linearPill(icon: Icons.print_rounded, label: "Zebra printer"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: ui.linearPanelDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Login", style: textStyling.linearTitle(20, strong: true)),
                        const SizedBox(height: 6),
                        Text(
                          "Gunakan akun yang sudah didaftarkan oleh administrator.",
                          style: textStyling.linearBody(14, color: linearTextTertiary),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          style: textStyling.linearBody(15, color: linearTextPrimary),
                          decoration: ui.linearInputDecoration(
                            label: 'Username',
                            hint: 'Masukkan username',
                            icon: Icons.person_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: password,
                          obscureText: obsText,
                          style: textStyling.linearBody(15, color: linearTextPrimary),
                          decoration: ui.linearInputDecoration(
                            label: 'Password',
                            hint: 'Masukkan password',
                            icon: Icons.lock_outline_rounded,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  obsText = !obsText;
                                });
                              },
                              icon: Icon(
                                !obsText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                color: linearTextTertiary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () async {
                              var obj = {"username": email.text, "password": password.text};
                              await AuthService(context: context, objParam: obj).login();
                            },
                            style: ui.linearPrimaryButtonStyle(),
                            icon: const Icon(Icons.login_rounded),
                            label: const Text("Masuk Aplikasi"),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Text("Version $appVersion", style: textStyling.linearCaption(12)),
                            const Spacer(),
                            TextButton(
                              onPressed: () => alert.alertSuccess(
                                context: context,
                                text: "Silakan hubungi admin",
                              ),
                              child: Text(
                                "Lupa password?",
                                style: textStyling.linearBody(13, color: linearAccent, emphasis: true),
                              ),
                            ),
                          ],
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

  changeIPAddress() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pengaturan host",
                  style: textStyling.linearTitle(18, color: linearTextPrimary, strong: true),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ubah alamat IP backend jika dibutuhkan untuk koneksi VPN atau server lokal.",
                  style: textStyling.linearBody(13, color: linearTextTertiary),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: addressIpController,
                  style: textStyling.linearBody(15, color: linearTextPrimary),
                  decoration: CustomWidget().linearInputDecoration(
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
                          global.successResponsePop(context, "Berhasil Menyimpan Pengaturan");
                        },
                        style: CustomWidget().linearPrimaryButtonStyle(),
                        child: const Text("Simpan"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: CustomWidget().linearGhostButtonStyle(),
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
    ).then((value) {
      setState(() {});
    });
  }
}
