import SwiftUI

@available(macOS 10.15, *)
public enum Presented<Item> {
    case sheet(
        item: Item,
        onDismiss: (() -> Void)? = nil
    )
    case fullScreenCover(
        item: Item,
        onDismiss: (() -> Void)? = nil
    )
    case popover(
        item: Item,
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge? = nil,
        onDismiss: (() -> Void)? = nil
    )
    case overlay(
        item: Item,
        canCloseWhenTapBackground: Bool = true,
        blurRadius: CGFloat = 0,
        background: AnyView,
        onDismiss: (() -> Void)? = nil
    )
    case context(
        item: Item,
        parentFrame: CGRect,
        canCloseWhenTapBackground: Bool = true,
        blurRadius: CGFloat = 0,
        background: AnyView,
        onDismiss: (() -> Void)? = nil
    )
}

@available(macOS 10.15, *)
extension Presented {
    public var item: Item {
        switch self {
        case .sheet(let item, _):
            item
        case .fullScreenCover(let item, _):
            item
        case .popover(let item, _, _, _):
            item
        case .overlay(let item, _, _, _, _):
            item
        case .context(let item, _, _, _, _, _):
            item
        }
    }
    
    public var onDismiss: (() -> Void)? {
        switch self {
        case .sheet(_, let onDismiss):
            onDismiss
        case .fullScreenCover(_, let onDismiss):
            onDismiss
        case .popover(_, _, _, let onDismiss):
            onDismiss
        case .overlay(_, _, _, _, let onDismiss):
            onDismiss
        case .context(_, _, _, _, _, let onDismiss):
            onDismiss
        }
    }
    
    public var attachmentAnchor: PopoverAttachmentAnchor {
        switch self {
        case .popover(_, let anchor, _, _): anchor
        default: .rect(.bounds)
        }
    }
    
    public var arrowEdge: Edge? {
        switch self {
        case .popover(_, _, let edge, _):
            edge
        default:
            nil
        }
    }
    
    public var parentFrame: CGRect? {
        switch self {
        case .context(_, let parentFrame, _, _, _, _):
            parentFrame
        default:
            nil
        }
    }
    
    public var canCloseWhenTapBackground: Bool {
        switch self {
        case .overlay(_, let canCloseWhenTapBackground, _, _, _):
            canCloseWhenTapBackground
        case .context(_, _, let canCloseWhenTapBackground, _, _, _):
            canCloseWhenTapBackground
        default:
            false
        }
    }
    
    public var blurRadius: CGFloat {
        switch self {
        case .overlay(_, _, let radius, _, _):
            radius
        case .context(_, _, _, let radius, _, _):
            radius
        default:
            0
        }
    }
    
    @ViewBuilder public var background: some View {
        switch self {
        case .overlay(_, _, _, let background, _):
            background
        case .context(_, _, _, _, let background, _):
            background
        default:
            EmptyView()
        }
    }
    
    public static func ==(lhs: Self, rhs: PresentedType) -> Bool {
        switch (lhs, rhs) {
        case (.sheet, .sheet): true
        case (.fullScreenCover, .fullScreenCover): true
        case (.popover, .popover): true
        case (.overlay, .overlay): true
        case (.context, .overlay): true
        default: false
        }
    }
}
