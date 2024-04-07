//
//  Customer.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 2/28/24.
//

class Customer {
    var A: Int
    var S: Int
    
    init() {
        self.A = 0
        self.S = 0
    }
    
    init(A: Int, S: Int){
        self.A = A
        self.S = S
    }
    
    func updateCustomer(A: Int, S: Int) {
        self.A = A
        self.S = S
    }
    
    func printState() {
        print("A:\(A)")
        print("S:\(S)")
    }
    
    func printA() -> String {
        return "\(A)"
    }
    
    func printS() -> String {
        return "\(S)"
    }
    
    func toString() -> String {
        return "\(A)|\(S)"
    }
}
