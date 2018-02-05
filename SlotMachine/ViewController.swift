//
// Name: Slot Machine
// Desc: 3 Reel Slot Machine Game
// Ver: 0.8
// Commit: Added custom sounds for spin button click, element selection and jackpot win.
// Contributors:
//      Viktor Bilyk - # 300964200
//      Andrii Damm - # 300966307
//      Tarun Singh - # 300967393
//

import UIKit
import AudioToolbox

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var images = [UIImage(named: "Grape"), UIImage(named: "Watermelon"), UIImage(named: "Mango"), UIImage(named: "Strawberry"), UIImage(named: "Kiwi"), UIImage(named: "Lemon"), UIImage(named: "Apple"), UIImage(named: "Pear"), UIImage(named: "Cherry"), UIImage(named: "Orange"), UIImage(named: "Banana"), UIImage(named: "Mangosteen"), UIImage(named: "jackpot_icon")]
    
    //fruit faces and odds
    let faces = [("Grape", 0.08), ("Watermelon", 0.08), ("Mango", 0.08), ("Strawberry", 0.08), ("Kiwi", 0.08), ("Lemon", 0.08), ("Apple", 0.08), ("Pear", 0.08), ("Cherry", 0.08), ("Orange", 0.08), ("Banana", 0.08), ("Mangosteen", 0.08), ("jackpot_icon", 0.04)]
    
    //odds for combinations : 3 of the same| 2 of the same| ANY of the 3
    let odds = [0.1, 0.25, 0.65]
    
    //Maximum Number for RNG bounds, default arc4random is 2^32
    let maxRandomRange = 4294967296
    
    // Spinning durations for the three pickers before they come to a stop with their final values.
    let firstPickerSpinningDuration = 60
    let secondPickerSpinningDuration = 80
    let thirdPickerSpinningDuration = 100
    
    // Number of rows for the pickerviews in order to implement a seemingly infinite scrolling.
    private let pickerViewRows = 1_000
    private let timeIntervalBetweenSpinnings = 0.25
    
    //game numbers
    var startingMoney = 1000 // starting money
    var jackpot = 100000 // starting jackpot
    var betM = 0 //bet
    
    // Helper variable to make it easy to get our current value from the row offset.
    private var pickerViewMiddle: Int!
    
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
    @IBOutlet weak var infoButton: UIButton!
    
    //pickers outlets
    @IBOutlet weak var row1: UIPickerView!
    @IBOutlet weak var row2: UIPickerView!
    @IBOutlet weak var row3: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize pickerViewMiddle to be used later.
        pickerViewMiddle = ((pickerViewRows / images.count) / 2) * images.count
        
        // Set the initial values of all pickers to the first element of pickers.
            row1.selectRow(0, inComponent: 0, animated: false)
            row2.selectRow(0, inComponent: 0, animated: false)
            row3.selectRow(0, inComponent: 0, animated: false)
        
        updateUI()
    }

    //checking that the bet is not bigger than wallet amount, then spinning the rows
    @IBAction func spin(_ sender: UIButton) {
        // Play a sound when spin button is pressed.
        AudioServicesPlaySystemSound(1100)
        
        //generate random reel combination out of 3 of the same| 2 of the same| ANY of the 3
        let selectedCombination = randomSelection()
        
        //Fruit Face Indexies for purpose of tracking non repating elements
        var indexes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        
        switch selectedCombination {
        case 0: // 3 of the same
            let fruitIndex = getRandomFruitFaceIndex()
            let isJackpotCombination = (fruitIndex == 12)
            
            spinFirstPicker(fruitIndex: fruitIndex)

            spinSecondPicker(fruitIndex: fruitIndex)

            if isJackpotCombination {
                spinThirdPicker(fruitIndex: fruitIndex, isJackpotCombination: true)
            } else {
                spinThirdPicker(fruitIndex: fruitIndex)
            }
            
            //check if player won the jackpot
            if isJackpotCombination {
                startingMoney += jackpot
                jackpot = 10000
            }
            else {
                startingMoney += betM * 10
            }
        case 1: // 2 of the same
            
            //generation position where on the reel 2 of the same fruit should go
            let position = Int(arc4random_uniform(3))
            var fruitIndex = getRandomFruitFaceIndex()
            switch position {
            case 0: //Position: FRUIT FRUIT ANY
                spinFirstPicker(fruitIndex: fruitIndex)
                
                spinSecondPicker(fruitIndex: fruitIndex)
                
                indexes.remove(at: indexes.index(of: fruitIndex)!)
                
                fruitIndex = getRandomNonRepeatingFruitFaceIndex(indexies: indexes)

                spinThirdPicker(fruitIndex: fruitIndex)
            case 1: //Position FRUIT ANY FRUIT
                spinFirstPicker(fruitIndex: fruitIndex)

                spinThirdPicker(fruitIndex: fruitIndex)
                
                indexes.remove(at: indexes.index(of: fruitIndex)!)
                
                fruitIndex = getRandomNonRepeatingFruitFaceIndex(indexies: indexes)

                spinSecondPicker(fruitIndex: fruitIndex)
            case 2: //Position ANY FRUIT FRUIT
                spinSecondPicker(fruitIndex: fruitIndex)

                spinThirdPicker(fruitIndex: fruitIndex)
                
                indexes.remove(at: indexes.index(of: fruitIndex)!)
                
                fruitIndex = getRandomNonRepeatingFruitFaceIndex(indexies: indexes)

                spinFirstPicker(fruitIndex: fruitIndex)
            default: break
            }
            
            //player's winnings
            startingMoney += betM
        case 2: // 3 of Any
            
            //reel 1
            var fruitIndex = getRandomFruitFaceIndex()
            spinFirstPicker(fruitIndex: fruitIndex)
            indexes.remove(at: indexes.index(of: fruitIndex)!)
            //reel 2
            fruitIndex = getRandomNonRepeatingFruitFaceIndex(indexies: indexes)
            spinSecondPicker(fruitIndex: fruitIndex)
            indexes.remove(at: indexes.index(of: fruitIndex)!)
            //reel 3
            fruitIndex = getRandomNonRepeatingFruitFaceIndex(indexies: indexes)
            spinThirdPicker(fruitIndex: fruitIndex)
            
            //Increse jackpot if player loses
            jackpot += betM * 2
            
        default:
            break
        }
        
        //update UI to reflect current game state
        updateUI()
    }
    
    // Position the picker to a particular row after a short delay.
    func positionPickerToSelectedRow(row: Int, timeInterval: Double, picker: UIPickerView, isFinalRowSelection: Bool, isJackpotCombination: Bool) {
        let when = DispatchTime.now() + timeInterval
        DispatchQueue.main.asyncAfter(deadline: when) {
            // If this is the final row selection, select it without animation and play a sound. Otherwise don't play any sound and keep selecting rows with animation.
            if isFinalRowSelection {
                picker.selectRow(row, inComponent: 0, animated: false)
                AudioServicesPlaySystemSound(1054)
                
                // If the player won jackpot, then play the jackpot won alert sound.
                if isJackpotCombination {
                    self.displayJackpotWonAlertWithSound()
                }
            } else {
                picker.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
    
    // Spin the picker for a particular duration passed in as parameters.
    func spinPickerWithCustomAnimation(picker: UIPickerView, generatedIndex: Int, spinningDuration: Int) {
        spinPickerWithCustomAnimation(picker: picker, generatedIndex: generatedIndex, spinningDuration: spinningDuration, isJackpotCombination: false)
    }
    
    // Spin the picker for a particular duration passed in as parameters while taking in the isJackpotCombination parameter.
    func spinPickerWithCustomAnimation(picker: UIPickerView, generatedIndex: Int, spinningDuration: Int, isJackpotCombination: Bool) {
        var row = 0
        var timeDelayBeforeSpinning = 0.0
        // Spin the current pickerview repeatedly for a few times as per the duration defined for the current pickerview before finally making it come to rest with the value at the generated index.
        while row < spinningDuration {
            row = row + 10;
            positionPickerToSelectedRow(row: row, timeInterval: timeDelayBeforeSpinning, picker: picker, isFinalRowSelection: false, isJackpotCombination: false)
            timeDelayBeforeSpinning = timeDelayBeforeSpinning + timeIntervalBetweenSpinnings
        }
        // Position the pickerview to the generated value for the current picker.
        positionPickerToSelectedRow(row: generatedIndex, timeInterval: timeDelayBeforeSpinning, picker: picker, isFinalRowSelection: true, isJackpotCombination: isJackpotCombination)
    }
    
    // Start the process of spinning the first spinner for a particular duration and finally coming to rest at the generated position.
    func spinFirstPicker(fruitIndex: Int) {
        spinPickerWithCustomAnimation(picker: row1, generatedIndex: fruitIndex, spinningDuration: firstPickerSpinningDuration)
    }
    
    // Start the process of spinning the second spinner for a particular duration and finally coming to rest at the generated position.
    func spinSecondPicker(fruitIndex: Int) {
        spinPickerWithCustomAnimation(picker: row2, generatedIndex: fruitIndex, spinningDuration: secondPickerSpinningDuration)
    }
    
    // Start the process of spinning the third spinner for a particular duration and finally coming to rest at the generated position.
    func spinThirdPicker(fruitIndex: Int) {
        spinThirdPicker(fruitIndex: fruitIndex, isJackpotCombination: false)
    }
    
    // Start the process of spinning the third spinner for a particular duration and finally coming to rest at the generated position while taking in the isJackpotCombination parameter.
    func spinThirdPicker(fruitIndex: Int, isJackpotCombination: Bool) {
        spinPickerWithCustomAnimation(picker: row3, generatedIndex: fruitIndex, spinningDuration: thirdPickerSpinningDuration, isJackpotCombination: isJackpotCombination)
    }
    
    // Display the jackpot won alert with sound when a player wins the Jackpot.
    func displayJackpotWonAlertWithSound() {
        playJackpotWonAlertSound()
        
        // Display custom alert view.
        let jackpotAlert = self.storyboard?.instantiateViewController(withIdentifier: "JackpotAlertID") as! JackpotAlertViewController
        jackpotAlert.providesPresentationContextTransitionStyle = true
        jackpotAlert.definesPresentationContext = true
        jackpotAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        jackpotAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(jackpotAlert, animated: true, completion: nil)
    }
    
    // Play the jackpot alert sound when a player wins the Jackpot.
    func playJackpotWonAlertSound() {
        if let jackpotSoundUrl = Bundle.main.url(forResource: "jackpotSound", withExtension: "mp3") {
            var jackpotSoundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(jackpotSoundUrl as CFURL, &jackpotSoundId)
            
            AudioServicesAddSystemSoundCompletion(jackpotSoundId, nil, nil, { (customSoundId, _) -> Void in
                AudioServicesDisposeSystemSoundID(customSoundId)
            }, nil)
            
            AudioServicesPlaySystemSound(jackpotSoundId)
        }
    }
    
    //increasing basic bet (5$) with step in 5$. Example: 5->10->15...
    @IBAction func bet(_ sender: UIButton) {
        if (startingMoney >= 5 )  {
            betM += 5
            startingMoney -= 5
            btnSpin.isEnabled = true
            btnBet.isEnabled = startingMoney < 5 ? false : true
        }
        wallet.text = String (startingMoney)
        bet.text = String (betM)
    }
    
    //reseting user's wallet to starting amount (500$)
    @IBAction func reset(_ sender: UIButton) {
        startingMoney = 500
        jackpot = 100000
        updateUI()
    }
    
    //putting app to the background
    @IBAction func quit(_ sender: UIButton) {
        //suspending application to background
        UIControl().sendAction(#selector(NSXPCConnection.suspend),
                               to: UIApplication.shared, for: nil)
    }
    
    //adding cash to the user wallet
    @IBAction func addCash(_ sender: UIButton) {
        startingMoney += 1000
        btnBet.isEnabled = true
        wallet.text = String (startingMoney)
    }
    
    @IBAction func onInfoButtonClicked(_ sender: UIButton) {
        // Display the custom game rules info view.
        let infoAlert = self.storyboard?.instantiateViewController(withIdentifier: "GameRulesAlertID") as! GameRulesController
        infoAlert.providesPresentationContextTransitionStyle = true
        infoAlert.definesPresentationContext = true
        infoAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        infoAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    // Return the value (image) corresponding to a row number.
    func valueForRow(row: Int) -> UIImage? {
        // the rows repeat every `pickerViewData.count` items
        return images[row % images.count]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    // Whenever the picker view comes to rest, we'll jump back to the row with the current value
    // that is closest to the middle of the picker view.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newRow = pickerViewMiddle + (row % images.count)
        pickerView.selectRow(newRow, inComponent: 0, animated: false)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewRows
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       return UIImageView(image: valueForRow(row: row))
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
    
    //Generate Non Reapitng Fruit Faces Index from avaliable collection of indexes
    func getRandomNonRepeatingFruitFaceIndex(indexies: [Int]) -> Int {
        var randomIndex = -1
        
        repeat {
            randomIndex = getRandomFruitFaceIndex()
        } while (!indexies.contains(randomIndex))
        
        return randomIndex
    }
    
}

