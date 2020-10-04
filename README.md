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

**Flutter 1.22.0+ is recommended to build Terminal Lite.**

Make sure Flutter desktop support is enabled:

```
flutter channel dev
// or flutter channel master

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

> Windows build may fail when using flutter 1.23.0+, to resolve this issue, delete the `windows` folder then run `flutter create .`, or simply `git checkout flutter_1.23.0`


## Known issues

- [Pty](https://github.com/TerminalStudio/pty) may not work in **debug mode**.
- Some special characters may not render in **MacOS**, maybe caused by [fontFamilyFallback](https://github.com/TerminalStudio/xterm.dart/blob/2800cfba0e1a945b3588e5658cf0801684c91027/lib/theme/terminal_style.dart#L2)?
- When multiple tabs are opened, focus may not move between those tabs correctly.

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/TerminalStudio/lite/issues).

Contributions are always welcome!