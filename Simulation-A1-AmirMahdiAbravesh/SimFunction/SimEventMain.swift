//
//  SimEventMain.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/27/24.
//

import Foundation

class SimEventMain {
    var customers = Customers()
    var initRoutine: InitRoutine
    var hubble: SimServer
    var baker: SimServer
    var clock: SimClock
    var totalWaitTime: Int
    var totalServiceTime: Int
    var totalPeopleInQueuePerClock: [Int]
    var trafficCount: Int
    var syncServices: [Int]
    var n: Int
    var initCustomerCount: Int
    var isSection2: Bool
    var isSimulationStarted: Bool

    init() {
        initRoutine = InitRoutine()
        hubble = initRoutine.initializeRoutine()
        hubble.isHubble = true
        baker = initRoutine.initializeRoutine()
        clock = initRoutine.initializeClock()
        totalWaitTime = 0
        totalServiceTime = 0
        totalPeopleInQueuePerClock = [0, 0]
        trafficCount = 0
        syncServices = [0, 0]
        n = 1
        // change isSection2 in order to get results for second part
        initCustomerCount = 1000
        isSection2 = false
        isSimulationStarted = false
    }

    func startSimulation() {
        isSimulationStarted = true

        for _ in 1 ... initCustomerCount {
            customers.generateCustomer()
        }

        customers.allCustomers = customers.A.count
        totalWaitTime = calcTotalWaitTime()
        print(isSection2)

        while true {
//            print("step \(n)")
//            clock.printState()
            timingRoutine()
//            printState()
//            print(customers.A.first)
            if isSimulationStarted {
                updateClock()
            } else {
                break
            }
            n += 1
        }
    }

    func resetSimulation() {
        initRoutine = InitRoutine()
        hubble = initRoutine.initializeRoutine()
        hubble.isHubble = true
        baker = initRoutine.initializeRoutine()
        clock = initRoutine.initializeClock()
        totalWaitTime = 0
        totalServiceTime = 0
        totalPeopleInQueuePerClock = [0, 0]
        trafficCount = 0
        syncServices = [0, 0]
        n = 1
    }

    func printState() {
        print("Hubble:")
        hubble.printState()
        print("-----------------------------------")
        print("Baker:")
        baker.printState()
        print("===================================")
//        print("Customers:")
//        customers.printState()
    }

    // MARK: Timing Routine

    func timingRoutine() {
//        hubble.systemState.isServerOccupied = true
//        baker.systemState.isServerOccupied = true
//        hubble.clockB = 2

        if clock.clock == hubble.clockB {
            hubble.removeCustomer()
            if !hubble.systemState.customersQueue.isEmpty {
                hubble.addCustomerFromQueue(clock: clock.clock)
            }
        }

        if clock.clock == baker.clockB {
            baker.removeCustomer()
            if !baker.systemState.customersQueue.isEmpty {
                baker.addCustomerFromQueue(clock: clock.clock)
            }
        }

        if !isSection2 {
            if customers.A.isEmpty && customers.S.isEmpty {
                endOfSimulation()
            } else {
                if clock.clock == customers.A.first! {
                    if baker.systemState.isServerOccupied && !hubble.systemState.isServerOccupied {
                        addCustomer(isHubble: true, isOccupied: false)

                    } else if hubble.systemState.isServerOccupied && !baker.systemState.isServerOccupied {
                        addCustomer(isHubble: false, isOccupied: false)

                    } else if !hubble.systemState.isServerOccupied && !baker.systemState.isServerOccupied {
                        addCustomer(isHubble: true, isOccupied: false)

                    } else if hubble.systemState.isServerOccupied && baker.systemState.isServerOccupied {
                        if hubble.clockB <= baker.clockB {
                            addCustomer(isHubble: true, isOccupied: true)
                        } else if hubble.clockB > baker.clockB {
                            addCustomer(isHubble: false, isOccupied: true)
                        }
                    }
                }
            }
        } else {
            if customers.A.isEmpty && customers.S.isEmpty {
                endOfSimulation()
            } else {
                if clock.clock == customers.A.first! {
                    let randomNumber = Int.random(in: 0 ... 100)
//                    print(randomNumber)
                    switch randomNumber {
                    case 0 ... 30:
                        addCustomer(isHubble: false, isOccupied: baker.systemState.isServerOccupied)
                    case 31 ... 100:
                        addCustomer(isHubble: true, isOccupied: hubble.systemState.isServerOccupied)
                    default:
                        fatalError("random number is invalid!")
                    }
                }
            }
        }

        hubble.setBt(clock: clock.clock)
        baker.setBt(clock: clock.clock)
        hubble.setQt(clock: clock.clock)
        baker.setQt(clock: clock.clock)
        hubble.setQueueCount(clock: clock.clock, count: customers.A.count)
        baker.setQueueCount(clock: clock.clock, count: customers.A.count)
        updateServersClockA()

        if hubble.systemState.isServerOccupied && baker.systemState.isServerOccupied {
            hubble.utilUpdate()
            baker.utilUpdate()
        } else if hubble.systemState.isServerOccupied && !baker.systemState.isServerOccupied {
            hubble.utilUpdate()
        } else if !hubble.systemState.isServerOccupied && baker.systemState.isServerOccupied {
            baker.utilUpdate()
        }

        calcTotalServiceTime()
        totalPeopleInQueuePerClock[0] += customers.A.count
        totalPeopleInQueuePerClock[1] += 1

        if hubble.systemState.customersQueue.count >= 5 || baker.systemState.customersQueue.count >= 5 {
            trafficCount += 1
        }

        if hubble.systemState.isServerOccupied && baker.systemState.isServerOccupied {
            syncServicesCheck()
            syncServices[1] += 1
        }
    }

