import SwiftUI

#if canImport(UIKit)
import UIKit

extension View {
    @inlinable nonisolated public func transparentBackground(canTapToDismiss: Bool = true, backgroundColor: Color? = nil) -> some View {
        background(
            TransparentBackground(
                canTapToDismiss: canTapToDismiss,
                shapeStyle: backgroundColor
            )
        )
    }
    
    @inlinable nonisolated public func transparentBackground<S>(canTapToDismiss: Bool = true, shapeStyle: S) -> some View where S: ShapeStyle {
        background(
            TransparentBackground(
                canTapToDismiss: canTapToDismiss,
                shapeStyle: shapeStyle
            )
        )
    }
}

@usableFromInline nonisolated struct TransparentBackground<S>: UIViewRepresentable where S: ShapeStyle {
    @Environment(\.dismissPresented) fileprivate var dismissPresented
    let canTapToDismiss: Bool
    let shapeStyle: S?
    
    @usableFromInline nonisolated init(canTapToDismiss: Bool, shapeStyle: S?) {
        self.canTapToDismiss = canTapToDismiss
        self.shapeStyle = shapeStyle
    }
    
    @usableFromInline func makeUIView(context: Context) -> UIView {
        let view = TransparentBackgroundView(shapeStyle: shapeStyle)
        view.backgroundColor = .clear
        
        if canTapToDismiss {
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(context.coordinator.dismiss)
            )
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        return view
    }
    
    @usableFromInline func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    @usableFromInline func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    @usableFromInline final class Coordinator {
        let parent: TransparentBackground
        var dismissed: Bool = false
        
        @usableFromInline init(parent: TransparentBackground) {
            self.parent = parent
        }
        
        @usableFromInline @objc func dismiss() {
            parent.dismissPresented()
            dismissed = true
        }
    }
    
    private struct ShapeStyleBackground<S>: View where S: ShapeStyle {
        let shapeStyle: S
        
        var body: some View {
            Rectangle()
                .fill(shapeStyle)
                .ignoresSafeArea()
        }
    }
    
    private final class TransparentBackgroundView: UIView {
        private let shapeStyle: S?
        
        init(shapeStyle: S?) {
            self.shapeStyle = shapeStyle
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func didMoveToWindow() {
            super.didMoveToWindow()
            guard let window else { return }
            
            guard
                let rootVC = window.rootViewController,
                let presentedVC = rootVC.presentedViewController,
                presentedVC.modalPresentationStyle == .overFullScreen
            else {
                return
            }
            if let backgroundColor = shapeStyle as? Color {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.superview?.superview?.backgroundColor = UIColor(backgroundColor)
                }
            } else if let shapeStyle {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.superview?.superview?.backgroundColor = .clear
                    guard let container = self.superview?.superview else { return }
                    
                    let hosting = UIHostingController(
                        rootView: ShapeStyleBackground(shapeStyle: shapeStyle)
                    )
                    hosting.view.translatesAutoresizingMaskIntoConstraints = false
                    hosting.view.backgroundColor = .clear
                    hosting.view.tag = 999
                    hosting.view.isUserInteractionEnabled = false
                    
                    container.insertSubview(hosting.view, at: 0)
                    
                    NSLayoutConstraint.activate([
                        hosting.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                        hosting.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                        hosting.view.topAnchor.constraint(equalTo: container.topAnchor),
                        hosting.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
                    ])
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.superview?.superview?.backgroundColor = .clear
                }
            }
        }
    }
}
#endif
