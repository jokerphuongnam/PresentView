import SwiftUI
import PresentView

struct ContentView: View {
    @StateObject private var vm: ContentViewModel = .init()
    @State private var buttonFrame: CGRect = .zero
    @State private var buttonListFrame: CGRect = .zero
    
    var body: some View {
        PresentView(
            presented: $vm.presented) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("One stack for this flow")
                        .font(.headline)
                    Text("Every button appends to the same presented array. The presented screen can present the next one.")
                        .font(.subheadline)

                    Button {
                        vm.presented.sheet(item: .screenA)
                    } label: {
                        Text("Sheet — Screen A")
                    }
                    .accessibilityIdentifier("open-sheet")

                    Button {
                        vm.presented.dialog(item: .screenC)
                    } label: {
                        Text("Dialog — Screen C")
                    }
                    .accessibilityIdentifier("open-dialog")

                    Button {
                        vm.presented.fullScreenCover(item: .screenC)
                    } label: {
                        Text("Full screen cover — Screen C")
                    }
                    .accessibilityIdentifier("open-cover")

                    Button {
                        vm.presented.fullScreenCover(item: .screenD)
                    } label: {
                        Text("Full screen cover — transparent Screen D")
                    }

                    Button {
                        vm.presented.overlay(item: .screenC)
                    } label: {
                        Text("Overlay — Screen C")
                    }
                    .accessibilityIdentifier("open-overlay")

                    Button {
                        vm.presented.popover(item: .screenB)
                    } label: {
                        Text("Popover — Screen B")
                    }

                    Button {
                        vm.presented.context(item: .screenC, parentFrame: buttonFrame)
                    } label: {
                        Text("Context — anchored to this button")
                    }
                    .accessibilityIdentifier("open-context")
                    .getFrame(frame: $buttonFrame)

                    Button {
                        vm.presented.fullScreenCover(item: .list)
                    } label: {
                        Text("Full screen cover — list")
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
                        .transparentBackground(backgroundColor: .black.opacity(0.3))
                case .screenD:
                    ScreenD()
                        .shadow(radius: 1)
                        .transparentBackground(
                            shapeStyle: LinearGradient(
                                colors: [
                                    .clear,
                                    .black.opacity(0.3)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                case .list:
                    ListView(presented: $vm.presented)
                case .item(let index):
                    ItemView(item: index)
                        .shadow(radius: 1)
                }
            }
    }
}

private final class ContentViewModel: ObservableObject {
    @Published fileprivate var presented: [Presented<Screen>] = []
}

#Preview {
    ContentView()
}
