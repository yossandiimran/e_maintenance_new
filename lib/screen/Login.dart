// ignore_for_file: file_names, prefer_const_constructors, avoid_print

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

  bool obsText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        alert.alertConfirmExit(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.blueGrey.shade50,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: kToolbarHeight,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: SizedBox(
                      height: global.getHeight(context),
                      child: Column(
                        children: [
                          SizedBox(height: kToolbarHeight),
                          Image.asset(
                            "assets/icon.png",
                            width: global.getWidth(context) / 2,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Spacer(),
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          decoration: widget.decorationContainer1(defBlack1, 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "\n   Login E-Maintenance",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: defWhite, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                decoration: widget.decCont(defWhite, 15.0, 15.0, 15.0, 15.0),
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: email,
                                  decoration: const InputDecoration(
                                    focusColor: Colors.white,
                                    border: InputBorder.none,
                                    labelText: 'Username',
                                    labelStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                decoration: widget.decCont(defWhite, 15.0, 15.0, 15.0, 15.0),
                                child: TextField(
                                  controller: password,
                                  obscureText: obsText,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(fontSize: 15),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          !obsText ? obsText = true : obsText = false;
                                        });
                                      },
                                      icon: Icon(!obsText ? Icons.visibility_off : Icons.visibility),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  bottom: 5,
                                ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        var obj = {"username": email.text, "password": password.text};
                                        await AuthService(context: context, objParam: obj).login();
                                        // Navigator.pushNamed(context, '/home');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: widget.decCont(
                                          defGreen,
                                          15.0,
                                          15.0,
                                          15.0,
                                          15.0,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Masuk Aplikasi",
                                            style: textStyling.defaultWhiteBold(14.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                width: global.getWidth(context),
                                child: Row(
                                  children: [
                                    Text(
                                      "Version $appVersion",
                                      style: textStyling.customColor(15, Colors.blueGrey.shade400),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => alert.alertSuccess(
                                        context: context,
                                        text: "Silahkan Hubungi Admin",
                                      ),
                                      child: Text(
                                        "Lupa Password ?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: defWhite, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
