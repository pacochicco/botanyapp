//
//  PlantModel .swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 25.09.2022.
//

import Foundation
import UIKit

class PlantModel{
    let id = UUID().uuidString
    var image:UIImage
    var title:String
    var notes:String
    let date = Date()
    var favorite = false
    
    init(image: UIImage, title: String , notes:String){
        self.image = image
        self.title = title
        self.notes = notes
        
    }
    
    func toggleFavorite(){
        favorite = !favorite
    }
}
