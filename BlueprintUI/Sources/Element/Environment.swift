import UIKit

@propertyWrapper public struct Environment<Value> {
    private let keyPath: KeyPath<EnvironmentValues, Value>

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }

    public var wrappedValue: Value {
        let values = EnvironmentStack.current.environmentValues
        return values[keyPath: keyPath]
    }
}

public struct EnvironmentValues {
    public var screenScale: CGFloat {
        return self[ScreenScaleKey.self]
    }

    var values: [ObjectIdentifier: Any] = [:]

    public subscript<K>(key: K.Type) -> K.Value where K : EnvironmentKey {
        get {
            if let anyValue = values[ObjectIdentifier(key)] {
                guard let value = anyValue as? K.Value else {
                    fatalError("Expected value of type \(K.Value.self) for key \(K.self), found \(type(of: anyValue))")
                }
                return value
            } else {
                return K.defaultValue
            }
        }
        set {
            values[ObjectIdentifier(key)] = newValue
        }
    }
}

public protocol EnvironmentKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}

public enum ScreenScaleKey: EnvironmentKey {
    public static var defaultValue: CGFloat {
        UIScreen.main.scale
    }
}

struct EnvironmentStack {
    static var current = EnvironmentStack()

    private let bottom = EnvironmentValues()
    private var stack: [EnvironmentValues] = []

    var environmentValues: EnvironmentValues {
        return stack.last ?? bottom
    }

    mutating func push(values: EnvironmentValues) {
        stack.append(values)
    }

    mutating func pop() -> EnvironmentValues? {
        return stack.popLast()
    }
}
