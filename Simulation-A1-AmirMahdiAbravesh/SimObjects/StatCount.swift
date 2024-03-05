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
    var utilization: Int

    init(QtArea: [Int: Int], BtArea: [Int: Bool], queueCount: [Int: Int], utilization: Int) {
        self.QtArea = QtArea
        self.BtArea = BtArea
        self.queueCount = queueCount
        self.utilization = utilization
    }

    func printPreprocessing(input: [Int: Any]) {
        var pre = "\(input)"
        var key: [String] = []
        var value: [String] = []
        var buffer = ""
        for char in pre {
            if char == "," || char == "]" {
                if buffer == "true" {
                    buffer = "1"
                } else if buffer == "false" {
                    buffer = "0"
                }
                value.append(buffer)
                buffer = ""
            } else if char == " " {
            } else if char == ":" {
                key.append(buffer)
                buffer = ""
            } else {
                buffer += "\(char)"
            }
        }
        print("key:")
        for t in key {
            print(t)
        }
        print("value:")
        for t in value {
            print(t)
        }
    }

    func printState() {
        print("QtArea:")
        printPreprocessing(input: QtArea)
        print("BtArea:")
        printPreprocessing(input: BtArea)
        print("queueCount:")
        printPreprocessing(input: queueCount)
//        print("QtArea:\(QtArea)")
//        print("BtArea:\(BtArea)")
//        print("queueCount:\(queueCount)")
    }
}
