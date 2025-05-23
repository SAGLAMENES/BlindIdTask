//
//  KeyChainService.swift
//  MovieAPI
//
//  Created by Enes Saglam on 22.05.2025.
//

import Foundation
import Security

public enum KeychainService {
    public static func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    public static func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == noErr,
           let data = dataTypeRef as? Data,
           let result = String(data: data, encoding: .utf8) {
            return result
        }
        return nil
    }

    public static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
