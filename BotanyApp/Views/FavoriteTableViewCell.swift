//
//  FavoriteTableViewCell.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 21.09.2022.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var favoritesOutlet: UIButton!
    @IBOutlet weak var PlantLabel: UILabel!
    @IBOutlet weak var PlantImageView: UIImageView!
    weak var delegate: favoritesDelegate?
    var plant: PlantModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func favoritesButtonTapped(_ sender: Any) {
        guard let plant = plant else {
            return
        }
        plant.favorite = false
        for (index,selectedPlant) in DataModel.shared.selectedPlants.enumerated(){
            if selectedPlant.id == plant.id{
                DataModel.shared.selectedPlants.remove(at: index)
            }
        }
        delegate?.reloadData()
    }
}

