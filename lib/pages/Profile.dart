import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../services/ssh_service.dart';


final kml1provider = StateProvider<bool>((ref) => false);

class Notifications extends ConsumerWidget {


  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sshService = SSH(ref: ref);
    final isKml1Sent = ref.watch(kml1provider);

    Future<void> sendKML(String kmlAsset, String kmlName, StateProvider<bool> kmlProvider) async {
      try {
        final data = await rootBundle.loadString(kmlAsset);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$kmlName.kml');
        await file.writeAsString(data);

        await sshService.kmlFileUpload(context, file, kmlName);
        await sshService.runKml(context, kmlName);

        ref.read(kmlProvider.notifier).state = true;
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending $kmlName: $e')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(20, 20, 20, 1),
      body: Center(
        child: Padding(

          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Color.fromRGBO(20, 20, 20, 1),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildButton(
                    'Send KML1',
                    Icons.upload_file,
                    Colors.blue[700]!,
                        () => sendKML('assets/diwali.kml', 'kml1', kml1provider),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _buildButton(
                    'Send KML2',
                    Icons.upload_file,
                    Colors.blue[700]!,
                        () => sendKML('assets/temple.kml', 'temple', kml1provider),
                  ),
                  const SizedBox(height: 15),
                  _buildButton(
                    'Clear KML',
                    Icons.delete,
                    Colors.blue[700]!,
                        () async => await sshService.cleanKML(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      String text,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(28, 28, 28, 1),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }
}