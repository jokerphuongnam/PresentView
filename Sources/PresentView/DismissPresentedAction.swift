import SwiftUI

public protocol DismissPresentedAction {
    var canDismiss: Bool { get }
    func callAsFunction()
}

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
    static var defaultValue: DismissPresentedAction {
        DismissPresentedActionImpl<Any>(.constant([]))
    }
}
