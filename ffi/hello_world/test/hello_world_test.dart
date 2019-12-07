import 'dart:io';

import 'package:test/test.dart';

// These tests are Linux-only. For platform-specific instructions, see the
// README.
void main() async {
  if (Platform.isMacOS) ;

  if (Platform.isLinux)
    group('hello_world-linux', () {
      test('make dylib + execute', () async {
        // run 'make clean'
        var clean = await Process.run(
          'make',
          ['-f', 'LinuxMakefile', 'clean'],
          workingDirectory: 'c',
        );
        expect(clean.exitCode, 0);

        // run 'make so'
        var dynamicLib = await Process.run(
            'make', ['-f', 'LinuxMakefile', 'so'],
            workingDirectory: 'c');
        expect(dynamicLib.exitCode, 0);

        // Verify dynamic library was created
        var file = File('./hello_world.so');
        expect(await file.exists(), true);

        // Run the Dart script
        var dartProcess = await Process.run('dart', ['hello.dart']);
        expect(dartProcess.exitCode, equals(0));

        // Verify program output
        expect(dartProcess.stderr, isEmpty);
        expect(dartProcess.stdout, equals('Hello World\n'));
      });
    });

  if (Platform.isWindows)
    group('hello_world-windows', () {
      test('make dll + execute', () async {
        // run 'nmake clean'
        await Process.run("..\\..\\tool\\compile_cl.bat", ["clean"])
            .then((result) {
          expect(result.exitCode, 0);
        });
        // print('clean');
        // var clean = await Process.run(
        //   'nmake.exe',
        //   ['-f', 'NmakeFile', 'clean'],
        //   workingDirectory: 'c',
        //   // environment:
        // );
        // expect(clean.exitCode, 0);

        // run 'nmake dll'
        await Process.run(
          '..\\..\\tool\\compile_cl.bat',
          ['dll'],
        ).then((result) {
          stdout.write(result.stdout);
          stdout.write(result.stderr);
          expect(result.exitCode, 0);
        });

        // Verify dynamic library was created
        var file = File('./hello_world.dll');
        expect(await file.exists(), true);

        // Run the Dart script
        await Process.run('dart', ['hello.dart']).then((result) {
          stdout.write(result.stdout);
          stderr.write(result.stderr);
          expect(result.exitCode, equals(0));
          // Verify program output
          expect(result.stderr, isEmpty);
          expect(result.stdout, equals('Hello World\r\n'));
        });
      });
    });
}
