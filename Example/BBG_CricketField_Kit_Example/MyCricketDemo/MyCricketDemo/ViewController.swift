//
//  ViewController.swift
//  MyCricketDemo
//
//  Created by User on 08/12/25.
//

import UIKit

import BBG_CricketField_Kit

class ViewController: UIViewController {
        private let selectedPositionLabel = UILabel()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
    
            let groundView = GroundLayoutView()
            groundView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(groundView)
    
            NSLayoutConstraint.activate([
                groundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                groundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                groundView.widthAnchor.constraint(equalToConstant: 400),
                groundView.heightAnchor.constraint(equalToConstant: 400)
            ])
    
            groundView.onPositionSelect = { [weak self] position in
                self?.selectedPositionLabel.text = "Selected: \(position.type.displayName())"
            }
    
            selectedPositionLabel.textColor = .white
            selectedPositionLabel.font = .systemFont(ofSize: 20)
            selectedPositionLabel.translatesAutoresizingMaskIntoConstraints = false
    
            view.addSubview(selectedPositionLabel)
    
            NSLayoutConstraint.activate([
                selectedPositionLabel.topAnchor.constraint(equalTo: groundView.bottomAnchor, constant: 20),
                selectedPositionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
}


 extension UIColor {
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - percentage/100, 0.0),
                           green: max(g - percentage/100, 0.0),
                           blue: max(b - percentage/100, 0.0),
                           alpha: a)
        }
        return self
    }
}
