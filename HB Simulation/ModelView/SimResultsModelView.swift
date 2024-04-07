//
//  SimResultsModelView.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import Foundation

class SimResultsModelView: ObservableObject {
    @Published var isResultsReady: Bool = false
    @Published var isSimulationStarted: Bool = false
    
    func startSimulation() {
        isSimulationStarted = true
        HB_SimulationApp.simEventMain.startSimulation()
        endOfSimulation()
    }
    
    func resetSimulation() {
        isSimulationStarted = false
        isResultsReady = false
        HB_SimulationApp.simEventMain.resetSimulation()
    }
    
    func endOfSimulation () {
        isSimulationStarted = false
        isResultsReady = true
    }
}
