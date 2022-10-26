//
//  ViewController.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 04.09.2022.
//

import UIKit
import FirebaseDatabase
import SDWebImage


class ViewController: UIViewController {
    
    var plants:[PlantModel] = []
    var sort = false

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView(_:)), name: Notification.Name(reloadNotificationKey), object: nil)
        
       
        PlantModel.collection.observe(.value) { snapshot in
            self.plants.removeAll()
            guard let snapshot = snapshot.value as? [String : Any] else {
                return
            }
            for snap in snapshot{
                guard let plantValue = snap.value as? [String:Any] else{
                    continue
                }
                guard let plant = PlantModel(key: snap.key, value: plantValue) else{
                    continue
                }
                self.plants.append(plant)
            }
            if !self.sort {
                self.sortByDate()
            }else{
                self.sortByFavorite()
            }
            self.collectionView.reloadData()
        }
        
//        PlantModel.collection.observe(DataEventType.value) { snapshot in
//
//            guard let plant = PlantModel(snapshot: snapshot) else{
//                return
//            }
//            self.plants.append(plant)
//            self.collectionView.reloadData()
//        }
//
//
//
   }
    func sortByDate(){
        plants.sort{
            $0.date < $1.date
        }
    }
    func sortByFavorite(){
        plants.sort{
            $0.favorite && !$1.favorite
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "PlantInfoSegue"{
            let destinationVC = segue.destination as! PlantDetailViewController
            let index = sender as! Int
            destinationVC.plant = plants[index]
            destinationVC.index = index
            }
    }
    
    
    @objc func reloadCollectionView(_ notification : NSNotification){
        if sort{
            sortByFavorite()
        } else {
            sortByDate()
        }
        collectionView.reloadData()
    }
    
    @IBAction func SortSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            sort = false
            sortByDate()
            collectionView.reloadData()
        }
        else if sender.selectedSegmentIndex == 1{
            sort = true
            sortByFavorite()
            collectionView.reloadData()
        }
    }
}
    


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plant = plants[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlantViewCell",for: indexPath) as! PlantViewCell
        cell.plantImageView.sd_setImage(with: plant.image) 
        cell.plantNameLabel.text = plant.title
        cell.plant = plant
        if plant.favorite{
        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else{
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let spacing = CGFloat(10)
        let cellWidth = (width - (spacing * 2)) / 3
        return CGSize(width: cellWidth, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        performSegue(withIdentifier: "PlantInfoSegue", sender: index)
    }
}
