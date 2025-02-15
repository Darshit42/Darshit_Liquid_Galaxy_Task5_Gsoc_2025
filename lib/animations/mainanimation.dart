import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class geminibutton extends StatefulWidget {
  geminibutton({super.key});

  @override
  State<geminibutton> createState() => _geminibutton();
}

class _geminibutton extends State<geminibutton> with TickerProviderStateMixin {
  final List<String> path = [
    'assets/geminiFlower.png',
    'assets/geminiHexagon.png',
    'assets/geminiLong.png',
  ];

  int current = 0;
  int counter = 0;
  int animationNo = 1;

  late AnimationController animationController1;
  late Animation<double> animation1;

  late AnimationController animationController2;
  late Animation<double> animation2;

  late AnimationController animationController3;
  late Animation<double> animation3;

  @override
  void initState() {
    super.initState();

    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animationController3 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController1, curve: Curves.easeOutCubic),
    );

    animation2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController2, curve: Curves.linear),
    );

    animation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController3, curve: Curves.linear),
    );

    animationController1.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          animationNo = 2;
        });
        animationController2.reset();
        animationController2.forward();
      }
    });

    animationController2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          counter++;
          if (counter >= 3) {
            animationNo = 3;
            animationController3.reset();
            animationController3.forward();
            // animationController2.reverse();
            counter = 2;
          } else {
            animationController2.reset();
            animationController2.forward();
          }
        });
      }
    });

    animationController3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationNo = 1;
          counter = 0;
        });
        animationController1.reset();
        animationController1.forward();
      }
    });
    animationController1.forward();
  }

  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late Animation<double> _animation;

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'type': 'user', 'text': message});
      });

      _messageController.clear();

      setState(() {
        _messages.add({'type': 'gemini', 'text': 'gemini message'});
      });
    }
  }

  double divider = 3.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 1),
      body: Column(
        children: [
          SizedBox(height: 250),
          SizedBox(
            height: 250,
            width: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation:
                      animationNo == 1
                          ? animation1
                          : animationNo == 2
                          ? animation2
                          : animation3,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle:
                          animationNo == 2 || animationNo == 3
                              ? animation2.value
                              : 0,
                      child: Image.asset(
                        animationNo == 1 ? 'assets/circle.png' : path[counter],
                        height:
                            animationNo == 1
                                ? 250 / divider * animation1.value
                                : animationNo == 2
                                ? 250 / divider
                                : 250 / divider * (1 - animation3.value),
                        width:
                            animationNo == 1
                                ? 250 / divider * animation1.value
                                : animationNo == 2
                                ? 250
                                : 250 / divider * (1 - animation3.value),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: animation1,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: animation1.value * pi * 2,
                      child: Image.asset(
                        "assets/geministar.png",
                        height: 100 / divider,
                        width: 100 / divider,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: _messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isUser = message['type'] == 'user';
                  return chatbuilder(isUser, message['text']!);
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.25),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pinkAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.image, color: Colors.white),
                      onPressed: () {
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.mic, color: Colors.white),
                      onPressed: () {
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose(){
    animationController1.dispose();
    animationController2.dispose();
    animationController3.dispose();
    super.dispose();
  }



  Widget chatbuilder(bool human , String mess){
    return human?BubbleSpecialOne(
      text: mess,
      color: Color.fromRGBO(46, 126, 250, 1),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    )
    :
    BubbleSpecialOne(
      text: mess,
      isSender: false,
      color: Color.fromRGBO(48, 48, 48, 1),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }
}
