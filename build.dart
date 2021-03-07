#!/usr/bin/env dart
// script to build releases

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (Platform.isLinux) {
    buildForLinux();
  }
}

Future<ProcessResult> runShell(String cmd, {String? workingDirectory}) {
  print(cmd);
  return Process.run(
    'bash',
    ['-c', cmd],
    stdoutEncoding: utf8,
    workingDirectory: workingDirectory,
  );
}

Future<ProcessResult> runBuild(String platform) {
  print('Building: $platform');
  return runShell('flutter build $platform');
}

Future<ProcessResult> runArchive({
  required String inputDirectory,
  required String inputFile,
  required String outputDirectory,
  required String outputFile,
}) {
  final input = '$inputDirectory/$inputFile';
  final output = '$outputDirectory/$outputFile';
  print('Archiving: $input to $output');
  return runShell('zip -r $output $inputFile',
      workingDirectory: inputDirectory);
}

extension ResultCheck on ProcessResult {
  void mustSuccess(String process) {
    if (exitCode != 0) {
      throw 'Error: $process failed';
    }
  }
}

Future<String> getPackageVersion() async {
  final pubspec = await File('pubspec.yaml').readAsString();
  final version = RegExp('version: (.+)').firstMatch(pubspec);
  if (version == null) {
    throw 'Error: can not find package version from pubspec.';
  }
  return version.group(1)!;
}

Future<String> getArchiveName() async {
  return 'TerminalLite_${await getPackageVersion()}_${Platform.operatingSystem}.zip';
}

void buildForLinux() async {
  final build = await runBuild('linux');
  build.mustSuccess('release build');

  final archive = await runArchive(
    inputDirectory: 'build/linux/release/bundle',
    inputFile: '*',
    outputDirectory: Directory.current.absolute.path,
    outputFile: await getArchiveName(),
  );
  archive.mustSuccess('archive');
  print(archive.stdout);
}
