//
//  WeakObjectContainer.swift
//  RSUtils
//
//  Created by Ruslan Samsonov on 4/16/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

import UIKit

class WeakObjectContainer<T: AnyObject> {
    private(set) weak var object: T?
    
    required internal init(object: T) {
        self.object = object
    }
}
