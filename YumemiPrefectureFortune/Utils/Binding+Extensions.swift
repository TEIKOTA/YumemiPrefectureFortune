import SwiftUI


extension Binding {
    /// Optionalな値のBindingを、非Optionalな値のBindingに変換する。
    ///
    /// - Parameter defaultValue: wrappedValueがnilの場合に使用されるデフォルト値。
    /// - Returns: 非Optionalな値を持つ新しいBinding。
    func nonOptional<T>(defaultValue: T) -> Binding<T> where Value == T? {
        return Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
