//
//  SimQueue.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/26/24.
//

class SimServer {
    var clockA: Int
    var clockB: Int
//    var isServerOccupied: Bool
    var statCount: StatCount
    var systemState: SystemState
    var isHubble: Bool = false
    var currentCustomer: Customer = Customer()
    var customerServerUtil = 0
    var customerServed = 0

    init() {
        clockA = 0
        clockB = 0
        statCount = StatCount(QtArea: [:],
                              BtArea: [:],
                              queueCount: [:],
                              utilization: 0)
        systemState = SystemState(lastEventClock: 0,
                                  isServerOccupied: false,
                                  customersQueue: Queue())
    }

    init(clockA: Int, clockB: Int, statCount: StatCount, systemState: SystemState) {
        self.clockA = clockA
        self.clockB = clockB
//        self.isServerOccupied = isServerOccupied
        self.statCount = statCount
        self.systemState = systemState
    }

    func addCustomerFromQueue(clock: Int) {
        let bufferC = systemState.customersQueue.dequeue()!
        currentCustomer.updateCustomer(A: bufferC.A, S: bufferC.S)
        clockB = bufferC.A + bufferC.S
        systemState.isServerOccupied = true
        systemState.lastEventClock = clock
        customerServerUtil += 1
    }

    func addCustomerToQueue(A: Int, S: Int, clock: Int) {
        var bufferS = S
        bufferS = BSPreprocessing(bufferS)
        systemState.customersQueue.enqueue(Customer(A: A, S: bufferS))
        systemState.lastEventClock = clock
    }

    func updateCustomer(A: Int, S: Int, clock: Int) {
        var bufferS = S
        bufferS = BSPreprocessing(bufferS)
        currentCustomer.updateCustomer(A: A, S: bufferS)
        clockB = A + bufferS
        systemState.isServerOccupied = true
        systemState.lastEventClock = clock
        customerServerUtil += 1
    }

    func removeCustomer() {
        clockB = 0
        currentCustomer.A = 0
        currentCustomer.S = 0
        systemState.isServerOccupied = false
        customerServed += 1
    }

    func setBt(clock: Int) {
        statCount.BtArea[clock] = systemState.isServerOccupied
    }

    func setQt(clock: Int) {
        statCount.QtArea[clock] = systemState.customersQueue.count
    }

    func setQueueCount(clock: Int, count: Int) {
        statCount.queueCount[clock] = count
    }

    func utilUpdate() {
        statCount.utilization += 1
    }

    func BSPreprocessing(_ input: Int) -> Int {
        var S = input
        if isHubble {
            switch S {
            case 1 ... 30:
                S = 2
            case 31 ... 58:
                S = 3
            case 59 ... 83:
                S = 4
            case 84 ... 100:
                S = 5
            default:
                S = 0
            }
        } else {
            switch S {
            case 1 ... 35:
                S = 3
            case 36 ... 60:
                S = 4
            case 61 ... 80:
                S = 5
            case 81 ... 100:
                S = 6
            default:
                S = 0
            }
        }
        return S
    }

    func printState() {
        print("A:\(clockA)")
        print("B:\(clockB)")
//        print("isServerOccupied:\(isServerOccupied)")
//        statCount.printState()
        systemState.printState()
        currentCustomer.printState()
    }
    
    /// For printing clock A
    func printCA() -> String {
        return "\(clockA)"
    }
    
    /// For printing clock B
    func printCB() -> String {
        return "\(clockB)"
    }
    
    // TODO: systemState and currentCustomer prints are happening inside their object

    // this is not being called so I commented it:
//    func endPrintState() {
//        statCount.printState()
//    }
}
