import 'dart:math';
import 'package:flutter/material.dart';
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

  late Animation colorAnimation;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _colorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    colorAnimation = Tween<double>(begin: 0, end: 01).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeInOutSine),
    );
    _colorController.repeat();
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
          color: Color.fromRGBO(25, 25, 25, 1).withOpacity(0.8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(45, 45, 45, 1).withOpacity(0.8),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Image.asset(
                'assets/google_assistant.png',
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  _lastWords,
                  style: TextStyle(color: Colors.grey[400], fontSize: 28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                    child: Stack(children: [glow(100), glow(60), glow(32), glow(22)]),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Listening...',
                    style: TextStyle(color: Colors.grey[400], fontSize: 25),
                  ),
                ],
              ),
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
                child: GestureDetector(
                  onTap: () {
                    _startListening();
                    _slider.forward();
                    setState(() {
                      show = true;
                    });
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 4,
                      ),
                      color: Color.fromRGBO(20, 20, 20, 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/google_mic.png',
                        width: 130,
                        height: 130,
                      ),
                    ),
                  ),
                ),
              ),


              AnimatedBuilder(
                animation: _sliding,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(
                      00,
                      MediaQuery.of(context).size.height * 0.6 * _sliding.value,
                    ),
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
        animation: colorAnimation,
        builder: (context, child) {
          final time = colorAnimation.value * 2 * pi;
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
      flex: (((sin(time) + 1))*10000).round(),
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