//
//  Customers.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/26/24.
//

class Customers {
    var A: [Int]
    var S: [Int]
    var allCustomers: Int
    
    var isNextCustomerNil: Bool {
        return A.isEmpty
    }

    init() {
        A = []
        S = []
        allCustomers = 0
    }

//    init(A: Int, S: Int) {
//        self.A.append(A)
//        self.S.append(S)
//    }

    func addCustomers(A: Int, S: Int) {
        self.A.append(A)
        self.S.append(S)
    }

    func generateCustomer() {
        var A = Int.random(in: 1 ... 100)
        let S = Int.random(in: 1 ... 100)

        switch A {
        case 1 ... 25:
            A = 1
        case 26 ... 65:
            A = 2
        case 66 ... 85:
            A = 3
        case 86 ... 100: // 86 <= A <= 100
            A = 4
        default:
            A = 0
        }

        if !self.A.isEmpty {
            A += self.A.last!
        }

        addCustomers(A: A, S: S)
    }
    
    func printState() {
        print("A:\(A)")
        print("S:\(S)")
//        print(A.count)
    }
    
    func printStateA() -> String {
        return "\(A)"
    }
    
    func printStateS() -> String {
        return "\(S)"
    }
}
