//
//  AsyncBlockOperation.swift
//  Kubazar
//
//  Created by Oleg Pochtovy on 26.11.17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation

class AsyncBlockOperation: Operation {
    
    private var _isExecuting = false
    private var _isFinished = false
    private(set) var error: Error?
    
    override var isExecuting: Bool {
        
        get {
            
            return _isExecuting
        }
    }
    
    override var isFinished: Bool {
        
        get {
            
            return _isFinished
        }
    }
    
    override var isAsynchronous: Bool {
        
        get {
            
            return true
        }
    }
    
    private var executionBlocks = [((AsyncBlockOperation) -> Void)]()
    
    init(block: @escaping (AsyncBlockOperation) -> Void) {
        
        self.executionBlocks.append(block)
    }
    
    public func addExecutionBlock(block: @escaping (AsyncBlockOperation) -> Void) {
        
        self.executionBlocks.append(block)
    }
    
    override func start() {
        
        self.willChangeValue(forKey: "isExecuting")
        _isExecuting = true
        self.didChangeValue(forKey: "isExecuting")
        
        for executionBlock in self.executionBlocks {
            
            executionBlock(self)
        }
    }
    
    public func finish(error: Error? = nil) {
        
        self.error = error
        
        self.willChangeValue(forKey: "isExecuting")
        _isExecuting = false
        self.didChangeValue(forKey: "isExecuting")
        
        self.willChangeValue(forKey: "isFinished")
        _isFinished = true
        self.didChangeValue(forKey: "isFinished")
    }
}
