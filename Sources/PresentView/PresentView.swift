import SwiftUI

@available(iOS 13.0, macOS 12.0, tvOS 16.0, watchOS 6.0, *)
public struct PresentView<RootContent, PresentedContent, Item>: View where RootContent: View, PresentedContent: View, Item: Equatable {
    @Binding private var presented: [Presented<Item>]
    @Environment(\.dismiss) private var dismiss
#if os(iOS)
    @State private var keyboardHeight: CGFloat = 0
#endif
    private let rootContent: () -> RootContent
    private let presentedContent: (Item) -> PresentedContent
    
    public init(presented: Binding<[Presented<Item>]>, @ViewBuilder rootContent: @escaping () -> RootContent, @ViewBuilder presentedContent: @escaping (Item) -> PresentedContent) {
        self._presented = presented
        self.rootContent = rootContent
        self.presentedContent = presentedContent
    }
    
    public var body: some View {
        let item = presented.first
        
        rootContent()
            .presented(
                isPresented: binding,
                presented: item
            ) { item in
                NodeView(presented: $presented, index: 0, presentedContent: presentedContent)
            }
            .environment(\.dismissPresented, DismissPresentedActionImpl($presented))
#if os(iOS)
            .environment(\.keyboardHeight, keyboardHeight)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = max(0, UIScreen.main.bounds.height - frame.origin.y)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                keyboardHeight = 0
            }
#endif
    }
    
    private func binding(type: PresentedType) -> Binding<Bool> {
        .init {
            guard let item = presented.first else { return false }
            return item == type
        } set: { newValue, transaction in
            if !newValue, !presented.isEmpty {
                let _ = withTransaction(transaction) {
                    presented.remove(at: 0)
                }
            }
        }
    }
}
