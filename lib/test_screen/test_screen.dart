import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class TestScreen extends StatefulWidget {
  final numberOfQuestions;

  TestScreen({this.numberOfQuestions});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _nokoriMondaisuu = 0;
  int _seikaisuu = 0;
  int _seitouritu = 0;

  int questionLeft = 0;
  int questionRight = 0;
  String operater = '';
  String answerString = '';

  Soundpool soundpool;

  bool isCalcButtonsEnabled = false;
  bool isAnswerCheckButtonEnabled = false;
  bool isBackButtonEnabled = false;
  bool isCorrectInCorrectImageEnabled = false;
  bool isEndMessageEnabled = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _nokoriMondaisuu = widget.numberOfQuestions;
    _seikaisuu = 0;
    _seitouritu = 0;

    soundpool = Soundpool();
    _soundId = _loadSound("assets/sounds/sound_correct.mp3");
    _soundInId = _loadSound("assets/sounds/sound_incorrect.mp3");
    setState(() {});

    _setQuestion();
  }

  Future<int> _soundId;
  Future<int> _soundInId;

  Future<int> _loadSound(String soundPath) async {
    var asset = await rootBundle.load(soundPath);
    return await soundpool.load(asset);
  }

  @override
  void dispose() {
    super.dispose();
    soundpool.release();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Column(
            children: [
              //問題数
              _scoreSeat(),
              //計算
              _questionSeet(),
              //電卓
              _calkButtons(),
              //答え合わせ
              _answerButton(),
              //戻るボタン
              _backButton(),
            ],
          ),
          _correctIncorrectImage(),
          _endMessage(),
        ]),
      ),
    );
  }

  Widget _scoreSeat() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Table(
        children: [
          TableRow(children: [
            Center(
              child: Text(
                '残り問題数',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Center(
              child: Text(
                '正解数',
                style: TextStyle(fontSize: 10),
              ),
            ),
            Center(
              child: Text(
                '正答率',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ]),
          TableRow(children: [
            Center(
              child: Text(
                _nokoriMondaisuu.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Center(
              child: Text(
                _seikaisuu.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Center(
              child: Text(
                _seitouritu.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ])
        ],
      ),
    );
  }

  Widget _questionSeet() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 80),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionLeft.toString(),
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                operater,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                questionRight.toString(),
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                '=',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                answerString,
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calkButtons() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 80),
        child: Table(
          children: [
            TableRow(children: [
              _calkButton('7'),
              _calkButton('8'),
              _calkButton('9'),
            ]),
            TableRow(children: [
              _calkButton('4'),
              _calkButton('5'),
              _calkButton('6'),
            ]),
            TableRow(children: [
              _calkButton('1'),
              _calkButton('2'),
              _calkButton('3'),
            ]),
            TableRow(children: [
              _calkButton('0'),
              _calkButton('-'),
              _calkButton('C'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _calkButton(String numString) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: RaisedButton(
        onPressed: isCalcButtonsEnabled ? () => inputAnswer(numString) : null,
        child: Text(
          numString,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  Widget _answerButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: isCalcButtonsEnabled ? () => answerCheck() : null,
          child: Text(
            '答え合わせ',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

//
  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          onPressed: isBackButtonEnabled ? () => _syuuryouScreen() : null,
          child: Text(
            '戻る',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _correctIncorrectImage() {
    if (isCorrectInCorrectImageEnabled == true) {
      if (isCorrect) {
        return Center(child: Image.asset('assets/images/pic_correct.png'));
      }
      return Center(child: Image.asset('assets/images/pic_incorrect.png'));
    }
    return Container();
  }

  Widget _endMessage() {
    if (isEndMessageEnabled == true) {
      return Center(
        child: Text(
          'テスト終了',
          style: TextStyle(fontSize: 60),
        ),
      );
    } else {
      return Container();
    }
  }

  //問題をランダムで出す
  void _setQuestion() {
    isCalcButtonsEnabled = true;
    isAnswerCheckButtonEnabled = true;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = false;
    isEndMessageEnabled = false;
    isCorrect = false;

    Random random = Random();
    questionLeft = random.nextInt(100) + 1;
    questionRight = random.nextInt(100) + 1;
    if (random.nextInt(2) == 0) {
      operater = '+';
    } else {
      operater = '-';
    }

    answerString = '';

    setState(() {});
  }

  inputAnswer(String numString) {
    setState(() {
      if (numString == 'C') {
        answerString = '';
        return;
      }
      if (numString == '-') {
        if (answerString == '') answerString = '-';
        return;
      }
      if (numString == '0') {
        if (answerString != '0' && answerString != '-')
          answerString = answerString + numString;
        return;
      }

      if (answerString == '0') {
        answerString = numString;
        return;
      }
      answerString = answerString + numString;
    });
  }

  answerCheck() {
    if (answerString == '' || answerString == '-') {
      return;
    }
    isCalcButtonsEnabled = false;
    isAnswerCheckButtonEnabled = false;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = true;
    isEndMessageEnabled = false;

    _nokoriMondaisuu = _nokoriMondaisuu - 1;

    var myAnswer = int.parse(answerString).toInt();

    var realAnswer = 0;
    if (operater == '+') {
      realAnswer = questionLeft + questionRight;
    } else {
      realAnswer = questionLeft - questionRight;
    }

    if (realAnswer == myAnswer) {
      isCorrect = true;
      //soundpool.play(_soundId);
      _seikaisuu = _seikaisuu + 1;
    } else {
      isCorrect = false;
      //soundpool.play(_soundInId);
    }

    _seitouritu =
        ((_seikaisuu / (widget.numberOfQuestions - _nokoriMondaisuu)) * 100)
            .toInt();

    if (_nokoriMondaisuu == 0) {
      isCalcButtonsEnabled = false;
      isAnswerCheckButtonEnabled = false;
      isBackButtonEnabled = true;
      isCorrectInCorrectImageEnabled = true;
      isEndMessageEnabled = true;
    } else {
      Timer(Duration(seconds: 1), () => _setQuestion());
    }

    setState(() {});
  }

  _syuuryouScreen() {
    Navigator.pop(context);
  }
}
