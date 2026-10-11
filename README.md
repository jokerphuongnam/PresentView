# PresentView

PresentView is a lightweight SwiftUI utility that helps manage view presentation in a unified, stack-based way.

It allows you to present and dismiss multiple screens using a single source of truth. One `[Presented]` array is the coordinator for a flow. `PresentView` draws that array. Current release: `1.2.1`.

`from: "1.0.0"` stays on 1.x. `1.2.0` adds `dialog` and keeps `sheet`, `fullScreenCover`, `popover`, `overlay`, and `context`.

---

## Features

- Centralized presentation state
- Support for `sheet`, `fullScreenCover`, `dialog`, `popover`, `overlay`, and `context`
- Nested presentations
- Environment-based dismiss handling
- Clean, declarative SwiftUI API

---

## Installation

### Swift Package Manager

Add PresentView using Swift Package Manager:

```
https://github.com/jokerphuongnam/PresentView
```

---

## Basic Concept

Presentations are managed by an array:

```swift
@Published var presented: [Presented<Screen>] = []
```

Each `Presented` item describes how a screen is presented.

---

## Usage Example

The Example app stores one array and draws it with `PresentView`. Home has one button for every style. A presented screen reads the same array and can present the next screen.

```swift
@StateObject private var vm = ContentViewModel()

PresentView(presented: $vm.presented) {
    VStack {
        Button("Sheet — Screen A") { vm.presented.sheet(item: .screenA) }
        Button("Dialog — Screen C") { vm.presented.dialog(item: .screenC) }
        Button("Full screen cover — Screen C") { vm.presented.fullScreenCover(item: .screenC) }
        Button("Overlay — Screen C") { vm.presented.overlay(item: .screenC) }
        Button("Popover — Screen B") { vm.presented.popover(item: .screenB) }
        Button("Context — anchored to this button") {
            vm.presented.context(item: .screenC, parentFrame: buttonFrame)
        }
        .getFrame(frame: $buttonFrame)
    }
} presentedContent: { screen in
    switch screen {
    case .screenA: ScreenA(presented: $vm.presented)
    case .screenB: ScreenB(presented: $vm.presented)
    case .screenC: ScreenC()
    case .screenD: ScreenD().transparentBackground()
    case .list: ListView(presented: $vm.presented)
    case .item(let index): ItemView(item: index)
    }
}
```

`ScreenA` is the sheet. From there the same array opens Screen B as a full screen cover, Screen C as an overlay or a context, and `dismissPresented()` removes only the top layer.

---

## Presenting Screens

### Sheet

```swift
presented.sheet(item: .screenA)
```

### Full Screen Cover

```swift
presented.fullScreenCover(item: .screenB)
```

### Dialog

A dialog is a centered card on a dim background. It is not a `fullScreenCover` restyled as a dialog. The content keeps its own size. Tapping the dim background dismisses it unless `canCloseWhenTapBackground` is `false`.

```swift
presented.dialog(item: .screenA)
```

### Overlay

```swift
presented.overlay(item: .screenC)
```

### Popover

```swift
presented.popover(item: .screenB)
```

### Context

```swift
presented.context(item: .screenC, parentFrame: buttonFrame)
```

With custom background:

```swift
presented.overlay(item: .screenC) {
    Color.white.opacity(0.3)
}
```

---

## Dismissing

Access the dismiss handler from the environment:

```swift
@Environment(\.dismissPresented) private var dismissPresented
```

Dismiss the current presentation:

```swift
dismissPresented()
```

Check if dismissal is possible:

```swift
dismissPresented.canDismiss
```

---

## Transparent Background for `fullScreenCover`

This feature provides a SwiftUI modifier that allows `fullScreenCover` to display with a transparent background instead of the default opaque presentation.

### Usage

```swift
.transparentBackground()
```

---

## Versions

| Version | What it is |
|---|---|
| 1.0.0 | First release |
| 1.0.1 | Patch on 1.0.0 |
| 1.0.2 | MIT license |
| 1.0.3 | Patch |
| 1.0.4 | Patch |
| 1.0.5 | Patch |
| 1.1.0 | Minor presentation update |
| 1.1.1 | Patch |
| 1.1.2 | Patch |
| 1.1.3 | Patch |
| 1.1.4 | Patch |
| 1.1.5 | Patch |
| 1.2.0 | `dialog` on the same stack. macOS deployment is 13. `sheet`, `fullScreenCover`, `popover`, `overlay`, and `context` stay |
| 1.2.1 | Unit tests, Example UI tests, and a Home button for every style including popover |

## Tests

Unit tests live in `Tests/PresentViewTests` and run with `swift test`. They cover every style on one array, `pop`, the safe subscript, dialog dismiss flags, and `dismissPresented`.

UI tests live in `Example/ExampleUITests`. Run the `Example` scheme on an iOS Simulator. They open a sheet, a dialog, an overlay, and a full screen cover, then dismiss each one.

## License

MIT License. See [LICENSE](./LICENSE) for details.

## Contributing
Please read [CONTRIBUTING.md](./CONTRIBUTING.md) before submitting a pull request.
