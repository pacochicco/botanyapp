//
//  PlantViewCell.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 04.09.2022.
//

import UIKit



class PlantViewCell: UICollectionViewCell {
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var plantImageView: UIImageView!
    
    @IBOutlet weak var plantNameLabel: UILabel!
    
    var plant:PlantModel?
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let plant = plant else {
            return
        }

        plant.toggleFavorite()
       // let favoriteImage = plant?.favorite == true ? UIImage(systemName: "heart.filled") : UIImage(systemName: "heart")
        if plant.favorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            DataModel.shared.selectedPlants.append(plant)
        }
        else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            DataModel.shared.selectedPlants.removeAll { plantModel in
                plantModel.id == plant.id 
            }
        }
    }
    
}
