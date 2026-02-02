import SwiftUI

struct ScreenD: View {
    @Environment(\.dismissPresented) private var dismissPresented
    
    var body: some View {
        VStack {
            Text("Screen D")
            
            Button {
                dismissPresented()
            } label: {
                Text("Cancel")
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
    }
}
