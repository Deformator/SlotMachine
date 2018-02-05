//
// Name: Slot Machine
// Desc: 3 Reel Slot Machine Game
// Ver: 0.1
// Commit: Custom view created for showing the game rules info with animation.
// Contributors:
//      Viktor Bilyk - # 300964200
//      Andrii Damm - # 300966307
//      Tarun Singh - # 300967393
//  Created by Tarun Singh on 2018-02-05.
//  Copyright © 2018 Andrii Damm. All rights reserved.

import UIKit

class GameRulesController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var gotItButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    // Customize the view.
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    // Animate the view in a slow shaky fashion from inside out.
    func animateView() {
        alertView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.alertView.transform = .identity
            },
                       completion: nil)
    }
    
    // Simply dismiss the view on got it button clicked.
    @IBAction func onGotItButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


