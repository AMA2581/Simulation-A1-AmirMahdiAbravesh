//
//  SimClock.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/27/24.
//

class SimClock {
    var clock: Int
    
    init(clock: Int) {
        self.clock = clock
    }
    
    func setClock(_ clock: Int) {
        self.clock = clock
    }
    
    func printState() -> String {
        print("clock: \(clock)")
        return "\(clock)"
    }
}
