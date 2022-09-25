//
//  OurData.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 16.09.2022.
//

import Foundation

class DataModel {
    
    static let shared = DataModel()
    var plants = [PlantModel]()
    var selectedPlants = [PlantModel]()
    
    private init(){
        
    }
    
    
}
