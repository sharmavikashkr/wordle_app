import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordle_app/components/toast.dart';

import 'components/word_field.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _attempts;
  List<String> _wordColors;
  List<bool> _wordsEnabled;
  bool gameover;
  String shareMessage;

  @override
  void initState() {
    super.initState();
    setState(() {
      _attempts = 0;
      _wordColors = ['wwwww', 'wwwww', 'wwwww', 'wwwww', 'wwwww', 'wwwww'];
      _wordsEnabled = [true, false, false, false, false, false];
      gameover = false;
      shareMessage = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkWord(final String word) async {
    log('Checking word: ' + word);
    var params = {'word': word};
    var uri = Uri.https('wordle-api.azurewebsites.net', '/api/CheckWord', params);
    var response = await http.get(uri);
    log('Response: ${response.body}');
    if (response.statusCode == 200) {
      setState(() {
        _wordColors[_attempts] = response.body;
        _wordsEnabled[_attempts] = false;
        if (response.body != 'ggggg') {
          _attempts++;
          _wordsEnabled[_attempts] = true;
        } else {
          gameover = true;
          _createShareMessage();
        }
      });
    } else {
      WToast.show(response.body);
    }
  }

  void _createShareMessage() {
    String green = "🟩";
    String yellow = "🟨";
    String blank = "⬜";
    final DateTime today = DateTime.now();
    final dateSlug = "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    String shareString = "Wordle ${dateSlug} [${_attempts + 1}/6]\n\n";
    for (int i = 0; i <= _attempts; i++) {
      log(_wordColors[i]);
      for (int j = 0; j < 5; j++) {
        log(_wordColors[i][j]);
        shareString += _wordColors[i][j] == 'b'
            ? blank
            : _wordColors[i][j] == 'g'
                ? green
                : yellow;
      }
      shareString += '\n';
    }
    setState(() {
      shareMessage = shareString;
    });
  }

  void _clear() {
    setState(() {
      _attempts = 0;
      _wordColors = ['wwwww', 'wwwww', 'wwwww', 'wwwww', 'wwwww', 'wwwww'];
      _wordsEnabled = [true, false, false, false, false, false];
      gameover = false;
      shareMessage = '';
    });
  }

  void _share() async {
    log(shareMessage);
  }

  @override
  Widget build(BuildContext context) {
    double inputSize = MediaQuery.maybeOf(context).size.width * 0.90;
    const wordLength = 5;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 50,
            ),
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: _clear,
            icon: Icon(Icons.refresh_outlined),
            label: Text(''),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WordTextField(
              length: wordLength,
              width: inputSize,
              enabled: _wordsEnabled[0],
              colors: _wordColors[0],
              onCompleted: _checkWord,
              onChanged: (word) => {log(word)},
              attempts: _attempts,
            ),
            WordTextField(
              length: wordLength,
              width: inputSize,
              enabled: _wordsEnabled[1],
              colors: _wordColors[1],
              onCompleted: _checkWord,
              onChanged: (word) => {log(word)},
              attempts: _attempts,
            ),
            WordTextField(
              length: wordLength,
              width: inputSize,
              enabled: _wordsEnabled[2],
              colors: _wordColors[2],
              onCompleted: _checkWord,
              onChanged: (word) => {log(word)},
              attempts: _attempts,
            ),
            WordTextField(
              length: wordLength,
              width: inputSize,
              enabled: _wordsEnabled[3],
              colors: _wordColors[3],
              onCompleted: _checkWord,
              onChanged: (word) => {log(word)},
              attempts: _attempts,
            ),
            WordTextField(
              length: wordLength,
              width: inputSize,
              enabled: _wordsEnabled[4],
              colors: _wordColors[4],
              onCompleted: _checkWord,
              onChanged: (word) => {log(word)},
              attempts: _attempts,
            ),
            WordTextField(
              length: wordLength,
              width: inputSize,
              enabled: _wordsEnabled[5],
              colors: _wordColors[5],
              onCompleted: _checkWord,
              onChanged: (word) => {log(word)},
              attempts: _attempts,
            ),
            Container(height: 50),
            gameover
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        shareMessage,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _share,
                        icon: const Icon(Icons.share),
                        label: const Text(
                          'SHARE',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        style: TextButton.styleFrom(backgroundColor: Colors.green, primary: Colors.white),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
