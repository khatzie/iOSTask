//
//  General.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/15/24.
//

import Foundation
import UIKit

class General {
    func module(type: String, viewController: UIViewController, counter: Int) {
        switch type {
        case "multipleChoiceModuleScreen":
            DispatchQueue.main.async {
                if let vc = viewController.storyboard?.instantiateViewController(withIdentifier: "MultipleChoiceViewController") as? MultipleChoiceViewController {
                    vc.modalPresentationStyle = .fullScreen
                    vc.counter = counter
                    viewController.present(vc, animated: false)
                } else {
                    // Handle error: View controller could not be instantiated
                    print("Error: Could not instantiate MultipleChoiceViewControlle2r")
                }
            }
        case "recapModuleScreen":
            DispatchQueue.main.async {
                if let vc = viewController.storyboard?.instantiateViewController(withIdentifier: "RecapViewController") as? RecapViewController {
                    vc.modalPresentationStyle = .fullScreen
                    vc.counter = counter
                    viewController.present(vc, animated: false)
                } else {
                    // Handle error: View controller could not be instantiated
                    print("Error: Could not instantiate RecapViewController")
                }
            }
        default:
            break
        }
    }
}
