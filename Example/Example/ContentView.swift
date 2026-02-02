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
                        vm.presented.fullScreenCover(item: .screenD)
                    } label: {
                        Text("Screen D Shape style")
                    }
                    
                    Button {
                        vm.presented.overlay(item: .screenC)
                    } label: {
                        Text("Screen C")
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
