//
//  ViewController.swift
//  SlotMachine
//
//  Created by Andrii Damm on 2018-01-31.
//  Copyright © 2018 Andrii Damm. All rights reserved.
//  Commit: pickerView setUp
//  Version: 0.45

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var images = [UIImage(named: "Lemon"), UIImage(named: "Apple"), UIImage(named: "Banana"), UIImage(named: "Cherry"), UIImage(named: "jackpot_icon"), UIImage(named: "Grape"), UIImage(named: "Kiwi"), UIImage(named: "Lemon"), UIImage(named: "Mango"), UIImage(named: "Mangosteen"), UIImage(named: "Orange"), UIImage(named: "Pear"), UIImage(named: "Strawberry"), UIImage(named: "Watermelon")]
    
    //labels outlets
    @IBOutlet weak var jackPot: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var bet: UILabel!

    //buttons outlets
    @IBOutlet weak var btnSpin: UIButton!
    @IBOutlet weak var btnBet: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnQuit: UIButton!
    @IBOutlet weak var btnAddCash: UIButton!
    
    //pickers outlets
    @IBOutlet weak var row1: UIPickerView!
    @IBOutlet weak var row2: UIPickerView!
    @IBOutlet weak var row3: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //checking that the bet is not bigger than wallet amount, then spinning the rows
    @IBAction func spin(_ sender: UIButton) {
    }
    
    //increasing basic bet (5$) with step in 5$. Example: 5->10->15...
    @IBAction func bet(_ sender: UIButton) {
    }
    
    //reseting user's wallet to starting amount (500$)
    @IBAction func reset(_ sender: UIButton) {
    }
    
    //putting app to the background
    @IBAction func quit(_ sender: UIButton) {
    }
    
    //adding cash to the user wallet
    @IBAction func addCash(_ sender: UIButton) {
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       return UIImageView(image: images[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return (images[0]?.size.height)!
    }
    
}

