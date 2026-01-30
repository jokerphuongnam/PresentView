import UIKit
import SwiftUI

extension View {
    @inlinable nonisolated public func transparentBackground(canTapToDismiss: Bool = true) -> some View {
        background(TransparentBackground(canTapToDismiss: canTapToDismiss))
    }
}

@usableFromInline nonisolated struct TransparentBackground: UIViewRepresentable {
    @Environment(\.dismissPresented) fileprivate var dismissPresented
    let canTapToDismiss: Bool
    
    @usableFromInline nonisolated init(canTapToDismiss: Bool) {
        self.canTapToDismiss = canTapToDismiss
    }
    
    @usableFromInline func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        if canTapToDismiss {
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(context.coordinator.dismiss)
            )
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        return view
    }
    
    @usableFromInline func updateUIView(_ uiView: UIView, context: Context) {}
    
    @usableFromInline func makeCoordinator() -> TransparentBackgroundCoordinator {
        TransparentBackgroundCoordinator(parent: self)
    }
}

@usableFromInline final class TransparentBackgroundCoordinator {
    let parent: TransparentBackground
    
    @usableFromInline init(parent: TransparentBackground) {
        self.parent = parent
    }
    
    @usableFromInline @objc func dismiss() {
        parent.dismissPresented()
    }
}
