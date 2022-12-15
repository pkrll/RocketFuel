//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

extension HotKey: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case keyCode
        case modifier
        case readable
    }
    
    public var rawValue: String {
        let data: Data?
        
        do {
            data = try JSONEncoder().encode(self)
        } catch {
            data = nil
            print(error)
        }
        
        guard let data,
              let result = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }
        
        return result
    }
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }
        
        do {
            self = try JSONDecoder().decode(HotKey.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        keyCode = try values.decode(Int.self, forKey: .keyCode)
        modifier = try values.decode(Int.self, forKey: .modifier)
        readable = try values.decode(String.self, forKey: .readable)
        action = nil
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(keyCode, forKey: .keyCode)
        try container.encode(modifier, forKey: .modifier)
        try container.encode(readable, forKey: .readable)
    }
}
