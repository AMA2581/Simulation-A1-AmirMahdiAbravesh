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
        queueCount = customersQueue.count
    }

    func printState() {
        print("lastEventClock:\(lastEventClock)")
        print("queueCount:\(queueCount)")
        print("isServerOccupied:\(isServerOccupied)")
        print("customersQueue:\(customersQueue.printState)")
    }

    /// For printing last event clock
    func printLEC() -> String {
        return "\(lastEventClock)"
    }

    /// For printing queue count
    func printQC() -> String {
        return "\(queueCount)"
    }

    /// For printing is server occupied
    func printIsSO() -> String {
        return "\(isServerOccupied)"
    }

    /// For printing customers queue
    func printCQ() -> String {
        return "\(customersQueue.printState)"
    }
}
