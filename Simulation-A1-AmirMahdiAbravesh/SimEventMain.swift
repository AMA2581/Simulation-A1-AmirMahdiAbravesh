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
    var n: Int

    init() {
        initRoutine = InitRoutine()
        hubble = initRoutine.initializeRoutine()
        hubble.isHubble = true
        baker = initRoutine.initializeRoutine()
        clock = initRoutine.initializeClock()
        n = 1
        for _ in 1 ... 1000 {
            customers.generateCustomer()
        }
        
        customers.allCustomers = customers.A.count

        while true {
//            print("step \(n)")
//            clock.printState()
            timingRoutine()
//            printState()
//            print(customers.A.first)
            updateClock()
            n += 1
        }
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
    }

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
    
    func updateServersClockA(){
        if !customers.isNextCustomerNil {
            hubble.clockA = customers.A.first!
            baker.clockA = customers.A.first!
        } else {
            hubble.clockA = 0
            baker.clockA = 0
        }
    }
    
    func utilizationPrint() {
        var hubbleUtil: Double = (Double(hubble.statCount.utilization) / Double(clock.clock)) * 100
        var bakerUtil: Double = (Double(baker.statCount.utilization) / Double(clock.clock)) * 100
        
        hubbleUtil = Double(round(100 * hubbleUtil) / 100)
        bakerUtil = Double(round(100 * bakerUtil) / 100)
        
        let wholeUtil = Double(round(100 * ((hubbleUtil + bakerUtil) / 2)) / 100)
        
        print("hubble utilization: \(hubbleUtil)%")
        print("baker utilization: \(bakerUtil)%")
        print("whole utilization: \(wholeUtil)%")
    }
    
    func bakerProbPrint() {
        let bakerProb = Double(round(100 * ((Double(baker.customerServerUtil) / Double(customers.allCustomers) * 100))) / 100)
        print("baker probablity: \(bakerProb)%")
    }
    
    func customerUtilPrint() {
        let hubbleCustomerUtil = Double(round(100 * ((Double(hubble.customerServerUtil) / Double(customers.allCustomers) * 100))) / 100)
        let bakerCustomerUtil = Double(round(100 * ((Double(baker.customerServerUtil) / Double(customers.allCustomers) * 100))) / 100)
        
        print("hubble customer rate: \(hubbleCustomerUtil)%")
        print("baker customer rate: \(bakerCustomerUtil)%")
    }

    func endOfSimulation() {
//        print("Hubble:")
//        hubble.endPrintState()
//        print("Baker:")
//        baker.endPrintState()
        print("----------------Q2-----------------")
        utilizationPrint()
        print("----------------Q4-----------------")
        bakerProbPrint()
        print("----------------Q5-----------------")
        customerUtilPrint()
        print("-----------------------------------")
        print("end of simulation")
        exit(0)
    }
}
