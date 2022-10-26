//
//  PlantDetailViewController.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 15.09.2022.
//





import UIKit
import SDWebImage
import Firebase

protocol PlantDetailDelegate:AnyObject{
    func updatePlant(plant:PlantModel)
}

class PlantDetailViewController: UIViewController {
    var plant: PlantModel?
    var index: Int?
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let plant = plant{
            plantImageView.sd_setImage(with: plant.image)
            titleLabel.text = plant.title
            notesLabel.text = plant.notes
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModifySegue"{
            let destinationVC = segue.destination as! UpdatePlantViewController
            let plant = sender as! PlantModel
            destinationVC.plantToEdit = plant
            destinationVC.editDelegate = self
        }
    }
    
    func deletePlantConfirmation(){
        let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Delete", style: .destructive) { _ in
            if let plant = self.plant{
                PlantModel.collection.child(plant.id).removeValue()
//                DataModel.shared.plants.removeAll{
//                    plantModel in
//                        plantModel.id == plant.id
//                }
//                DataModel.shared.selectedPlants.removeAll { plantModel in
//                    plantModel.id == plant.id
//                }
//                NotificationCenter.default.post(name:Notification.Name(reloadNotificationKey), object: self)
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    @IBAction func editButtonTaped(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deletePlantConfirmation()
            alert.dismiss(animated: true)
        }
        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            guard let plant = self.plant else{
                alert.dismiss(animated: true)
                return
            }
            self.performSegue(withIdentifier: "ModifySegue", sender: plant)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.addAction(updateAction)
        present(alert, animated: true)
    }
}

extension PlantDetailViewController:PlantDetailDelegate{
    func updatePlant(plant:PlantModel){
        self.plant = plant
        plantImageView.sd_setImage(with: plant.image)
        titleLabel.text = plant.title
        notesLabel.text = plant.notes
//        guard let index = index else{
//            return
//        }
//        DataModel.shared.plants[index] = plant
//        let selectedPlantIndex = DataModel.shared.selectedPlants.firstIndex { plantModel in
//            plantModel.id == self.plant!.id
//        }
//        if let selectedPlantIndex = selectedPlantIndex {
//            DataModel.shared.selectedPlants[selectedPlantIndex] = plant
//        }
//        NotificationCenter.default.post(name: Notification.Name(reloadNotificationKey), object: self)
    }
}
