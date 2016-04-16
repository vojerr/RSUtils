//
//  WeakObjectsArray.swift
//  RSUtils
//
//  Created by Ruslan Samsonov on 4/16/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

import UIKit

/// WeakObjectsArray is an array, which doesn't retain its elements, so doesn't affect to elements memory management.
public class WeakObjectsArray<T: AnyObject> {
    private var innerArray: [WeakObjectContainer<T>];
    
    required public init() {
        innerArray = []
    }

    /**
     Adds object to collection.
     - Parameter object: Object to be added.
    */
    public func add(object: T) {
        innerArray.append(WeakObjectContainer(object: object))
    }
    
    /**
     Removes object from collection.
     - Parameter object: Object to be removed.
     */
    public func remove(object: T) {
        if let index = find(object) {
            innerArray.removeAtIndex(index)
        }
    }
    
    /**
     Clean array from nil values.
     */
    public func compact() {
        innerArray = innerArray.filter {
            return $0.object != nil
        };
    }
    
    /**
     Enumerates not nil elements.
     */
    public func forEach(@noescape body: (T) -> Void) {
        innerArray.forEach({
            if let object = $0.object {
                 body(object)
            }
        })
    }
    
    /**
     Raw count of all elements including nils.
     */
    public func rawCount() -> Int {
        return innerArray.count
    }
    
    /**
     Count of non-nil elements.
     */
    public func count() -> Int {
        var count: Int = 0
        innerArray.forEach({
            if $0.object != nil {
                count += 1
            }
        })
        return count
    }
    
    private func find(object: T) -> Int? {
        for (index, element) in innerArray.enumerate() {
            if (element === object) {
                return index
            }
        }
        return nil
    }
}
