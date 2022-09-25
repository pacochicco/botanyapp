//
//  AddPlantViewController.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 06.09.2022.
//

import UIKit



class AddPlantViewController: UIViewController{

    @IBOutlet weak var PlantView: UIView!
    @IBOutlet weak var tapToAddImageLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var titleCharacterCount: UILabel!
    @IBOutlet weak var submitOutlet: UIButton!
    var selectedImage: UIImage?
    var plantToEdit : PlantModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpView()
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(plantViewTapped))
        PlantView.addGestureRecognizer(imageViewTap)
        PlantView.isUserInteractionEnabled = true
        titleTextField.addTarget(self , action: #selector(titleCountUpdate), for: .editingChanged)
        if let plantToEdit = plantToEdit {
            plantImageView.image = plantToEdit.image
            titleTextField.text = plantToEdit.title
            notesTextView.text = plantToEdit.notes
            selectedImage = plantToEdit.image
            tapToAddImageLabel.isHidden = true
            plantImageView.contentMode = .scaleAspectFill
            titleCountUpdate()
        }
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
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            if let _ = self.selectedImage {
                self.selectedImage = nil
                self.plantImageView.image = UIImage(systemName: "camera.fill")
                self.tapToAddImageLabel.isHidden = false
                self.plantImageView.contentMode = .scaleAspectFit
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(deleteAction)
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
        guard let selectedImage = selectedImage else{
            presentErrorAlert(title: "Image error", message: "Please insert an image to submit")
            return
        }
        guard let titleText = titleTextField.text ,titleText.count > 3 else{
            presentErrorAlert(title: "Title error", message: "The title must have more than 3 characters")
            return
        }
        guard let notesText = notesTextView.text, notesText.count > 5 else{
            presentErrorAlert(title: "Notes error", message: "The notes must have more than 5 characters")
            return
        }
        let plant = PlantModel(image: selectedImage, title: titleText, notes: notesText)
        DataModel.shared.plants.append(plant)
        NotificationCenter.default.post(name: Notification.Name(reloadNotificationKey), object: self)
        dismiss(animated: true)
    }
}
//extension AddPlantViewController: UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        titleCharacterCount.text = "\(textField.text!.count)"
//        if textField.text!.count > 3 {
//            titleTextField.layer.borderColor = UIColor.green.cgColor
//            titleCharacterCount.textColor = UIColor.green
//        }else {
//            titleTextField.layer.borderColor = UIColor.red.cgColor
//            titleCharacterCount.textColor = UIColor.red
//        }
//        return true
//    }
//
//}

extension AddPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        plantImageView.image = image
        selectedImage = image
        tapToAddImageLabel.isHidden = true
        plantImageView.contentMode = .scaleAspectFill
        picker.dismiss(animated: true)
        
    }
}

