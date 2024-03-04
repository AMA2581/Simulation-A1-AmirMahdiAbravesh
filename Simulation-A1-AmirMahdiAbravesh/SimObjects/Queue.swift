//
//  Queue.swift
//  Stack and Queue
//
//  Created by Amir Mahdi Abravesh on 11/19/23.
//

import Foundation

struct Queue {
    private var elements: [Customer] = []

    mutating func enqueue(_ value: Customer) {
        elements.append(value)
    }

    mutating func dequeue() -> Customer? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }

    var head: Customer? {
        return elements.first
    }

    var tail: Customer? {
        return elements.last
    }
    
    var count: Int {
        return elements.count
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var printState: String {
        var buffer: [String] = []
        for element in elements {
            buffer.append(element.toString())
        }
        return "<-\(buffer)<-"
    }
}
