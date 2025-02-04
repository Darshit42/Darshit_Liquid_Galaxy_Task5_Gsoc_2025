import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:darshit_lg_t5/util/progressbar.dart';
import 'package:darshit_lg_t5/services/ssh_service.dart';

class Profile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sshService = SSH(ref: ref);

    return Scaffold(
      body: progressbar(sshService),
    );
  }
}
