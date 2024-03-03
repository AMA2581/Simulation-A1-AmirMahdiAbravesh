//
//  SimEventMain.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/27/24.
//

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
        for _ in 0 ..< 1000 {
            customers.generateCustomer()
        }

        while true {
            print("step \(n)")
            clock.printState()
            timingRoutine()
            printState()
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
                hubble.addCustomerFromQueue()
            }
        }

        if clock.clock == baker.clockB {
            baker.removeCustomer()
            if !baker.systemState.customersQueue.isEmpty {
                baker.addCustomerFromQueue()
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
    }

    func updateClock() {
        
        if hubble.systemState.isServerOccupied {
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
        
//        if clock.clock != 0 {
//            if hubble.clockB != 0 {
//                if hubble.clockB <= baker.clockB {
//                    if !customers.A.isEmpty {
//                        if customers.A.first! <= hubble.clockB {
//                            clock.clock = customers.A.first!
//                        } else {
//                            clock.clock = hubble.clockB
//                        }
//                    }
//                } else if baker.clockB != 0 {
//                    if !customers.A.isEmpty {
//                        if customers.A.first! <= baker.clockB {
//                            clock.clock = customers.A.first!
//                        } else {
//                            clock.clock = baker.clockB
//                        }
//                    } else {
//                        if hubble.clockB <= customers.A.first! {
//                            clock.clock = hubble.clockB
//                        } else {
//                            clock.clock = customers.A.first!
//                        }
//                    }
//                }
//            }
//        } else {
//            if !customers.A.isEmpty {
//                clock.clock = customers.A.first!
//            }
//        }
    }
    
    private func setClock(_ clock: Int) {
        self.clock.clock = clock
    }

    func addCustomer(isHubble: Bool, isOccupied: Bool) {
        let bufferA = customers.A.removeFirst()
        let bufferS = customers.S.removeFirst()
        if isOccupied {
            if isHubble {
                hubble.addCustomerToQueue(A: bufferA, S: bufferS)
            } else {
                baker.addCustomerToQueue(A: bufferA, S: bufferS)
            }
        } else {
            if isHubble {
                hubble.updateCustomer(A: bufferA,
                                      S: bufferS)
            } else {
                baker.updateCustomer(A: bufferA,
                                     S: bufferS)
            }
        }
    }

    func endOfSimulation() {
        print("Hubble:")
        hubble.endPrintState()
        print("Baker:")
        baker.endPrintState()
        print("end of simulation")
        exit(0)
    }
}
