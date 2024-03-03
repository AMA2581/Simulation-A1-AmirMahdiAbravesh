//
//  StatCount.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/27/24.
//
//  Statistical Counter

class StatCount {
    var QtArea: [Int: Int]
    var BtArea: [Int: Bool]
    var queueCount: [Int: Int]

    init(QtArea: [Int: Int], BtArea: [Int: Bool], queueCount: [Int: Int]) {
        self.QtArea = QtArea
        self.BtArea = BtArea
        self.queueCount = queueCount
    }

    func printState() {
        print("QtArea:\(QtArea)")
        print("BtArea:\(BtArea)")
        print("queueCount:\(queueCount)")
    }
}
