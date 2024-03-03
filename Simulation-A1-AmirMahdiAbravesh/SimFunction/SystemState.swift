//
//  SystemState.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/27/24.
//

class SystemState {
    var lastEventClock: Int
    var queueCount: Int
    var isServerOccupied: Bool
    var customersQueue: Queue
    
    init(lastEventClock: Int,
         isServerOccupied: Bool,
         customersQueue: Queue) {
        self.lastEventClock = lastEventClock
        self.isServerOccupied = isServerOccupied
        self.customersQueue = customersQueue
        self.queueCount = customersQueue.count
    }
    
    func printState() {
        print("lastEventClock:\(lastEventClock)")
        print("queueCount:\(queueCount)")
        print("isServerOccupied:\(isServerOccupied)")
        print("customersQueue:\(customersQueue.printState)")
    }
}
