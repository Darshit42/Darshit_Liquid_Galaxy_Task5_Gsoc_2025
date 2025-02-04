import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Voiceline());
  }
}

class Voiceline extends StatefulWidget {
  @override
  State<Voiceline> createState() => _VoicelineState();
}

class _VoicelineState extends State<Voiceline> with TickerProviderStateMixin {
  late AnimationController _colorController;

  String recognizedText = "Press the mic and start speaking...";

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  late AnimationController _slider;
  late Animation _sliding;

  void _initSpeech() async {
    PermissionStatus micperm = await Permission.microphone.status;
    if (micperm != PermissionStatus.granted) {
      await Permission.microphone.request();
    }
    _speechEnabled = await _speechToText.initialize(debugLogging: true);
    print("333333333333333333333333333333");
    setState(() {});
  }

  void _startListening() async {
    print("111111111111111111111");
    var systemLocale = await _speechToText.systemLocale();
    String _currentLocaleId = 'en-US';
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _currentLocaleId,
    );

    print("222222222222222222222222");
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print(
      "................................................wwwwwwwwwwwwwwwwwwwwwwwwww",
    );
    print(result.recognizedWords);
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1250),
    )..repeat();
    _slider = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _sliding = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(curve: Curves.easeOutCubic, parent: _slider));
  }

  Widget Sliding_assistant() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Color.fromRGBO(28, 28, 28, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 45),
            Image.asset(
              'assets/google_assistant.png',
              height: 60,
              fit: BoxFit.cover,
            ),
            Text(
              _lastWords,
              style: TextStyle(color: Colors.cyan, fontSize: 28),
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 100,
              child: Stack(children: [glow(10), glow(8), glow(6), glow(4)]),
            ),
            SizedBox(height: 30),
            Text(
              'Listening...',
              style: TextStyle(color: Colors.cyan, fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }

  bool isListening = false;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _slider.reverse();
        _stopListening();
        setState(() {
          print("333333333333333333333333");
          show = false;
        });
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(20, 20, 20, 1),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: IconButton(
                  icon: Image.asset(
                    'assets/google_mic.png',
                    width: 130,
                    height: 130,
                  ),
                  iconSize: 0,
                  onPressed: () {
                    _startListening();
                    _slider.forward();
                    setState(() {
                      show = true;
                    });
                  },
                ),
              ),

              AnimatedBuilder(
                animation: _sliding,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(00, MediaQuery.of(context).size.height * 0.6*_sliding.value),
                    child: Sliding_assistant(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget glow(double blurStrength) {
    return Center(
      child: AnimatedBuilder(
        animation: _colorController,
        builder: (context, child) {
          final time = _colorController.value * 2 * pi;
          return SizedBox(
            height: 100,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 8,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: blurStrength,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAnimatedBar(time, Colors.blue, blurStrength),
                      _buildAnimatedBar(
                        time + pi / 2,
                        Colors.red,
                        blurStrength,
                      ),
                      _buildAnimatedBar(time + pi, Colors.yellow, blurStrength),
                      _buildAnimatedBar(
                        time + 3 * pi / 2,
                        Colors.green,
                        blurStrength,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBar(double time, Color color, double blurStrength) {
    return Expanded(
      flex: ((sin(time) + 1) * 2.5).round().clamp(1, 10),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: blurStrength,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }
}
