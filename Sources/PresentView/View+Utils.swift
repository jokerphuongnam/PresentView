import SwiftUI

extension View {
    @MainActor @preconcurrency public func getFrame(frame: Binding<CGRect>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        let globalFrame = proxy.frame(in: .global)
                        let newFrame = CGRect(
                            x: globalFrame.minX,
                            y: globalFrame.minY,
                            width: globalFrame.width,
                            height: globalFrame.height
                        )

                        frame.wrappedValue = newFrame
                    }
            }
        )
    }
}
