import SwiftUI

public enum Presented<Item> {
    case sheet(item: Item, onDismiss: (() -> Void)? = nil)
    case fullScreenCover(item: Item, onDismiss: (() -> Void)? = nil)
    case popover(item: Item, attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds), arrowEdge: Edge? = nil)
    case overlay(item: Item, canCloseWhenTapBackground: Bool = true, blurRadius: CGFloat = 0, background: AnyView)
}

extension Presented {
    var item: Item {
        switch self {
        case .sheet(let item, _):
            item
        case .fullScreenCover(let item, _):
            item
        case .popover(let item, _, _):
            item
        case .overlay(let item, _, _, _):
            item
        }
    }
    
    var onDismiss: (() -> Void)? {
        switch self {
        case .sheet(_, let onDismiss):
            onDismiss
        case .fullScreenCover(_, let onDismiss):
            onDismiss
        default:
            nil
        }
    }
    
    var attachmentAnchor: PopoverAttachmentAnchor {
        switch self {
        case .popover(_, let anchor, _):
            anchor
        default:
                .rect(.bounds)
        }
    }
    
    var arrowEdge: Edge? {
        switch self {
        case .popover(_, _, let edge):
            edge
        default:
            nil
        }
    }
    
    var canCloseWhenTapBackground: Bool {
        switch self {
        case .overlay(_, let canCloseWhenTapBackground, _, _):
            canCloseWhenTapBackground
        default:
            false
        }
    }
    
    var blurRadius: CGFloat {
        switch self {
        case .overlay(_, _, let radius, _):
            radius
        default:
            0
        }
    }
    
    @ViewBuilder var background: some View {
        switch self {
        case .overlay(_, _, _, let background):
            background
        default:
            EmptyView()
        }
    }
    
    static func ==(lhs: Self, rhs: PresentedType) -> Bool {
        switch (lhs, rhs) {
        case (.sheet, .sheet): true
        case (.fullScreenCover, .fullScreenCover): true
        case (.popover, .popover): true
        case (.overlay, .overlay): true
        default: false
        }
    }
}
