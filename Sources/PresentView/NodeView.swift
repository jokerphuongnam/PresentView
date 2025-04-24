import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct NodeView<PresentedContent, Item>: View where PresentedContent: View {
    @Binding private var presented: [Presented<Item>]
    private let index: Int
    private let presentedContent: (Item) -> PresentedContent
    
    init(presented: Binding<[Presented<Item>]>, index: Int, presentedContent: @escaping (Item) -> PresentedContent) {
        self._presented = presented
        self.index = index
        self.presentedContent = presentedContent
    }
    
    var body: some View {
        if let item: Item = presented[safe: index] {
            presentedContent(item)
                .presented(isPresented: nextBinding, presented: next) { item in
                    NodeView(presented: $presented, index: nextIndex, presentedContent: presentedContent)
                }
        }
    }
    
    private func nextBinding(type: PresentedType) -> Binding<Bool> {
        Binding {
            guard let next else { return false }
            return next == type
        } set: { newValue, transaction in
            if !newValue, nextIndex < presented.count {
                let _ = withTransaction(transaction) {
                    presented.remove(at: nextIndex)
                }
            }
        }
    }
    
    private var next: Presented<Item>? {
        presented[safe: nextIndex]
    }
    
    private var nextIndex: Int {
        index + 1
    }
}
