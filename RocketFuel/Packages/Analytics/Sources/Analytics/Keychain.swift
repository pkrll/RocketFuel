//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation
import Security

struct Keychain {
    
    enum Error: Swift.Error {
        case failedToDelete(status: Int32)
        case failedToRead(status: Int32)
        case failedToWrite(status: Int32)
        case foundNoRecords
    }
    
    private static var attributes: [CFString: Any] {
        let service = Bundle.main.bundleIdentifier ?? ""
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
        ] as [CFString: Any]
        
        return attributes
    }
    
    @discardableResult
    static func set(_ value: Data) throws -> Data? {
        var attributes = Self.attributes
        attributes[kSecValueData] = value
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw Error.failedToWrite(status: status)
        }
        
        return value
    }
    
    static func get() throws -> Data {
        var attributes = Self.attributes
        attributes[kSecReturnData] = true
        
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
    
    static func delete() throws {
        var attributes = Self.attributes
        attributes[kSecReturnData] = true
        
        let status = SecItemDelete(attributes as CFDictionary)
        switch status {
        case errSecSuccess, errSecItemNotFound:
            break
        default:
            throw Error.failedToDelete(status: status)
        }
    }
}
