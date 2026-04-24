import SwiftUI

extension View {
    @ViewBuilder @MainActor @preconcurrency public func getFrame(frame: Binding<CGRect>) -> some View {
        if #available(iOS 16.0, *) {
            onGeometryChange(
                for: CGRect.self) { proxy in
                    proxy.frame(in: .global)
                } action: { newValue in
                    frame.wrappedValue = newValue
                }
        } else {
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
}