    // MARK: Clock Logic

    func updateClock() {
        if hubble.systemState.isServerOccupied {
            // left side of diagram
            if baker.systemState.isServerOccupied {
                if customers.isNextCustomerNil {
                    if baker.clockB <= hubble.clockB {
                        setClock(baker.clockB)
                    } else {
                        setClock(hubble.clockB)
                    }
                } else {
                    if hubble.clockB <= customers.A.first! {
                        if baker.clockB <= hubble.clockB {
                            setClock(baker.clockB)
                        } else {
                            setClock(hubble.clockB)
                        }
                    } else {
                        if baker.clockB <= customers.A.first! {
                            setClock(customers.A.first!)
                        } else {
                            setClock(baker.clockB)
                        }
                    }
                }
            } else {
                if customers.isNextCustomerNil {
                    setClock(hubble.clockB)
                } else {
                    if hubble.clockB <= customers.A.first! {
                        setClock(hubble.clockB)
                    } else {
                        setClock(customers.A.first!)
                    }
                }
            }
        } else {
            // right side of the diagram
            if baker.systemState.isServerOccupied {
                if customers.isNextCustomerNil {
                    setClock(baker.clockB)
                } else {
                    if baker.clockB <= customers.A.first! {
                        setClock(baker.clockB)
                    } else {
                        setClock(customers.A.first!)
                    }
                }
            } else {
                if customers.isNextCustomerNil {
                    endOfSimulation()
                } else {
                    setClock(customers.A.first!)
                }
            }
        }
    }

    private func setClock(_ clock: Int) {
        self.clock.clock = clock
    }

    func addCustomer(isHubble: Bool, isOccupied: Bool) {
        let bufferA = customers.A.removeFirst()
        let bufferS = customers.S.removeFirst()
        if isOccupied {
            if isHubble {
                hubble.addCustomerToQueue(A: bufferA,
                                          S: bufferS,
                                          clock: clock.clock)
            } else {
                baker.addCustomerToQueue(A: bufferA,
                                         S: bufferS,
                                         clock: clock.clock)
            }
        } else {
            if isHubble {
                hubble.updateCustomer(A: bufferA,
                                      S: bufferS,
                                      clock: clock.clock)
            } else {
                baker.updateCustomer(A: bufferA,
                                     S: bufferS,
                                     clock: clock.clock)
            }
        }
    }

    func updateServersClockA() {
        if !customers.isNextCustomerNil {
            hubble.clockA = customers.A.first!
            baker.clockA = customers.A.first!
        } else {
            hubble.clockA = 0
            baker.clockA = 0
        }
    }

    func syncServicesCheck() {
        if baker.clockB < hubble.clockB {
            syncServices[0] += 1
        }
    }

    // MARK: Print Functions

    // Q2
    func utilizationPrint() {
        var hubbleUtil: Double = (Double(hubble.statCount.utilization) / Double(clock.clock)) * 100
        var bakerUtil: Double = (Double(baker.statCount.utilization) / Double(clock.clock)) * 100

        hubbleUtil = Double(round(100 * hubbleUtil) / 100)
        bakerUtil = Double(round(100 * bakerUtil) / 100)

        let totalUtil = Double(round(100 * ((hubbleUtil + bakerUtil) / 2)) / 100)

        print("hubble utilization: \(hubbleUtil)%")
        print("baker utilization: \(bakerUtil)%")
        print("total utilization: \(totalUtil)%")
    }

    /// Hubble Utilization
    func utilizationPrintH() -> String {
        var hubbleUtil: Double = (Double(hubble.statCount.utilization) / Double(clock.clock)) * 100
        hubbleUtil = Double(round(100 * hubbleUtil) / 100)

        return "\(hubbleUtil)%"
    }

    /// Baker Utilization
    func utilizationPrintB() -> String {
        var bakerUtil: Double = (Double(baker.statCount.utilization) / Double(clock.clock)) * 100
        bakerUtil = Double(round(100 * bakerUtil) / 100)

        return "\(bakerUtil)%"
    }

    /// Total Utilization
    func utilizationPrintTotal() -> String {
        var hubbleUtil: Double = (Double(hubble.statCount.utilization) / Double(clock.clock)) * 100
        var bakerUtil: Double = (Double(baker.statCount.utilization) / Double(clock.clock)) * 100

        hubbleUtil = Double(round(100 * hubbleUtil) / 100)
        bakerUtil = Double(round(100 * bakerUtil) / 100)
        let totalUtil = Double(round(100 * ((hubbleUtil + bakerUtil) / 2)) / 100)

        return "\(totalUtil)%"
    }

