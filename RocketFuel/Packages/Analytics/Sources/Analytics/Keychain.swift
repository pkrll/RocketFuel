//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Security

struct Keychain {
    
    enum Error: Swift.Error {
        case failedToRead(status: Int32)
        case failedToWrite(status: Int32)
        case foundNoRecords
    }
    
    @discardableResult
    static func set(_ value: Data) throws -> Data? {
        let service = Bundle.main.bundleIdentifier ?? ""
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
        ] as [String: Any]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw Error.failedToWrite(status: status)
        }
        
        return value
    }
    
    static func get() throws -> Data {
        let service = Bundle.main.bundleIdentifier ?? ""
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecReturnData: true
        ] as [String: Any]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(attributes as CFDictionary, &result)
        guard status == errSecSuccess else {
            throw Error.failedToRead(status: status)
        }
        
        guard let data = result as? Data else {
            throw Error.foundNoRecords
        }
        
        return data
    }
}
