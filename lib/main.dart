import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_csv/allCsv.dart';
import 'package:flutter_csv/loadCsvDataScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:random_string/random_string.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Csv Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Csv Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AllCsvFilesScreen()));
              },
              color: Colors.cyanAccent,
              child: Text("Load all csv form phone storage"),
            ),
            MaterialButton(
              onPressed: () {
                loadCsvFromStorage();
              },
              color: Colors.cyanAccent,
              child: Text("Load csv form phone storage"),
            ),
            MaterialButton(
              onPressed: () {
                generateCsv();
              },
              color: Colors.cyanAccent,
              child: Text("Load Created csv"),
            ),
          ],
        ),
      ),
    );
  }

  generateCsv() async {
    int balance = 10000;
    String message1 = "Hi <<Batool>>, this message is to confirm that we received a deposit of 20000 \$ in your account ending in ***998 on 01/01/2020. Thank you!";

    //split the message apart
    var message2 = message1.split(" ");

    //deposit or withdraw
    bool depoOrwith = message2.contains("deposit");
    String depositOrWithdraw = "";
    if(depoOrwith) {
      depositOrWithdraw = "deposit";
    }else{
      depositOrWithdraw = "withdraw";
    }
    String amount = message1.replaceAll(new RegExp(r'[^0-9$]'),'');

    List<List<String>> data = [
      ["Time","Date.", "Amount", "Type"],
      ["19:30", "01/01/2020", amount, depositOrWithdraw],

    ];
    String csvData = ListToCsvConverter().convert(data);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(csvData);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadCsvDataScreen(path: path);
        },
      ),
    );
  }

  loadCsvFromStorage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
    String path = result.files.first.path;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return LoadCsvDataScreen(path: path);
        },
      ),
    );
  }
}
