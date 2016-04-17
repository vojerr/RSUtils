//
//  DataTaskPerformer.swift
//  RSUtils
//
//  Created by Ruslan Samsonov on 4/17/16.
//  Copyright © 2016 Ruslan Samsonov. All rights reserved.
//

import UIKit
import Foundation

/// Used for background data processing using gcd, all methods must be called from main thread
/// Cancels pending tasks, if newer are available.
public class DataTaskPerformer: NSObject {
    static var queueIndex = 0
    private let taskQueue: dispatch_queue_t
    private var tasksBatches: [dispatch_block_t] = [];
    
    required public convenience override init() {
        self.init(taskQueue: dispatch_queue_create("GKDataTaskPerformer-\(DataTaskPerformer.queueIndex)", DISPATCH_QUEUE_SERIAL))
    }
    
    private init(taskQueue: dispatch_queue_t) {
        self.taskQueue = taskQueue
        super.init()
    }
    
    /**
     Performs block task in background, calls completion in main thread.
     This method must be called from main thread.
     - Parameter block: Task block.
     - Parameter completion: Completion block.
     */
    public func performTask(block: () -> Void, completion: () -> Void) throws {
        try performBatchTasks([block], completion: completion)
    }
    
    /**
     Performs batch of tasks concurrently in background, calls completion in main thread.
     This method must be called from main thread.
     - Parameter blocks: Array of task block.
     - Parameter completion: Completion block.
     */
    public func performBatchTasks(blocks: [() -> Void], completion: () -> Void) throws {
        try checkMainThread()
        cancelQueuedTaskExceptCurrent()
        let tasksCompletion = {
            dispatch_sync(dispatch_get_main_queue(), {
                completion()
                _ = self.tasksBatches.removeAtIndex(0)
            })
        }
        let tasksBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, {
            dispatch_apply(blocks.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { iteration -> Void in
                blocks[iteration]()
            })
            tasksCompletion()
        })
        dispatch_async(taskQueue, tasksBlock)
        tasksBatches.append(tasksBlock)
    }
    
    private func cancelQueuedTaskExceptCurrent() {
        if tasksBatches.count > 1 {
            for index in 1..<tasksBatches.count {
                let taskBlock = tasksBatches[index]
                dispatch_block_cancel(taskBlock)
            }
        }
        if let current = tasksBatches.first {
            tasksBatches.removeAll()
            tasksBatches.append(current)
        }
    }
    
    private func checkMainThread() throws {
        guard NSThread.isMainThread() else {
            throw DataTaskPerformerError.NotMainThread
        }
    }

    enum DataTaskPerformerError: ErrorType {
        case NotMainThread
    }
}
