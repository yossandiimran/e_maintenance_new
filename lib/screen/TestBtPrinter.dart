// ignore_for_file: file_names, prefer_const_constructors, unnecessary_string_escapes, avoid_print

part of "../header.dart";

class TestBtPrinter extends StatefulWidget {
  const TestBtPrinter({super.key});

  @override
  State<TestBtPrinter> createState() => _TestBtPrinterState();
}

class _TestBtPrinterState extends State<TestBtPrinter> {
  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    await Permission.location.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetooth.request();
  }

  Future _ackAlert(BuildContext context, String title) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          // content: const Text('This item is no longer available'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onDiscovery() async {
    var a = await ZebraSdk.onDiscovery();
    print(a);
    var b = json.decode(a);

    var printers = b['content'];
    if (printers != null) {
      var printObj = json.decode(printers);
      print(printObj);
    }

    print(b);
  }

  Future<void> onDiscoveryUSB(dynamic context) async {
    var a = await ZebraSdk.onDiscoveryUSB();
    _ackAlert(context, 'USB $a');
    print(a);
    var b = json.decode(a);

    var printers = b['content'];
    if (printers != null) {
      var printObj = json.decode(printers);
      print(printObj);
    }
    print(b);
  }

  Future<void> onGetIPInfo() async {
    var a = await ZebraSdk.onGetPrinterInfo('192.168.1.26');
    print(a);
  }

  Future<void> onTestConnect() async {
    var a = await ZebraSdk.isPrinterConnected('192.168.1.26');
    print(a);
    var b = json.decode(a);
    print(b);
  }

  Future<void> onTestTCP() async {
    String data;
    data = '''
    ''
    ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR6,6~SD15^JUS^LRN^CI0^XZ
    ^XA
    ^MMT
    ^PW500
    ^LL0240
    ^LS0
    ^FT144,33^A0N,25,24^FB111,1,0,C^FH\^FDITEM TITLE^FS
    ^FT3,61^A@N,20,20,TT0003M_^FB394,1,0,C^FH\^CI17^F8^FDOption 1, Option 2, Option 3, Option 4, Opt^FS^CI0
    ^FT3,84^A@N,20,20,TT0003M_^FB394,1,0,C^FH\^CI17^F8^FDion 5, Option 6 ^FS^CI0
    ^FT34,138^A@N,25,24,TT0003M_^FB331,1,0,C^FH\^CI17^F8^FDOrder: https://eat.chat/phobac^FS^CI0
    ^FT29,173^A@N,20,20,TT0003M_^FB342,1,0,C^FH\^CI17^F8^FDPromotional Promotional Promotional^FS^CI0
    ^FT29,193^A@N,20,20,TT0003M_^FB342,1,0,C^FH\^CI17^F8^FD Promotional Promotional ^FS^CI0
    ^FT106,233^A0N,25,24^FB188,1,0,C^FH\^FDPHO BAC HOA VIET^FS
    ^PQ1,0,1,Y^XZ
        ''';

    final rep = ZebraSdk.printZPLOverTCPIP('192.168.1.26', data: data);
    print(rep);
  }

  Future<void> onTestBluetooth() async {
    String data;
    data = '''
    ''
    ^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR6,6~SD15^JUS^LRN^CI0^XZ
    ^XA
    ^MMC
    ^PW500
    ^LL0240
    ^LS0
    ^FT144,33^A0N,25,24^FB111,1,0,C^FH\^FDITEM TITLE^FS
    ^FT3,61^A@N,20,20,TT0003M_^FB394,1,0,C^FH\^CI17^F8^FDOption 1, Option 2, Option 3, Option 4, Opt^FS^CI0
    ^FT3,84^A@N,20,20,TT0003M_^FB394,1,0,C^FH\^CI17^F8^FDion 5, Option 6 ^FS^CI0
    ^FT34,138^A@N,25,24,TT0003M_^FB331,1,0,C^FH\^CI17^F8^FDOrder: https://eat.chat/phobac^FS^CI0
    ^FT29,173^A@N,20,20,TT0003M_^FB342,1,0,C^FH\^CI17^F8^FDPromotional Promotional Promotional^FS^CI0
    ^FT29,193^A@N,20,20,TT0003M_^FB342,1,0,C^FH\^CI17^F8^FD Promotional Promotional ^FS^CI0
    ^FT106,233^A0N,25,24^FB188,1,0,C^FH\^FDPHO BAC HOA VIET^FS
    ^PQ1,0,1,Y^XZ
        ''';
    final rep = ZebraSdk.printZPLOverBluetooth(macBt.text, data: data);
    print(rep);
  }

  var macBt = TextEditingController(text: "E4:E1:12:81:AB:B2");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  controller: macBt,
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
                TextButton(onPressed: onGetIPInfo, child: Text('onGetPrinterInfo')),
                TextButton(onPressed: onTestConnect, child: Text('onTestConnect')),
                TextButton(onPressed: onDiscovery, child: Text('Discovery')),
                TextButton(onPressed: () => onDiscoveryUSB(context), child: Text('Discovery USB')),
                TextButton(onPressed: onTestTCP, child: Text('Print TCP')),
                TextButton(onPressed: onTestBluetooth, child: Text('Print Bluetooth')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
