//
//  AppStore.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Foundation

struct AppStore {
    
    @Storage(key: "auto_join_key", defaultValue: true)
    static var autoJoin: Bool
    
    @Storage(key: "auto_login_key", defaultValue: true)
    static var autoLogin: Bool
}

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    private let standard = UserDefaults.standard
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = standard.object(forKey: key) as? Data,
               let value = try? JSONDecoder().decode(T.self, from: data) else {
                return defaultValue
            }
            return value
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                standard.set(encoded, forKey: key)
            }
        }
    }
}
