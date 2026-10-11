import SwiftUI
import PresentView

struct ScreenA: View {
    @Binding var presented: [Presented<Screen>]
    @Environment(\.dismissPresented) private var dismissPresented
    @State private var buttonFrame: CGRect = .zero
    
    var body: some View {
        VStack {
            Text("Sheet: Screen A")
            Text("This page uses the same presented array.")
            Button {
                dismissPresented()
            } label: {
                Text("Pop")
            }
            .accessibilityIdentifier("dismiss-presented")
            
            Button {
                presented.fullScreenCover(item: .screenB)
            } label: {
                Text("Screen B")
            }
            
            Button {
                presented.fullScreenCover(item: .screenC)
            } label: {
                Text("Screen C Background")
            }
            
            Button {
                presented.fullScreenCover(item: .screenD)
            } label: {
                Text("Screen D Shape style")
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
