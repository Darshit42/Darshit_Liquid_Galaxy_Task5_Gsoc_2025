import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard;
  final String stateMachineName;
  final String title;
  late SMIBool? input;

  RiveAsset({
    required this.artboard,
    required this.stateMachineName,
    required this.title,
    this.input,
  });

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset(
    artboard: "CHAT",
    stateMachineName: "CHAT_Interactivity",
    title: "",
  ),
  RiveAsset(
    artboard: "SEARCH",
    stateMachineName: "SEARCH_Interactivity",
    title: "",
  ),
  RiveAsset(
    artboard: "SETTINGS",
    stateMachineName: "SETTINGS_Interactivity",
    title: "",
  ),
  RiveAsset(
    artboard: "USER",
    stateMachineName: "USER_Interactivity",
    title: "",
  ),
];