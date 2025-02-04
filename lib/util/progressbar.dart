import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ssh_service.dart';
import '../provider/provider.dart';

class progressbar extends ConsumerStatefulWidget {
  final SSH sshService;
  const progressbar(this.sshService, {Key? key}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends ConsumerState<progressbar> {
  double _progress = 0.0;
  int _current = 0;

  late TextEditingController nameController;
  late TextEditingController portController;
  late TextEditingController ipController;
  late TextEditingController passwordController;
  late TextEditingController numberOfVMController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(namepro) ?? 'lg');
    portController = TextEditingController(text: ref.read(portpro)?.toString() ?? '22');
    ipController = TextEditingController(text: ref.read(ip1) ?? '192.168.56.101');
    passwordController = TextEditingController(text: ref.read(passpro) ?? 'lg');
    numberOfVMController = TextEditingController(text: ref.read(rigsProvider)?.toString() ?? '3');

    nameController.addListener(() {
      ref.read(namepro.notifier).state = nameController.text;
    });
    portController.addListener(() {
      ref.read(portpro.notifier).state = int.tryParse(portController.text) ?? 22;
    });
    ipController.addListener(() {
      ref.read(ip1.notifier).state = ipController.text;
    });
    passwordController.addListener(() {
      ref.read(passpro.notifier).state = passwordController.text;
    });
    numberOfVMController.addListener(() {
      ref.read(rigsProvider.notifier).state = int.tryParse(numberOfVMController.text) ?? 3;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    portController.dispose();
    ipController.dispose();
    passwordController.dispose();
    numberOfVMController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(isConnectedToLGProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 1),
      body: Stepper(
        currentStep: _current,
        controlsBuilder: (context, controls) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                if (_current < 2)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controls.onStepContinue,
                    child: Text('Continue'),
                  ),
                SizedBox(width: 12),
                if (_current > 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controls.onStepCancel,
                    child: Text('Back'),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            state: _current <= 0 ? StepState.editing : StepState.complete,
            isActive: _current >= 0,
            title: const Text('Connection Info', style: TextStyle(color: Colors.white)),
            content: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextField(
                  controller: portController,
                  decoration: InputDecoration(
                    labelText: 'Port',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextField(
                  controller: ipController,
                  decoration: InputDecoration(
                    labelText: 'IP Address',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey[300]),
                ),
              ],
            ),
          ),
          Step(
            state: _current <= 1 ? StepState.editing : StepState.complete,
            isActive: _current >= 1,
            title: const Text('Additional Details', style: TextStyle(color: Colors.white)),
            content: Column(
              children: [
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextField(
                  controller: numberOfVMController,
                  decoration: InputDecoration(
                    labelText: 'Number of VMs',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.grey[300]),
                ),
              ],
            ),
          ),
          Step(
            state: StepState.complete,
            isActive: _current >= 2,
            title: const Text('Confirm & Connect', style: TextStyle(color: Colors.white)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${nameController.text}',
                    style: TextStyle(color: Colors.grey[300])),
                Text('Port: ${portController.text}',
                    style: TextStyle(color: Colors.grey[300])),
                Text('IP: ${ipController.text}',
                    style: TextStyle(color: Colors.grey[300])),
                Text('Number of VMs: ${numberOfVMController.text}',
                    style: TextStyle(color: Colors.grey[300])),
                SizedBox(height: 20),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          ref.read(namepro.notifier).state = nameController.text;
                          ref.read(portpro.notifier).state = int.tryParse(portController.text) ?? 22;
                          ref.read(ip1.notifier).state = ipController.text;
                          ref.read(passpro.notifier).state = passwordController.text;
                          ref.read(rigsProvider.notifier).state = int.tryParse(numberOfVMController.text) ?? 3;

                          bool connected = await widget.sshService.connect(context);
                          if (connected) {
                            setState(() {
                              _progress = 1.0;
                            });
                          }
                        },
                        child: Text('Connect'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await widget.sshService.relaunchLG(context);
                        },
                        child: Text('Relaunch'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        onStepContinue: () {
          if (_current < 2) {
            setState(() => _current++);
          }
        },
        onStepCancel: () {
          if (_current > 0) {
            setState(() => _current--);
          }
        },
      ),
    );
  }
}