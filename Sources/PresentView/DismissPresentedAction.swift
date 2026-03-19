import SwiftUI

public protocol DismissPresentedAction {
    var canDismiss: Bool { get }
    func callAsFunction()
}

@available(macOS 10.15, *)
struct DismissPresentedActionImpl<Item>: DismissPresentedAction {
    @Binding private var presented: [Presented<Item>]
    
    public var canDismiss: Bool {
        presented.isEmpty == false
    }
    
    init(_ presented: Binding<[Presented<Item>]>) {
        self._presented = presented
    }
    
    func callAsFunction() {
        presented.pop()
    }
}

@available(macOS 10.15, *)
extension EnvironmentValues {
    internal(set) public var dismissPresented: DismissPresentedAction {
        get {
            self[DismissPresentedKey.self]
        }
        set {
            self[DismissPresentedKey.self] = newValue
        }
    }
}

struct DismissPresentedKey: EnvironmentKey {
    @available(macOS 10.15, *)
    static var defaultValue: DismissPresentedAction {
        DismissPresentedActionImpl<Any>(.constant([]))
    }
}

#if os(iOS)
extension EnvironmentValues {
    var keyboardHeight: CGFloat {
        get { self[KeyboardHeightKey.self] }
        set { self[KeyboardHeightKey.self] = newValue }
    }
}

struct KeyboardHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}
#endif
