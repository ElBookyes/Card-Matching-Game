import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    private var card: Card?
    
    public func setCard(_ card: Card) {
        
        // Keep track of the card that gets passed in
        self.card = card
        
        // Addressing reusing cells issue: Determine if card is matched already
        if card.isMatched == true {
            // If the card is matched, the make the image views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return // exits method and doesnt run the rest of the code below.
        } else {
            // If the card hasn't been matched, then make the image views visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // Addressing reusing cells issue: Determining if the card is in a flipped up or flipped down state
        if card.isFlipped {
            // Make sure the frontImageView is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromLeft])
            
        } else {
            // Make sure the backImageView is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromLeft])
            
        }
    }
    
    public func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3,
                          options: [.transitionFlipFromLeft, .showHideTransitionViews]
        )
        
    }
    
    public func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews]
            )
        }
    }
    
    public func remove() {
        // Removes both image views from being visible
        
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        })
    }
}
