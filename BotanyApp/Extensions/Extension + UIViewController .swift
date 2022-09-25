//
//  Extension + UIViewController .swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 08.09.2022.
//

import Foundation
import UIKit

extension UIViewController{
    
    
    func presentErrorAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertbutton = UIAlertAction(title: "Ok", style: .default){ _ in alert.dismiss(animated: true)
        }
        alert.addAction(alertbutton)
        present(alert, animated: true)
        }
    }

