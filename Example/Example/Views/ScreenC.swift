import SwiftUI

struct ScreenC: View {
    @Environment(\.dismissPresented) private var dismissPresented
    
    var body: some View {
        VStack {
            Text("Screen C")
            
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
