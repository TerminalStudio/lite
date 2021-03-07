## Terminal Lite

Experimental cross-platform terminal emulator application written in Flutter.

## Screenshots

<table>
  </tr>
    <td>
       Windows
    </td>
    <td>
       Linux
    </td>
    <td>
        MacOS
    </td>
  </tr>
  <tr>
    <td>
		<img width="300px" src="https://raw.githubusercontent.com/TerminalStudio/lite/master/media/demo-windows.png">
    </td>
    <td>
       <img width="300px" src="https://raw.githubusercontent.com/TerminalStudio/lite/master/media/demo-linux.png">
    </td>
    <td>
       <img width="300px" src="https://raw.githubusercontent.com/TerminalStudio/lite/master/media/demo-macos.png">
    </td>
  <tr>
</table>

## Prebuilt binaries

Prebuilt binaries are available for Windows, Linux, and MacOS on the [releases](https://github.com/TerminalStudio/lite/releases) page.

## Build

**Flutter 2.0.0+ is required to build Terminal Lite.**

Make sure Flutter desktop support is enabled:

```
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

Fetch dependencies and build:

```
flutter pub get
flutter pub upgrade
flutter run --release
```

For the underlying backend-agnostic terminal emulator **widget**, see [xterm.dart](https://github.com/TerminalStudio/xterm.dart).


## Known issues

- [Pty](https://github.com/TerminalStudio/pty) may not work in **debug mode** on windows.
- ~~Some special characters may not render in **MacOS**, maybe caused by [fontFamilyFallback](https://github.com/TerminalStudio/xterm.dart/blob/2800cfba0e1a945b3588e5658cf0801684c91027/lib/theme/terminal_style.dart#L2)?~~
- When multiple tabs are opened, focus may not move between those tabs correctly.

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/TerminalStudio/lite/issues).

Contributions are always welcome!