# PresentView

PresentView is a lightweight SwiftUI utility that helps manage view presentation in a unified, stack-based way.

It allows you to present and dismiss multiple screens using a single source of truth, supporting `sheet`, `fullScreenCover`, and custom `overlay` presentations.

---

## Features

- Centralized presentation state
- Support for `sheet`, `fullScreenCover`, and `overlay`
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

### Screen Enum

```swift
enum Screen: Hashable {
    case screenA
    case screenB
    case screenC
}
```

---

### ContentView

```swift
import SwiftUI
import PresentView

struct ContentView: View {
    @StateObject private var vm: ContentViewModel = .init()

    var body: some View {
        PresentView(
            presented: $vm.presented
        ) {
            VStack {
                Text("Hello, world!")

                Button {
                    vm.presented.sheet(item: .screenA)
                } label: {
                    Text("Screen A")
                }
            }
            .padding()
        } presentedContent: { screen in
            switch screen {
            case .screenA:
                ScreenA(presented: $vm.presented)
            case .screenB:
                ScreenB(presented: $vm.presented)
            case .screenC:
                ScreenC()
            }
        }
    }
}

final class ContentViewModel: ObservableObject {
    @Published var presented: [Presented<Screen>] = []
}
```

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

### Overlay

```swift
presented.overlay(item: .screenC)
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

## License

MIT License

## Contributing
Please read [CONTRIBUTING.md](./CONTRIBUTING.md) before submitting a pull request.