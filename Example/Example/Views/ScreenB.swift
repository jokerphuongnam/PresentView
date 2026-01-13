import SwiftUI
import PresentView

struct ScreenB: View {
    @Binding var presented: [Presented<Screen>]
    @Environment(\.dismissPresented) private var dismissPresented
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    dismissPresented()
                } label: {
                    Text("Pop")
                }
                
                Button {
                    presented.overlay(item: .screenC) {
                        Color.white.opacity(0.3)
                    } onDismiss: {
                        print("Dismiss C")
                    }
                } label: {
                    Text("Screen C")
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Screen B")
            .background(Color.yellow)
        }
    }
}