    // Q4
    func bakerProbPrint() -> String {
        let bakerProb = Double(round(100 * (Double(baker.customerServerUtil) / Double(customers.allCustomers) * 100)) / 100)
        print("baker probablity: \(bakerProb)%")
        return "\(bakerProb)%"
    }

    // Q5
    func customerUtilPrint() {
        let hubbleCustomerUtil = Double(round(100 * (Double(hubble.customerServerUtil) / Double(customers.allCustomers) * 100)) / 100)
        let bakerCustomerUtil = Double(round(100 * (Double(baker.customerServerUtil) / Double(customers.allCustomers) * 100)) / 100)

        print("hubble customer rate: \(hubbleCustomerUtil)%")
        print("baker customer rate: \(bakerCustomerUtil)%")
    }

    /// Hubble utilization print
    func customerUtilPrintH() -> String {
        let hubbleCustomerUtil = Double(round(100 * (Double(hubble.customerServerUtil) / Double(customers.allCustomers) * 100)) / 100)
        return "\(hubbleCustomerUtil)%"
    }

    /// Baker utilization print
    func customerUtilPrintB() -> String {
        let bakerCustomerUtil = Double(round(100 * (Double(baker.customerServerUtil) / Double(customers.allCustomers) * 100)) / 100)
        return "\(bakerCustomerUtil)%"
    }

    // Q1
    func calcTotalWaitTime() -> Int {
        var output = 0
        if !customers.isNextCustomerNil {
            for customer in customers.A {
                output += customer
            }
        }
        return output
    }

    func calcTotalServiceTime() {
        if hubble.systemState.isServerOccupied && baker.systemState.isServerOccupied {
            totalServiceTime += (hubble.currentCustomer.S + baker.currentCustomer.S)
        } else if hubble.systemState.isServerOccupied && !baker.systemState.isServerOccupied {
            totalServiceTime += hubble.currentCustomer.S
        } else if !hubble.systemState.isServerOccupied && baker.systemState.isServerOccupied {
            totalServiceTime += baker.currentCustomer.S
        }
    }

    func averageWaitTimePrint() -> String {
        print("average wait time: \(totalWaitTime / customers.allCustomers)")
        return "\(totalWaitTime / customers.allCustomers)"
    }

    func averageServiceTimePrint() -> String {
        print("average service time: \(totalServiceTime / customers.allCustomers)")
        return "\(totalServiceTime / customers.allCustomers)"
    }

    // Q3
    func averagePeopleInQueuePerClockPrint() -> String {
        print("average people in queue: \(totalPeopleInQueuePerClock[0] / totalPeopleInQueuePerClock[1])")
        return "\(totalPeopleInQueuePerClock[0] / totalPeopleInQueuePerClock[1])"
    }

    // Q9
    func salaryPrint() {
        let hubbleSalary = Double(round(((Double(hubble.customerServed) / Double(customers.allCustomers)) * 100) * 100) / 100)
        let bakerSalary = Double(round(((Double(baker.customerServed) / Double(customers.allCustomers)) * 100) * 100) / 100)

        print("hubble salary: \(hubbleSalary)%")
        print("baker salary: \(bakerSalary)%")
    }

    /// Hubble Salary Print
    func salaryPrintH() -> String {
        let hubbleSalary = Double(round(((Double(hubble.customerServed) / Double(customers.allCustomers)) * 100) * 100) / 100)
        return "\(hubbleSalary)%"
    }

    /// Baker Salary Print
    func salaryPrintB() -> String {
        let bakerSalary = Double(round(((Double(baker.customerServed) / Double(customers.allCustomers)) * 100) * 100) / 100)
        return "\(bakerSalary)%"
    }

    // Q10
    func trafficCountPrint() -> String {
        print("number of traffics: \(trafficCount)")
        return "\(trafficCount)"
    }

    // Q11
    func syncServicesPrint() -> String {
        let output = Double(round(((Double(syncServices[0]) / Double(syncServices[1])) * 100) * 100) / 100)
        print("baker finishing first: \(output)%")
        return "\(output)"
    }

    func endOfSimulation() {
//        print("Hubble:")
//        hubble.endPrintState()
//        print("Baker:")
//        baker.endPrintState()

//        print("----------------Q1-----------------")
//        averageWaitTimePrint(totalWaitTime: totalWaitTime)
//        averageServiceTimePrint(totalServiceTime: totalServiceTime)
//        print("----------------Q2-----------------")
//        utilizationPrint()
//        print("----------------Q3-----------------")
//        averagePeopleInQueuePerClockPrint()
//        print("----------------Q4-----------------")
//        bakerProbPrint()
//        print("----------------Q5-----------------")
//        customerUtilPrint()
//        print("----------------Q9-----------------")
//        salaryPrint()
//        print("----------------Q10----------------")
//        trafficCountPrint()
//        print("----------------Q11----------------")
//        syncServicesPrint()
//        print("-----------------------------------")
//        print("end of simulation")
//        exit(0)

        isSimulationStarted = false
    }
}
