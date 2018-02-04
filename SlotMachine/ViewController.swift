//
// Name: Slot Machine
// Desc: 3 Reel Slot Machine Game
// Ver: 0.5
// Commit: RNG Logic & Intital Logic SetUp
// Contributors:
//      Viktor Bilyk - # 300964200
//      Andrii Damm - # 300966307
//      Tarun Singh - # 300967393
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var images = [UIImage(named: "Grape"), UIImage(named: "Watermelon"), UIImage(named: "Mango"), UIImage(named: "Strawberry"), UIImage(named: "Kiwi"), UIImage(named: "Lemon"), UIImage(named: "Apple"), UIImage(named: "Pear"), UIImage(named: "Cherry"), UIImage(named: "Orange"), UIImage(named: "Banana"), UIImage(named: "Mangosteen"), UIImage(named: "jackpot_icon")]
    
    //fruit faces and odds
    let faces = [("Grape", 0.08), ("Watermelon", 0.08), ("Mango", 0.08), ("Strawberry", 0.08), ("Kiwi", 0.08), ("Lemon", 0.08), ("Apple", 0.08), ("Pear", 0.08), ("Cherry", 0.08), ("Orange", 0.08), ("Banana", 0.08), ("Mangosteen", 0.08), ("jackpot_icon", 0.04)]
    
    //odds for combinations : 3 of the same| 2 of the same| ANY of the 3
    let odds = [0.1, 0.25, 0.65]
    
    //Maximum Number for RNG bounds, default arc4random is 2^32
    let maxRandomRange = 4294967296
    
    //game numbers
    var startingMoney = 1000 // starting money
    var jackpot = 100000 // starting jackpot
    var betM = 0 //bet
    
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
        row1.selectRow(4, inComponent:0, animated:true)
        row2.selectRow(4, inComponent:0, animated:true)
        row3.selectRow(4, inComponent:0, animated:true)
        
        updateUI()

    }

    //checking that the bet is not bigger than wallet amount, then spinning the rows
    @IBAction func spin(_ sender: UIButton) {
    }
    
    //increasing basic bet (5$) with step in 5$. Example: 5->10->15...
    @IBAction func bet(_ sender: UIButton) {
    }
    
    //reseting user's wallet to starting amount (500$)
    @IBAction func reset(_ sender: UIButton) {
        startingMoney = 500
        jackpot = 100000
        updateUI()
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
        return ((images[0]?.size.height)! + 15)
    }
    
 //________ CUTSOM FUNC SEC ______
    //Update UI Labels and Reset Bet
    func updateUI() {
        jackPot.text = String (jackpot)
        wallet.text = String (startingMoney)
        betM = 0
        bet.text = String (betM)
        btnSpin.isEnabled = false
        btnBet.isEnabled = startingMoney < 5 ? false : true
    }
    
    //get RandomNumber
    func getRandomNumber() -> Int {
        let randomNumber = arc4random()
        
        return Int(randomNumber)
    }
    
    //Randomly select combination for the reel using given odds
    func randomSelection() -> Int{
        let randomNumber = getRandomNumber()
        var cWeight:Double  = 0
        
        for (i, odd) in odds.enumerated() {
            cWeight += odd
            if ( randomNumber < Int(cWeight * Double(maxRandomRange)) ) {
                return i
            }
        }
        
        return -1
    }
    
    //Randomly select fruit face index using given odds
    func getRandomFruitFaceIndex() -> Int {
        let randomNumber = getRandomNumber()
        var cWeight:Double = 0
        
        for (i, element) in faces.enumerated() {
            cWeight += element.1
            if (randomNumber < Int(cWeight * Double(maxRandomRange))) {
                return i
            }
        }
        
        return -1
    }
    
    
}

