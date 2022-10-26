//
//  UpdatePlantViewController.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 16.09.2022.
//

import UIKit
import SDWebImage
import FirebaseStorage
import Firebase

class UpdatePlantViewController: UIViewController {
    
    @IBOutlet weak var PlantView: UIView!
    @IBOutlet weak var tapToAddImageLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var titleCharacterCount: UILabel!
    @IBOutlet weak var submitOutlet: UIButton!
    @IBOutlet weak var ProgressView: UIView!
    @IBOutlet weak var ProgressBar: UIProgressView!
    weak var editDelegate: PlantDetailDelegate?
    var uploadTask: StorageUploadTask?
    var selectedImage: URL?
    var imageToUpload: UIImage?
    var plantToEdit : PlantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(plantViewTapped))
        PlantView.addGestureRecognizer(imageViewTap)
        PlantView.isUserInteractionEnabled = true
        titleTextField.addTarget(self , action: #selector(titleCountUpdate), for: .editingChanged)
        if let plantToEdit = plantToEdit {
            plantImageView.sd_setImage(with: plantToEdit.image)
            titleTextField.text = plantToEdit.title
            notesTextView.text = plantToEdit.notes
            selectedImage = plantToEdit.image
            tapToAddImageLabel.isHidden = true
            plantImageView.contentMode = .scaleAspectFill
            titleCountUpdate()
        }
    }
    
    func update(image:UIImage, title:String , notes:String){
        guard let plant = plantToEdit else{
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.7) else{
            print("couldnt not convert image to jpeg")
            return
        }
        ProgressBar.progress = 0
        ProgressBar.isHidden = false
        ProgressView.isHidden = false
        let imageID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = imageID + ".jpeg"
        let storageRef = Storage.storage().reference(withPath: imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        uploadTask = storageRef.putData(imageData, metadata: metadata, completion: { metadata, error in
            self.ProgressBar.isHidden = true
            self.ProgressView.isHidden = true
            if let error = error {
                print(error.localizedDescription)
                return
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    Database.database().reference().child("plants").child(plant.id).setValue(["title": title, "notes":notes , "image": url.absoluteString])
                    plant.notes = notes
                    plant.title = title
                    plant.image = url
                    self.editDelegate?.updatePlant(plant: plant)
                    self.dismiss(animated: true)
                }
            }
        })
        uploadTask!.observe(.progress) { snapshot in
            let currentProgress = Double(snapshot.progress!.completedUnitCount)
            let totalProgress = Double(snapshot.progress!.totalUnitCount)
            let percentComplete = Float(100.0 * currentProgress / totalProgress)
            self.ProgressBar.setProgress(percentComplete, animated: true)
        }
        
    }
    
    func update(image:UIImage, title:String , notes:String, favorite: Bool){
        guard let plant = plantToEdit else{
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.7) else{
            print("couldnt not convert image to jpeg")
            return
        }
        ProgressBar.progress = 0
        ProgressBar.isHidden = false
        ProgressView.isHidden = false
        let imageID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = imageID + ".jpeg"
        let storageRef = Storage.storage().reference(withPath: imageName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        uploadTask = storageRef.putData(imageData, metadata: metadata, completion: { metadata, error in
            self.ProgressBar.isHidden = true
            self.ProgressView.isHidden = true
            if let error = error {
                print(error.localizedDescription)
                return
            }
            storageRef.downloadURL { url, error in
                if let url = url {
                    Database.database().reference().child("plants").child(plant.id).setValue(["title": title, "notes":notes , "image": url.absoluteString, "isFavorite": true])
                    plant.notes = notes
                    plant.title = title
                    plant.image = url
                    self.editDelegate?.updatePlant(plant: plant)
                    self.dismiss(animated: true)
                }
            }
        })
        uploadTask!.observe(.progress) { snapshot in
            let currentProgress = Double(snapshot.progress!.completedUnitCount)
            let totalProgress = Double(snapshot.progress!.totalUnitCount)
            let percentComplete = Float(100.0 * currentProgress / totalProgress)
            self.ProgressBar.setProgress(percentComplete, animated: true)
        }
        
    }
    
    func update(title:String, notes:String){
        guard var plant = plantToEdit else{
            return
        }
        Database.database().reference().child("plants").child(plant.id).setValue(["title": title, "notes":notes , "image": plant.image.absoluteString])
        plant.title = title
        plant.notes = notes
        editDelegate?.updatePlant(plant: plant)
        self.dismiss(animated: true)
    }
    
    func update(title:String, notes:String, favorites:Bool){
        guard var plant = plantToEdit else{
            return
        }
        Database.database().reference().child("plants").child(plant.id).setValue(["title": title, "notes":notes , "image": plant.image.absoluteString, "isFavorite": true])
        plant.title = title
        plant.notes = notes
        editDelegate?.updatePlant(plant: plant)
        self.dismiss(animated: true)
    }
    
    func setUpView(){
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = CGFloat(4)
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.cornerRadius = CGFloat(4)
        submitOutlet.layer.cornerRadius = submitOutlet.frame.height/2
        PlantView.layer.masksToBounds = true
        PlantView.layer.cornerRadius = PlantView.frame.height/2
        plantImageView.layer.cornerRadius = plantImageView.frame.height/2
        ProgressView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        ProgressView.isHidden = true
        ProgressBar.isHidden = true
    }
    
    @objc func plantViewTapped(){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController .isSourceTypeAvailable(.camera){
                let camera = UIImagePickerController()
                camera.delegate = self
                camera.sourceType = .camera
                camera.allowsEditing = true
                self.present(camera, animated: true)
                alert.dismiss(animated: true)
            } else {
                alert.dismiss(animated: true)
                self.presentErrorAlert(title: "Camera Error", message: "Camera not available")
            }
        }
        let galleryAction = UIAlertAction(title: "Photos", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let library = UIImagePickerController()
                library.delegate = self
                library.sourceType = .photoLibrary
                library.allowsEditing = true
                self.present(library, animated: true)
                alert.dismiss(animated: true)
            } else {
                alert.dismiss(animated: true)
                self.presentErrorAlert(title: "Library Not Available", message: "Library Is Not Available")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        //        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
        //            if let _ = self.selectedImage {
        //                self.selectedImage = nil
        //                self.plantImageView.image = UIImage(systemName: "camera.fill")
        //                self.tapToAddImageLabel.isHidden = false
        //                self.plantImageView.contentMode = .scaleAspectFit
        //            }
        //        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        //      alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    @objc func titleCountUpdate(){
        let count = titleTextField.text?.count ?? 0
        titleCharacterCount.text = "\(count)"
        if count > 3 {
            titleTextField.layer.borderColor = UIColor.green.cgColor
            titleCharacterCount.textColor = UIColor.green
        }else {
            titleTextField.layer.borderColor = UIColor.red.cgColor
            titleCharacterCount.textColor = UIColor.red
        }
    }
    
    
    @IBAction func submitButtonTaped(_ sender: Any) {
        
        guard let titleText = titleTextField.text ,titleText.count > 3 else{
            return
            presentErrorAlert(title: "Title error", message: "The title must have more than 3 characters")
        }
        guard let notesText = notesTextView.text, notesText.count > 5 else{
            return
            presentErrorAlert(title: "Notes error", message: "The notes must have more than 5 characters")
        }
        if let imageToUpload = imageToUpload{
            if let _ = plantToEdit?.favorite{
                update(image: imageToUpload, title: titleText, notes: notesText, favorite: true)
                return
            } else{
                update(image: imageToUpload, title: titleText, notes: notesText)
                return
            }
            
        } else{ if let _ = plantToEdit?.favorite{
            update(title: titleText, notes: notesText, favorites: true)
            return
        }else{
            update(title: titleText, notes: notesText)
            return
        }
        }
        
    }
    
}
    extension UpdatePlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            plantImageView.image = image
            imageToUpload = image
            tapToAddImageLabel.isHidden = true
            plantImageView.contentMode = .scaleAspectFill
            picker.dismiss(animated: true)
            
        }
    }

