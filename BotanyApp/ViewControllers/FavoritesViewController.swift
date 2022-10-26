//
//  FavoritesViewController.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 16.09.2022.
//

import UIKit
import SDWebImage
import Firebase

protocol favoritesDelegate: AnyObject{
    func reloadData()
}

class FavoritesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var favorites:[PlantModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        PlantModel.collection.observe(.value) { snapshot in
            self.favorites.removeAll()
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
                if plant.favorite{
                    self.favorites.append(plant)
                }
            }
            self.tableView.reloadData()
        }        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tableView.reloadData()
//    }
}
extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = favorites[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        cell.PlantImageView.sd_setImage(with: plant.image)
        cell.PlantLabel.text = plant.title
        cell.delegate = self
        cell.plant = plant
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension FavoritesViewController:favoritesDelegate{
    func reloadData(){
        NotificationCenter.default.post(name: Notification.Name(reloadNotificationKey), object: self)
        tableView.reloadData()
    }
    
}
