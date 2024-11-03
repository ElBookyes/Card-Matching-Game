import Foundation
import UIKit

class CardModel {
    
    func getCards() -> [Card] {
        
        var generatedNumbers = [Int]()
        
        var generatedCards = [Card]()
        
        while generatedCards.count < 8 {
            
            let randomNumber = Int.random(in: 1...13)
            
            if generatedNumbers.contains(randomNumber) == false {
                
                let cardOne = Card()
                let cardTwo = Card()
                
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCards += [cardOne , cardTwo]
                
                generatedNumbers.append(randomNumber)
            }
        }
        
        generatedCards.shuffle()
        
        return generatedCards
    }
    
    
}
