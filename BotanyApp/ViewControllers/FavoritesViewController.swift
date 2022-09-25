//
//  FavoritesViewController.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 16.09.2022.
//

import UIKit

protocol favoritesDelegate: AnyObject{
    func reloadData()
}

class FavoritesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}
extension FavoritesViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.shared.selectedPlants.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = DataModel.shared.selectedPlants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell") as! FavoriteTableViewCell
        cell.PlantImageView.image = plant.image
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
