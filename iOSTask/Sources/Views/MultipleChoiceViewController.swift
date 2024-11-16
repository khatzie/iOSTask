//
//  MultipleChoiceViewController.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/13/24.
//

import UIKit
import Combine

/// customTableViewCell to display users details.
class optionsTableViewCell: UITableViewCell {
    @IBOutlet weak var emojiLbl: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var optionLbl: UILabel!

        override func awakeFromNib() {
            super.awakeFromNib()

            // Set background color
            backgroundColor = UIColor.white
            selectedBackgroundView = UIView(frame: frame)
            
            selectedBackgroundView?.backgroundColor = UIColor.clear
            selectedBackgroundView?.layer.borderColor = UIColor.purple.cgColor //CGColor(red: 100, green: 66, blue: 239, alpha: 1.0)
            selectedBackgroundView?.layer.cornerRadius = 12
            selectedBackgroundView?.layer.borderWidth = 2
            selectedBackgroundView?.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            
            let margins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
            contentView.frame = contentView.frame.inset(by: margins)
            contentView.layer.cornerRadius = 12
            
        }
    
    override func layoutSubviews() {
          super.layoutSubviews()
          //set the values for top,left,bottom,right margins
          
    }

}


class MultipleChoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var selectAllLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var questionsLbl: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var counter: Int = 0
    var totalQuestions: Int = 0
    var options: [Choices] = []
    var isMultipleSelectionAllowed = false
    var type = ""
    
    private let viewModel = ActivityViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let general = General()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchActivityData()
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.separatorStyle = .none
        // Observe changes in the ViewModel's activity property
        viewModel.$screens.sink { [weak self] screens in
            guard let self = self else { return }
            self.updateUI(with: screens)
        }
        .store(in: &cancellables)
    }
    
    private func updateUI(with screens: Screens?) {
        
        
        totalQuestions = screens?.screens.count ?? 0
        if counter < totalQuestions {
            type = screens?.screens[counter].type ?? "default"
            
            if type != "multipleChoiceModuleScreen" {
                general.module(type: type, viewController: self, counter: counter)
            }else{
                confirmBtn.isEnabled = false
                questionsLbl.text = screens?.screens[counter].question
                
                options = (screens?.screens[counter].choices)!
                
                if screens?.screens[counter].multipleChoicesAllowed == true {
                    optionsTableView.allowsMultipleSelection = true
                    selectAllLbl.isHidden = false
                    confirmBtn.isHidden = false
                    isMultipleSelectionAllowed = true
                }else{
                    optionsTableView.allowsMultipleSelection = false
                    selectAllLbl.isHidden = true
                    confirmBtn.isHidden = true
                    isMultipleSelectionAllowed = false
                }
                optionsTableView.reloadData()
            }
            progressBar.progress = Float(counter+1) / Float(totalQuestions)
        } else {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThankYou") as? ThankYou {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            } else {
                // Handle the case where the view controller couldn't be instantiated
                print("Failed to instantiate ThankYouViewController")
                // Consider adding error handling or alternative actions here
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier:
     "optionsTableViewCell") as! optionsTableViewCell
            let option = options[indexPath.row]
            cell.emojiLbl.text = option.emoji
            cell.optionLbl.text = option.text

            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Handle cell selection here
        confirmBtn.isEnabled = true
        if isMultipleSelectionAllowed == false {
            counter+=1
            viewModel.$screens.sink { [weak self] screens in
                guard let self = self else { return }
                self.updateUI(with: screens)
            }
            .store(in: &cancellables)
        }
    
    }


    @IBAction func confirmSelection(_ sender: Any) {
        counter+=1
        viewModel.$screens.sink { [weak self] screens in
            guard let self = self else { return }
            self.updateUI(with: screens)
        }
        .store(in: &cancellables)
        
    }
}
