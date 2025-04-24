import SwiftUI
import PresentView

struct ContentView: View {
    @StateObject private var vm: ContentViewModel = .init()
    
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

private final class ContentViewModel: ObservableObject {
    @Published fileprivate var presented: [Presented<Screen>] = []
}

#Preview {
    ContentView()
}
