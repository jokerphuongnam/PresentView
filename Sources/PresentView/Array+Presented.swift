import SwiftUI

extension Array {
    @available(macOS 10.15, *)
    public mutating func sheet<Item>(item: Item, onDismiss: (() -> Void)? = nil) where Self.Element == Presented<Item> {
        withAnimation {
            append(.sheet(item: item, onDismiss: onDismiss))
        }
    }
    
    @available(macOS 10.15, *)
    public mutating func fullScreenCover<Item>(item: Item, onDismiss: (() -> Void)? = nil) where Self.Element == Presented<Item> {
        withAnimation {
            append(.fullScreenCover(item: item, onDismiss: onDismiss))
        }
    }
    
    @available(macOS 10.15, *)
    public mutating func popover<Item>(item: Item, attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds), arrowEdge: Edge? = nil) where Self.Element == Presented<Item> {
        withAnimation {
            append(.popover(item: item, attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge))
        }
    }
    
    @available(macOS 10.15, *)
    public mutating func overlay<Item>(item: Item, canCloseWhenTapBackground: Bool = true, blurRadius: CGFloat = 5) where Self.Element == Presented<Item> {
        withAnimation {
            append(.overlay(item: item, canCloseWhenTapBackground: canCloseWhenTapBackground, blurRadius: blurRadius, background: AnyView(Color.black.opacity(0.3))))
        }
    }
    
    @available(macOS 10.15, *)
    public mutating func overlay<Item, Background>(item: Item, canCloseWhenTapBackground: Bool = true, blurRadius: CGFloat = 5, @ViewBuilder background: () -> Background) where Self.Element == Presented<Item>, Background: View {
        withAnimation {
            append(.overlay(item: item, canCloseWhenTapBackground: canCloseWhenTapBackground, blurRadius: blurRadius, background: AnyView(background())))
        }
    }
    
    @available(macOS 10.15, *)
    @discardableResult public mutating func pop<Item>() -> Item? where Self.Element == Presented<Item>  {
        if isEmpty { return nil }
        return removeLast().item
    }
}

extension Array {
    @available(macOS 10.15, *)
    public subscript<Item>(safe index: Index) -> Item? where Self.Element == Presented<Item>  {
        if (0..<count).contains(index) {
            return self[index].item
        }
        return nil
    }
    
    
    public subscript(safe index: Index) -> Element?  {
        if (0..<count).contains(index) {
            return self[index]
        }
        return nil
    }
}
