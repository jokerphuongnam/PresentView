import SwiftUI

extension View {
    @MainActor @preconcurrency public func getFrame(frame: Binding<CGRect>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        frame.wrappedValue = proxy.frame(in: .global)
                    }
                    .onChange(of: proxy.size) { _ in
                        frame.wrappedValue = proxy.frame(in: .global)
                    }
            }
        )
    }
}
