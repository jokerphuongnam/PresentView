import SwiftUI

enum PresentedType {
    case sheet
    case fullScreenCover
    case popover
    case overlay
}

@MainActor private struct PresentedViewModifier<PresentedContent, Item>: ViewModifier where PresentedContent: View {
    private var isPresented: (PresentedType) -> Binding<Bool>
    private let presented: Presented<Item>?
    private let presentedContent: (Item) -> PresentedContent
    
    init(isPresented: @escaping (PresentedType) -> Binding<Bool>, presented: Presented<Item>?, @ViewBuilder presentedContent: @escaping (Item) -> PresentedContent) {
        self.isPresented = isPresented
        self.presented = presented
        self.presentedContent = presentedContent
    }
    
    func body(content: Content) -> some View {
        let isOverlay = isPresented(.overlay)
        let item = presented?.item
        
        content.blur(radius: presented?.blurRadius ?? 0)
            .sheet(isPresented: isPresented(.sheet), onDismiss: presented?.onDismiss) {
                if let item {
                    presentedContent(item)
                }
            }
            .fullScreenCover(isPresented: isPresented(.fullScreenCover), onDismiss: presented?.onDismiss) {
                if let item {
                    presentedContent(item)
                }
            }
            .popover(isPresented: isPresented(.popover), attachmentAnchor: presented?.attachmentAnchor ?? .rect(.bounds), arrowEdge: presented?.arrowEdge) {
                if let item {
                    presentedContent(item)
                }
            }
            .overlay(alignment: .center) {
                if isOverlay.wrappedValue, let item {
                    ZStack {
                        presented?.background
                            .ignoresSafeArea(.all)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .onTapGesture {
                                if presented?.canCloseWhenTapBackground ?? false {
                                    isOverlay.wrappedValue = false
                                }
                            }
                        
                        presentedContent(item)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
}

extension View {
    func presented<PresentedContent, Item>(
        isPresented: @escaping (PresentedType) -> Binding<Bool>,
        presented: Presented<Item>?,
        @ViewBuilder presentedContent: @escaping (Item) -> PresentedContent
    ) -> some View where PresentedContent: View {
        modifier(PresentedViewModifier(isPresented: isPresented, presented: presented, presentedContent: presentedContent))
    }
}
