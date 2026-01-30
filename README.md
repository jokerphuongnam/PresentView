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
    @State private var buttonFrame: CGRect = .zero
    @State private var buttonListFrame: CGRect = .zero
    
    var body: some View {
        PresentView(
            presented: $vm.presented) {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                    
                    Button {
                        vm.presented.sheet(item: .screenA)
                    } label: {
                        Text("Screen A")
                    }
                    
                    Button {
                        vm.presented.context(item: .screenC, parentFrame: buttonFrame)
                    } label: {
                        Text("Context ScreenC")
                    }
                    .getFrame(frame: $buttonFrame)
                    
                    Button {
                        vm.presented.fullScreenCover(item: .list)
                    } label: {
                        Text("List")
                    }
                    .getFrame(frame: $buttonListFrame)
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
                        .shadow(radius: 1)
                        .transparentBackground()
                case .list:
                    ListView(presented: $vm.presented)
                case .item(let index):
                    ItemView(item: index)
                        .shadow(radius: 1)
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

### Context
```swift
presented.context(item: .item(index: index), parentFrame: parentFrame)
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

## License

MIT License. See [LICENSE](./LICENSE) for details.

## Contributing
Please read [CONTRIBUTING.md](./CONTRIBUTING.md) before submitting a pull request.
