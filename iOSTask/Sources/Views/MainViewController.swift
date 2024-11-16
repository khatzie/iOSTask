//
//  MainViewController.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/13/24.
//

import UIKit
import Combine

class MainViewController : UIViewController{
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var letsGoBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    private let viewModel = ActivityViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let general = General()
    private let style = UIDesign()
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        style.primaryButton(letsGoBtn)
//        letsGoBtn.backgroundColor = UIColor(red: 60, green: 66, blue: 239, alpha: 1.0)
        viewModel.fetchActivityData()
        // Observe changes in the ViewModel's activity property
        viewModel.$activity.sink { [weak self] activity in
            guard let self = self else { return }
            self.updateUI(with: activity)
        }
        .store(in: &cancellables)
    }

    private func updateUI(with activity: ActivityResponse?) {
        titleLbl.text = activity?.title
        descriptionLbl.text = activity?.description
        durationLbl.text = "Duration :  "+(activity?.duration ?? "0")
        type = activity?.activity.screens[0].type ?? "default"
        
    }

    @IBAction func letsGo(_ sender: UIButton) {
        general.module(type: type, viewController: self, counter: 0)
    }
    
    
}

