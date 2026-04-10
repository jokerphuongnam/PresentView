import SwiftUI

#if canImport(UIKit)
import UIKit

extension View {
    @inlinable nonisolated public func transparentBackground(
        canTapToDismiss: Bool = true,
        backgroundColor: Color? = nil
    ) -> some View {
        background(
            TransparentBackground(
                canTapToDismiss: canTapToDismiss,
                shapeStyle: backgroundColor
            )
        )
    }
    
    @inlinable nonisolated public func transparentBackground<S>(
        canTapToDismiss: Bool = true,
        shapeStyle: S
    ) -> some View where S: ShapeStyle {
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
        let view = TransparentBackgroundView(shapeStyle: shapeStyle, coordinator: context.coordinator, canTapToDismiss: canTapToDismiss)
        view.backgroundColor = .clear
        return view
    }
    
    @usableFromInline func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self
    }
    
    @usableFromInline func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    @usableFromInline final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: TransparentBackground
        var dismissed: Bool = false
        weak var presentedVC: UIViewController?
        weak var cardView: UIView?
        
        @usableFromInline init(parent: TransparentBackground) {
            self.parent = parent
        }
        
        @usableFromInline @objc func dismiss() {
            guard !dismissed else { return }
            dismissed = true
            guard let vc = presentedVC else {
                parent.dismissPresented()
                return
            }
            UIView.animate(withDuration: 0.2) { [weak vc] in
                guard let vc else { return }
                vc.view.alpha = 0
            } completion: { [weak self, weak vc] _ in
                guard let self, let vc else { return }
                vc.modalTransitionStyle = .coverVertical
                self.parent.dismissPresented()
            }
        }
        
        public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            guard let cardView, let hostView = gestureRecognizer.view else { return true }
            let location = touch.location(in: hostView)
            let cardFrame = cardView.convert(cardView.bounds, to: hostView)
            return !cardFrame.contains(location)
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
        private weak var coordinator: Coordinator?
        private let canTapToDismiss: Bool
        
        init(shapeStyle: S?, coordinator: Coordinator?, canTapToDismiss: Bool) {
            self.shapeStyle = shapeStyle
            self.coordinator = coordinator
            self.canTapToDismiss = canTapToDismiss
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
            
            presentedVC.view.layer.removeAllAnimations()
            presentedVC.view.frame = window.bounds
            presentedVC.view.alpha = 0
            coordinator?.presentedVC = presentedVC
            presentedVC.modalTransitionStyle = .crossDissolve
            UIView.animate(withDuration: 0.25) { [weak presentedVC] in
                guard let presentedVC else { return }
                presentedVC.view.alpha = 1
            }
            
            if canTapToDismiss, let coordinator {
                let tap = UITapGestureRecognizer(
                    target: coordinator,
                    action: #selector(Coordinator.dismiss)
                )
                tap.cancelsTouchesInView = false
                tap.delegate = coordinator
                coordinator.cardView = self
                presentedVC.view.addGestureRecognizer(tap)
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
