import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ssh_service.dart';

final kml1provider = StateProvider<bool>((ref) => false);

class Notifications extends ConsumerWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sshService = SSH(ref: ref);


    return Scaffold(
      backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: const Color.fromRGBO(20, 20, 20, 1),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () => sshService.sendKML(context,
                        'assets/diwali.kml',
                        'kml1',
                        kml1provider
                    ),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 5.0, color: Color.fromRGBO(100, 25, 120, 1)),
                      shadowColor: Colors.purple,
                      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file),
                        SizedBox(width: 8),
                        Text(
                          'Send KML1',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => sshService.sendKML(context,
                        'assets/temple.kml',
                        'temple',
                        kml1provider
                    ),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 5.0, color: Color.fromRGBO(100, 25, 120, 1)),
                      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file),
                        SizedBox(width: 8),
                        Text(
                          'Send KML2',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async => await sshService.cleanKML(context),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 5.0, color: Color.fromRGBO(100, 25, 120, 1)),
                      backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text(
                          'Clear KML',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}