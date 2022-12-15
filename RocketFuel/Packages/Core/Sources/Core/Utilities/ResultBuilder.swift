//
//  Copyright © 2022 Ardalan Samimi. All rights reserved.
//

import Foundation

@resultBuilder
public struct ResultBuilder<T> {
    public static func buildBlock(_ components: T) -> [T] {
        [components]
    }

    public static func buildBlock(_ components: T...) -> [T] {
        components
    }
    
    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
    }

    public static func buildBlock(_ components: [T]) -> [T] {
        components
    }
    
    public static func buildEither(first component: [T]) -> [T] {
        component
    }
    
    public static func buildEither(second component: [T]) -> [T] {
        component
    }

    public static func buildExpression(_ expression: ()) -> [T] {
        []
    }
    
    public static func buildExpression(_ expression: T) -> [T] {
        [expression]
    }
    
    public static func buildOptional(_ component: [T]?) -> [T] {
        component ?? []
    }
    
    public static func buildBlock(_ components: [T?]) -> [T] {
        components.compactMap { $0 }
    }
    
    public static func buildExpression(_ expression: T?) -> [T] {
        guard let expression = expression else {
            return []
        }
        
        return [expression]
    }
    
    public static func buildExpression(_ expression: [T]?) -> [T] {
        expression ?? []
    }
}
