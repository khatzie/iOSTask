//
//  RecapViewController.swift
//  iOSTask
//
//  Created by Katherine Petalio on 11/15/24.
//

import UIKit
import Combine
import Lottie


class RecapViewController: UIViewController{
   
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmationText: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    var counter: Int = 0
    var totalQuestions: Int = 0
    var options: [Answers] = []
    var correctAnswer: String = ""
    var selectedAnswer: String = ""
    var isMultipleSelectionAllowed = false
    var type = ""
    var hiddenView:UIView!
    
    private let viewModel = ActivityViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let general = General()
    private let style = UIDesign()
    
    //private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchActivityData()
        
        
        // Observe changes in the ViewModel's activity property
        viewModel.$screens.sink { [weak self] screens in
            guard let self = self else { return }
            self.updateUI(with: screens)
        }
        .store(in: &cancellables)
        
        
        
    }
    
    
    private func updateUI(with screens: Screens?) {
        
        animationView.isHidden = true
        confirmationView.isHidden = true
        checkBtn.isHidden = true
        continueButton.isHidden = true
        hiddenView = nil
        
        if (hiddenView != nil){
            hiddenView.removeFromSuperview()
        }
        
        totalQuestions = screens?.screens.count ?? 0
        if counter < totalQuestions {
            type = screens?.screens[counter].type ?? "default"
            
            if type != "recapModuleScreen" {
                general.module(type: type, viewController: self, counter: counter)
            }else{
                let bodyText = screens?.screens[counter].body
                
                bodyLbl.text = bodyText?.replacingOccurrences(of: "%  RECAP  %", with: "__________ -")
                options = screens?.screens[counter].answers ?? []
                correctAnswer = screens?.screens[counter].correctAnswer ?? ""
                createAnswerCloud(on: optionsView, options: options)
                progressBar.progress = Float(counter+1) / Float(totalQuestions)
                
            }
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
    
    func createAnswerCloud(on view: UIView, options: [Answers]) {
        for tempView in view.subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }

        var xPos: CGFloat = 15.0
        var yPos: CGFloat = 15.0
        var tag = 0
        
        for answer in options {
            
            let startString = answer.text

            let width = startString.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width
            let checkWholeWidth = xPos + width + 13.0 + 25.5

            if checkWholeWidth > UIScreen.main.bounds.size.width - 30.0 {
                xPos = 10.0
                yPos += 29.0 + 20.0
            }
            
            let viewHolder = UIView(frame: CGRect(x: xPos, y: yPos, width: width + 40.0, height: 44.0))
            viewHolder.layer.cornerRadius = 8
            viewHolder.backgroundColor = .lightGray
            viewHolder.layer.shadowColor = UIColor.lightGray.cgColor
            viewHolder.layer.shadowOffset = CGSize(width: 2, height: 2)
            viewHolder.layer.shadowRadius = 6
            viewHolder.layer.shadowOpacity = 0.5
            
            let bgView = UIView(frame: CGRect(x:0, y: 0, width: width + 40.0, height: 44.0))
            bgView.layer.cornerRadius = 8
            bgView.backgroundColor = .white
            bgView.layer.shadowColor = UIColor.lightGray.cgColor
            bgView.layer.shadowOffset = CGSize(width: 2, height: 2)
            bgView.layer.shadowRadius = 6
            bgView.layer.shadowOpacity = 0.5
            bgView.tag = tag
         
    
            let textLabel = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: width, height: bgView.frame.size.height))
            textLabel.font = .systemFont(ofSize: 16)
            textLabel.text = startString
            textLabel.textColor = .black
            bgView.addSubview(textLabel)
            xPos += width + 17.0 + 43.0
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            bgView.addGestureRecognizer(tapGesture)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            bgView.addGestureRecognizer(panGestureRecognizer)
            
            viewHolder.addSubview(bgView)
            view.addSubview(viewHolder)
            
            
            tag += 1
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if (hiddenView == nil){
            if let tappedView = sender.view {
                let tagValue = tappedView.tag
                hiddenView = tappedView
                tappedView.isHidden = true
                selectedAnswer = options[tagValue].id
                
                checkBtn.isHidden = false

            }
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if (checkBtn.isHidden){
            if let tappedView = gestureRecognizer.view {
                let tagValue = tappedView.tag
                hiddenView = tappedView
                //tappedView.isHidden = true
                selectedAnswer = options[tagValue].id
            }
            
            let view = gestureRecognizer.view!
            let translation = gestureRecognizer.translation(in: view.superview)

            switch gestureRecognizer.state {
            case .began:
                break
            case .changed:
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
                gestureRecognizer.setTranslation(.zero, in: view.superview)
                break
            case .ended:
                checkBtn.isHidden = false
                break
            default:
                break
            }
        }
        
       
    }
    
    @IBAction func checkAnswer(_ sender: Any) {
        if selectedAnswer == correctAnswer{
            debugPrint("correct")
            animationView.isHidden = false
            animationView.contentMode = .scaleToFill
            animationView.loopMode = .loop
            animationView.animationSpeed = 0.5
            animationView.play()
            checkBtn.isHidden = true
            continueButton.isHidden = false
            style.addBorderTop(to: confirmationView, color: UIColor.green, thickness: 5)
            confirmationView.isHidden = false
            confirmationText.text = "You’re correct!"
        }else{
            debugPrint("wrong")
            continueButton.isHidden = false
            checkBtn.isHidden = true
            style.addBorderTop(to: confirmationView, color: UIColor.red, thickness: 5)
            confirmationView.isHidden = false
            confirmationText.text = "Try again!"
        }
        
    }
    
    
    
    @IBAction func continueAction(_ sender: Any) {
        debugPrint("continue action")

        if selectedAnswer == correctAnswer{
            counter+=1
            viewModel.$screens.sink { [weak self] screens in
                guard let self = self else { return }
                self.updateUI(with: screens)
            }
            .store(in: &cancellables)
        }else{
            debugPrint("wrong")
            viewModel.$screens.sink { [weak self] screens in
                guard let self = self else { return }
                self.updateUI(with: screens)
            }
            .store(in: &cancellables)
        }
    }
    
    
    
}
