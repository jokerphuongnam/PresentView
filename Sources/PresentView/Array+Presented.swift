import SwiftUI

@available(macOS 10.15, *)
private func performWithAnimation(_ animation: Animation? = .default, _ body: () -> Void) {
    withAnimation(animation) { body() }
}

extension Array {
    @available(macOS 10.15, *)
    public mutating func sheet<Item>(
        item: Item,
        animation: Animation? = .default,
        onDismiss: (() -> Void)? = nil
    ) where Self.Element == Presented<Item> {
        performWithAnimation(animation) {
            append(
                .sheet(
                    item: item,
                    onDismiss: onDismiss
                )
            )
        }
    }

    @available(macOS 10.15, *)
    public mutating func fullScreenCover<Item>(
        item: Item,
        animation: Animation? = .default,
        onDismiss: (() -> Void)? = nil
    ) where Self.Element == Presented<Item> {
        performWithAnimation(animation) {
            append(
                .fullScreenCover(
                    item: item,
                    onDismiss: onDismiss
                )
            )
        }
    }

    @available(macOS 10.15, *)
    public mutating func popover<Item>(
        item: Item,
        attachmentAnchor: PopoverAttachmentAnchor = .rect(.bounds),
        arrowEdge: Edge? = nil,
        animation: Animation? = .default,
        onDismiss: (() -> Void)? = nil
    ) where Self.Element == Presented<Item> {
        performWithAnimation(animation) {
            append(
                .popover(
                    item: item,
                    attachmentAnchor: attachmentAnchor,
                    arrowEdge: arrowEdge,
                    onDismiss: onDismiss
                )
            )
        }
    }

    @available(macOS 10.15, *)
    public mutating func overlay<Item>(
        item: Item,
        canCloseWhenTapBackground: Bool = true,
        blurRadius: CGFloat = 5,
        animation: Animation? = .default,
        onDismiss: (() -> Void)? = nil
    ) where Self.Element == Presented<Item> {
        performWithAnimation(animation) {
            append(
                .overlay(
                    item: item,
                    canCloseWhenTapBackground: canCloseWhenTapBackground,
                    blurRadius: blurRadius,
                    background: AnyView(Color.black.opacity(0.3)),
                    onDismiss: onDismiss
                )
            )
        }
    }

    @available(macOS 10.15, *)
    public mutating func overlay<Item, Background>(
        item: Item,
        canCloseWhenTapBackground: Bool = true,
        blurRadius: CGFloat = 5,
        animation: Animation? = .default,
        @ViewBuilder background: () -> Background,
        onDismiss: (() -> Void)? = nil
    ) where Self.Element == Presented<Item>, Background: View {
        performWithAnimation(animation) {
            append(
                .overlay(
                    item: item,
                    canCloseWhenTapBackground: canCloseWhenTapBackground,
                    blurRadius: blurRadius,
                    background: AnyView(background()),
                    onDismiss: onDismiss
                )
            )
        }
    }

    @available(macOS 10.15, *)
    public mutating func context<Item>(
        item: Item,
        parentFrame: CGRect,
        canCloseWhenTapBackground: Bool = true,
        blurRadius: CGFloat = 0,
        animation: Animation? = .default,
        onDismiss: (() -> Void)? = nil
    ) where Self.Element == Presented<Item> {
        performWithAnimation(animation) {
            append(
                .context(
                    item: item,
                    parentFrame: parentFrame,
                    canCloseWhenTapBackground: canCloseWhenTapBackground,
                    blurRadius: blurRadius,
                    background: AnyView(Color.white.opacity(0.001)),
                    onDismiss: onDismiss
                )
            )
        }
    }

    @available(macOS 10.15, *)
    public mutating func context<Item, Background>(
        item: Item,
        parentFrame: CGRect,
        canCloseWhenTapBackground: Bool = true,
        blurRadius: CGFloat = 0,
        animation: Animation? = .default,
        @ViewBuilder background: () -> Background,
        onDismiss: (() -> Void)? = nil
    ) where Self.Element == Presented<Item>, Background: View {
        performWithAnimation(animation) {
            append(
                .context(
                    item: item,
                    parentFrame: parentFrame,
                    canCloseWhenTapBackground: canCloseWhenTapBackground,
                    blurRadius: blurRadius,
                    background: AnyView(background()),
                    onDismiss: onDismiss
                )
            )
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
