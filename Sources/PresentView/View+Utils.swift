import SwiftUI

extension View {
    @MainActor @preconcurrency public func getFrame(frame: Binding<CGRect>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        frame.wrappedValue = proxy.frame(in: .global)
                    }
                    .onChange(of: proxy.frame(in: .global)) { newValue in
                        guard frame.wrappedValue != newValue else { return }
                        frame.wrappedValue = newValue
                    }
            }
        )
    }
}
