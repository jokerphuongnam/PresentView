import SwiftUI

public protocol DismissPresentedAction {
    func callAsFunction()
}

public struct DismissPresentedActionImpl<Item>: DismissPresentedAction {
    @Binding private var presented: [Presented<Item>]
    
    init(_ presented: Binding<[Presented<Item>]>) {
        self._presented = presented
    }
    
    public func callAsFunction() {
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
