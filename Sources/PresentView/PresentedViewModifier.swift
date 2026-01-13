import SwiftUI

public enum PresentedType {
    case sheet
    case fullScreenCover
    case popover
    case overlay
}

@available(tvOS 16.0, *)
@available(macOS 12.0, *)
@MainActor private struct PresentedViewModifier<PresentedContent, Item>: ViewModifier where PresentedContent: View {
    @State private var presentedFrame: CGRect = .zero
    
#if os(iOS)
    private let screen = UIScreen.main.bounds
#elseif os(macOS)
    private let screen = NSScreen.main?.visibleFrame ?? .zero
#endif
    private let spacing: CGFloat = 4
    private let padding: CGFloat = 12
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
#if os(iOS)
            .fullScreenCover(isPresented: isPresented(.fullScreenCover), onDismiss: presented?.onDismiss) {
                if let item {
                    presentedContent(item)
                }
            }
#endif
#if !os(watchOS) && !os(tvOS)
            .popover(isPresented: isPresented(.popover), attachmentAnchor: presented?.attachmentAnchor ?? .rect(.bounds), arrowEdge: presented?.arrowEdge) {
                if let item {
                    presentedContent(item)
                        .onDisappear {
                            presented?.onDismiss?()
                        }
                }
            }
#endif
            .overlay(alignment: .center) {
                if isOverlay.wrappedValue, let item {
                    ZStack(alignment: zstackAligment) {
                        presented?.background
                            .ignoresSafeArea(.all)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
#if os(iOS)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
#endif
                            .onTapGesture {
                                if presented?.canCloseWhenTapBackground ?? false {
                                    isOverlay.wrappedValue = false
                                }
                            }
                        
                        if isContext {
                            presentedContent(item)
                                .onDisappear {
                                    presented?.onDismiss?()
                                }
                                .getFrame(frame: $presentedFrame)
                                .position(position)
                        } else {
                            presentedContent(item)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .onDisappear {
                                    presented?.onDismiss?()
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    
    private var position: CGPoint {
        guard let presented,
              let parentFrame = presented.parentFrame else {
            return .zero
        }
        let overlaySize = presentedFrame.size
        let desiredX = parentFrame.maxX - overlaySize.width / 2
        let desiredY = parentFrame.maxY + spacing + overlaySize.height / 2
        
        let minX = overlaySize.width / 2 + padding
        let maxX = screen.width - overlaySize.width / 2 - padding
        
        let minY = overlaySize.height / 2 + padding
        let maxY = screen.height - overlaySize.height / 2 - padding
        
        return CGPoint(
            x: min(max(desiredX, minX), maxX),
            y: min(max(desiredY, minY), maxY)
        )
    }
    
    private var isContext: Bool {
        switch presented {
        case .context:
            true
        default:
            false
        }
    }
    
    private var zstackAligment: Alignment {
        switch presented {
        case .context:
                .topLeading
        default:
                .center
        }
    }
}

@available(tvOS 16.0, *)
@available(macOS 12.0, *)
extension View {
    func presented<PresentedContent, Item>(
        isPresented: @escaping (PresentedType) -> Binding<Bool>,
        presented: Presented<Item>?,
        @ViewBuilder presentedContent: @escaping (Item) -> PresentedContent
    ) -> some View where PresentedContent: View {
        modifier(
            PresentedViewModifier(
                isPresented: isPresented,
                presented: presented,
                presentedContent: presentedContent
            )
        )
    }
}
