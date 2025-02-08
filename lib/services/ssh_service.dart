import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../provider/provider.dart';
import 'package:flutter/material.dart';

class SSH extends ChangeNotifier {
  final encoder = const Utf8Encoder();
  final WidgetRef ref;
  bool flag = false;

  SSH({required this.ref});

  Future<bool> ensureConnection(BuildContext context) async {
    if (flag && ref.read(sshClient) != null) {
      return true;
    }
    return await connect(context);
  }

  Future<bool> connect(BuildContext context) async {
    try {
      final socket = await SSHSocket.connect(
        ref.read(ip1),
        ref.read(portpro),
        timeout: const Duration(seconds: 5),
      );

      ref.read(sshClient.notifier).state = SSHClient(
        socket,
        username: ref.read(namepro) ?? '',
        onPasswordRequest: () => ref.read(passpro) ?? '',
      );

      flag = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Connection successful')));
      return true;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Connection failed: $e')));
      flag = false;
      return false;
    }
  }

  Future<void> disconnect(BuildContext context) async {
    try {
      ref.read(sshClient)?.close();
      ref.read(sshClient.notifier).state = null;
      flag = false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Disconnected successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Disconnection failed: $e')));
    }
  }

  Future<void> cleanKML(BuildContext context) async {
    try {
      await ensureConnection(context);
      await ref.read(sshClient)?.run('echo "" > /tmp/query.txt');
      await ref.read(sshClient)?.run("echo '' > /var/www/html/kmls.txt");
    } catch (error) {
      print("Error during cleanKML: $error");
    }
  }

  Future<void> sendKML(BuildContext context, String kmlAsset, String kmlName, StateProvider<bool> kmlProvider) async {
    try {
      final data = await rootBundle.loadString(kmlAsset);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$kmlName.kml');
      await file.writeAsString(data);

      await kmlFileUpload(context, file, kmlName);
      await runKml(context, kmlName);

      ref.read(kmlProvider.notifier).state = true;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending $kmlName: $e')),
      );
    }
  }


  Future<void> kmlFileUpload(
      BuildContext context,
      File inputFile,
      String kmlName,
      ) async {
    try {
      await ensureConnection(context);

      final sshClientInstance = ref.read(sshClient);
      final sftp = await sshClientInstance?.sftp();
      if (sftp == null) {
        throw Exception("Failed to initialize SFTP client.");
      }

      final remoteFile = await sftp.open(
        '/var/www/html/$kmlName.kml',
        mode:
        SftpFileOpenMode.create |
        SftpFileOpenMode.truncate |
        SftpFileOpenMode.write,
      );

      final fileSize = await inputFile.length();
      await remoteFile.write(
        inputFile.openRead().cast(),
        onProgress: (progress) {
          ref.read(percent.notifier).state = progress / fileSize;
        },
      );

      ref.read(percent.notifier).state = null;

      runKml(context, kmlName);
      print("File upload successful.");
    } catch (error, stackTrace) {
      print("Error during kmlFileUpload: $error");
      print(stackTrace);
    }
  }

  Future<void> runKml(BuildContext context, String kmlName) async {
    try {
      await ensureConnection(context);
      String command =
          "echo '\nhttp://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt";
      await ref.read(sshClient)?.run(command);
    } catch (error) {
      print("Error during runKml: $error");
    }
  }

  relaunchLG(context) async {
    try {
      for (var i = 1; i <= ref.read(rigsProvider); i++) {
        String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo ${ref.read(passpro)} | sudo -S service \\\${SERVICE} start
          else
            echo ${ref.read(passpro)} | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p ${ref.read(passpro)} ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
        await ref
            .read(sshClient)
            ?.run(
          '"/home/${ref.read(namepro)}/bin/lg-relaunch" > /home/${ref.read(namepro)}/log.txt',
        );
        await ref.read(sshClient)?.run(cmd);
      }
    } catch (error) {
      print(error);
    }
  }
}