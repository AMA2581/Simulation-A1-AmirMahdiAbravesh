//
//  InitRoutine.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/27/24.
//

struct InitRoutine {
    var clockA = 0
    var clockB = 0
    var simClock = SimClock(clock: 0)
    var statCount = StatCount(QtArea: [:],
                              BtArea: [:],
                              queueCount: [:])
    var systemState = SystemState(lastEventClock: 0,
                                  isServerOccupied: false,
                                  customersQueue: Queue())
    func initializeClock() -> SimClock {
        return simClock
    }
    func initializeRoutine() -> SimServer {
//        return SimServer(clockA: self.clockA,
//                         clockB: self.clockB,
//                         statCount: self.statCount,
//                         systemState: self.systemState)
        return SimServer()
    }
}
