//
//  PlantModel .swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 25.09.2022.
//

import Foundation
import UIKit
import Firebase

class PlantModel{
    let id:String
    var image:URL
    var title:String
    var notes:String
    let date: Date
    var favorite = false
    static let collection = Database.database().reference().child("plants")
    
//    init(id:String, image: UIImage, title: String , notes:String){
//        self.id = id
//        self.image = image
//        self.title = title
//        self.notes = notes
//
//    }
    
    init?(key:String, value:[String:Any]){
        guard let timeInterval = value["createdAt"] as? Double else{
            return nil
        }
        guard let notes = value["notes"] as? String else{
               return nil
            }
        guard let title = value["title"] as? String else{
               return nil
            }
        guard let image = value["image"] as? String else{
            return nil
        }
        guard let imageURL = URL(string: image) else{
            return nil
        }
        if let _ = value["isFavorite"] as? Bool{
            self.favorite = true
        }
        self.date = Date(timeIntervalSince1970: timeInterval)
        self.id = key
        self.notes = notes
        self.title = title
        self.image = imageURL
       }
    
    
    init?(snapshot: DataSnapshot){
        
        guard let value = snapshot.value as? [String:Any] else{
            return nil
        }
        guard let timeInterval = value["createdAt"] as? Double else{
            return nil
        }
        guard let notes = value["notes"] as? String else{
               return nil
            }
        guard let title = value["title"] as? String else{
               return nil 
            }
        guard let image = value["image"] as? String else{
            return nil
        }
        guard let imageURL = URL(string: image) else{
            return nil
        }
        if let _ = value["isFavorite"] as? Bool{
            self.favorite = true
        }
        self.date = Date(timeIntervalSince1970: timeInterval)
        self.id = snapshot.key
        self.notes = notes
        self.title = title
        self.image = imageURL
       }
    
    func toggleFavorite(){
        favorite = !favorite
    }
}
