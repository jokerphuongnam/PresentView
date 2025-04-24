import SwiftUI
import PresentView

struct ScreenA: View {
    @Binding var presented: [Presented<Screen>]
    @Environment(\.dismissPresented) private var dismissPresented
    
    var body: some View {
        VStack {
            Button {
                dismissPresented()
            } label: {
                Text("Pop")
            }
            
            Button {
                presented.fullScreenCover(item: .screenB)
            } label: {
                Text("Screen B")
            }
            
            Button {
                presented.overlay(item: .screenC)
            } label: {
                Text("Screen C")
            }
        }
    }
}
