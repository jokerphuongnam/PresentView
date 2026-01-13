import SwiftUI
import PresentView

struct ScreenA: View {
    @Binding var presented: [Presented<Screen>]
    @Environment(\.dismissPresented) private var dismissPresented
    @State private var buttonFrame: CGRect = .zero
    
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
            
            Button {
                presented.context(item: .screenC, parentFrame: buttonFrame)
            } label: {
                Text("Context ScreenC")
            }
            .getFrame(frame: $buttonFrame)
        }
    }
}
