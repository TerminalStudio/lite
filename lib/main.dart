import 'dart:ffi';
import 'dart:io';

import 'package:context_menu_macos/context_menu_macos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pty/pty.dart';
import 'package:tabs/tabs.dart';

import 'package:flutter/material.dart' hide Tab, TabController;
import 'package:xterm/flutter.dart';
import 'package:xterm/theme/terminal_style.dart';
import 'package:xterm/xterm.dart';

void main() {
  runApp(MyApp());

  // ProcessSignal.sigterm.watch().listen((event) {
  //   print('sigterm');
  // });

  // ProcessSignal.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminal Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final tabs = TabsController();
  final group = TabGroupController();

  @override
  void initState() {
    addTab();

    final group = TabsGroup(controller: this.group);

    tabs.replaceRoot(group);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          // color: Color(0xFF3A3D3F),
          color: Colors.transparent,
          child: TabsView(
            controller: tabs,
            actions: [
              TabsGroupAction(
                icon: CupertinoIcons.add,
                onTap: (group) {
                  group.addTab(buildTab(), activate: true);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void addTab() {
    this.group.addTab(buildTab(), activate: true);
  }

  Tab buildTab() {
    final tab = TabController();

    if (!Platform.isWindows) {
      Directory.current = Platform.environment['HOME'] ?? '/';
    }

    // terminal.debug.enable();

    final shell = getShell();

    final pty = PseudoTerminal.start(
      shell,
      ['-l'],
      environment: {'TERM': 'xterm-256color'},
    );

    final terminal = Terminal(
      onTitleChange: tab.setTitle,
      onInput: pty.write,
      platform: getPlatform(),
    );

    pty.out.listen(terminal.write);

    final focusNode = FocusNode();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });

    pty.exitCode.then((_) {
      tab.requestClose();
    });

    return Tab(
      controller: tab,
      title: 'Terminal',
      content: GestureDetector(
        onLongPress: () {
          final dylib = DynamicLibrary.process();
          final hola = dylib.lookupFunction<Int32 Function(), int Function()>('hola');
          print('hola()');
          print(hola());
        },
        onSecondaryTapDown: (details) async {
          final clipboardData = await Clipboard.getData('text/plain');
          final hasSelection = !terminal.selection.isEmpty;
          final clipboardHasData = clipboardData?.text?.isNotEmpty == true;

          showMacosContextMenu(
            context: context,
            globalPosition: details.globalPosition,
            children: [
              MacosContextMenuItem(
                content: Text('Copy'),
                trailing: Text('⌘ C'),
                enabled: hasSelection,
                onTap: () {
                  final text = terminal.getSelectedText();
                  Clipboard.setData(ClipboardData(text: text));
                  terminal.selection.clear();
                  terminal.debug.onMsg('copy ┤$text├');
                  terminal.refresh();
                  Navigator.of(context).pop();
                },
              ),
              MacosContextMenuItem(
                content: Text('Paste'),
                trailing: Text('⌘ V'),
                enabled: clipboardHasData,
                onTap: () {
                  terminal.paste(clipboardData!.text!);
                  terminal.debug.onMsg('paste ┤${clipboardData.text}├');
                  Navigator.of(context).pop();
                },
              ),
              MacosContextMenuItem(
                content: Text('Select All'),
                trailing: Text('⌘ A'),
                onTap: () {
                  print('Select All is currently not implemented.');
                  Navigator.of(context).pop();
                },
              ),
              MacosContextMenuDivider(),
              MacosContextMenuItem(
                content: Text('Clear'),
                trailing: Text('⌘ K'),
                onTap: () {
                  print('Clear is currently not implemented.');
                  Navigator.of(context).pop();
                },
              ),
              MacosContextMenuDivider(),
              MacosContextMenuItem(
                content: Text('Kill'),
                onTap: () {
                  pty.kill();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        child: CupertinoScrollbar(
          child: TerminalView(
            terminal: terminal,
            onResize: pty.resize,
            focusNode: focusNode,
            opacity: 0.85,
            style: TerminalStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
      onActivate: () {
        focusNode.requestFocus();
      },
      onDrop: () {
        SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
          focusNode.requestFocus();
        });
      },
      onClose: () {
        pty.kill();
      },
    );
  }

  String getShell() {
    if (Platform.isWindows) {
      // return r'C:\windows\system32\cmd.exe';
      return r'C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe';
    }

    return Platform.environment['SHELL'] ?? 'sh';
  }

  PlatformBehavior getPlatform() {
    if (Platform.isWindows) {
      return PlatformBehaviors.windows;
    }

    return PlatformBehaviors.unix;
  }
}
