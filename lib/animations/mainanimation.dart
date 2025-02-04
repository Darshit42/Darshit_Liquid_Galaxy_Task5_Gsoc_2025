import 'dart:math';
import 'package:flutter/material.dart';

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
                  return InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          isUser ? "U" : "G",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        isUser ? "User" : "Gemini",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        message['text']!,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(20, 20, 20, 1),
              border: Border(top: BorderSide(color: Colors.grey[700]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
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
}
