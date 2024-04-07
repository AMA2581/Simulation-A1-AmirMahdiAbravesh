//
//  SimSettingsModelView.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import Foundation

class SimSettingsModelView: ObservableObject {
    @Published var isSection2: Bool = false
    @Published var initCustomerCountString: String = ""
    var initCustomerCount: Int = 1000
    var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { _ in
            HB_SimulationApp.simEventMain.isSection2 = self.isSection2
            if (self.initCustomerCountString == "") {
                self.initCustomerCount = 1000
            } else {
                self.initCustomerCount = Int(self.initCustomerCountString)!
            }
            HB_SimulationApp.simEventMain.initCustomerCount = self.initCustomerCount
        }
    }
}
