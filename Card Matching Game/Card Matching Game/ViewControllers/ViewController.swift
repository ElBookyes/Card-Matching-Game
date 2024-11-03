import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var model = CardModel()
    private var cardArray = [Card]()
    
    private var firstFlippedCardIndex: IndexPath?
    private var secondFlippedCardIndex: IndexPath?
    
    private var timer: Timer?
    private var miliseconds: Float = 10 * 6000 // 60 seconds
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    // MARK: - Timer Methods
    
    @objc private func timerElapsed() -> Void {
        miliseconds -= 1
        
        let seconds = String(format: "%.2f", miliseconds / 1000)
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
        if miliseconds <= 0 {
            
            // Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void
    {
        
        // Check if there's any time left
        if miliseconds <= 0 {
            return
        }
        
        // Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if !card.isFlipped && !card.isMatched {
            
            cell.flip()
            
            card.isFlipped = true
            
            // Check if it's the first or second card being flipped.
            if firstFlippedCardIndex == nil {
                
                firstFlippedCardIndex = indexPath
                
            } else {
                checkForMatches(indexPath)
            }
            
        }
        
    }
    
    // MARK: - Game Logic Methods
    
    private func checkForMatches(_ secondFlippedCardIndex: IndexPath) -> Void {
        
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            
        } else {
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collectionView to reload the cell of the first card if it's nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        // Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    private func checkGameEnded() -> Void {
        // Determine if there are any cards unmatched
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        // Messaging variables
        var title = ""
        var message = ""
        
        // No unmatched cards left, stop the timer
        if isWon {
            if miliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations"
            message = "You've won"
        }
        else {
            
            if miliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show won/lost messaging
        showAlert(title, message)
        
    }
    
    private func showAlert(_ title: String, _ message: String) -> Void {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }

}

