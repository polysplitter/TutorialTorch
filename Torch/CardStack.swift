import UIKit

class CardStack: UIView {
    var cards: [CardView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    func defaultInit() {
        
        for person in people {
            addPerson(person: person)
        }
    }
    
    func addPerson(person: Person) {
        let card = CardView()
        card.person = person
        self.addSubview(card)
        
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: card, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: card, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: card, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: card, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        cards.append(card)
        self.sendSubviewToBack(card)
        
        setupTransforms(0.0)
        
        if cards.count == 1 {
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    func setupTransforms(_ percentCompletion: Double) {
        let translationDelta: CGFloat = 6
        let imageOffset: CGFloat = 40
        
        for (i, card) in cards.enumerated() {
            if i == 0 { continue; }
            
            var translationA, rotationA, scaleA: CGFloat!
            var translationB, rotationB, scaleB: CGFloat!
            
            if i % 2 == 0 {
                translationA = CGFloat(i)*translationDelta
                rotationA = CGFloat(Double.pi)/imageOffset*CGFloat(i)
                
                translationB = -CGFloat(i - 1)*translationDelta
                rotationB = -CGFloat(Double.pi)/imageOffset*CGFloat(i - 1)
            } else {
                translationA = -CGFloat(i)*translationDelta
                rotationA = -CGFloat(Double.pi)/imageOffset*CGFloat(i)
                
                translationB = CGFloat(i - 1)*translationDelta
                rotationB = CGFloat(Double.pi)/imageOffset*CGFloat(i - 1)
            }
            
            scaleA = 1-CGFloat(i)*0.05
            scaleB = 1-CGFloat(i-1)*0.05
            
            let translation = translationA*(1-CGFloat(percentCompletion))+translationB*CGFloat(percentCompletion)
            let rotation = rotationA*(1-CGFloat(percentCompletion))+rotationB*CGFloat(percentCompletion)
            let scale = scaleA*(1-CGFloat(percentCompletion))+scaleB*CGFloat(percentCompletion)
            
            var transform = CGAffineTransform.identity
            
            transform = CGAffineTransform(translationX: translation, y: 0)
                .rotated(by: rotation)
                .scaledBy(x: scale, y: scale)
            
            card.transform = transform
        }
    }
    
    func setupGestures() {
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for gesture in gestures {
                card.removeGestureRecognizer(gesture)
            }
        }
        
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! CardView
        
        let translation = gesture.translation(in: self)
        
        var percent = translation.x / self.bounds.midX
        percent = min(percent, 1)
        percent = max(percent, -1)
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: [], animations: {
            self.setupTransforms(abs(Double(percent)))
        }, completion: nil)
        
        if percent > 0.2 {
            card.nopeLabel.alpha = 0
            
            let newPercent = (percent - 0.2)/0.8
            card.likeLabel.alpha = newPercent
        } else if percent < -0.2 {
            card.likeLabel.alpha = 0
            
            let newPercent = (abs(percent) - 0.2)/0.8
            card.nopeLabel.alpha = newPercent
        } else {
            card.likeLabel.alpha = 0
            card.nopeLabel.alpha = 0
        }
        
        var transform = CGAffineTransform.identity
        transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        .rotated(by: CGFloat(Double.pi)*percent/20)
        
        card.transform = transform
        
        if gesture.state == .ended {
            
            let velocity = gesture.velocity(in: self)
            
            let percentBlock = {
                self.cards.remove(at: self.cards.index(of: card)!)
                self.setupGestures()
                card.removeGestureRecognizer(card.gestureRecognizers![0])
                
                let normVelX = velocity.x / translation.x / 10
                let normVelY = velocity.y / translation.y / 10
                
                UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelX, options: [], animations: {
                    card.center.x = translation.x * 10
                }, completion: nil)
                
                UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: normVelY, options: [], animations: {
                    card.center.y = translation.y * 10
                }, completion: nil)
            }
            
            if percent > 0.2 {
                percentBlock()
            } else if percent < -0.2 {
                percentBlock()
            } else {
                let normVelX = -velocity.x / translation.x
                let normVelY = -velocity.y / translation.y
                
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                    card.likeLabel.alpha = 0
                    card.nopeLabel.alpha = 0
                }, completion: nil)
                
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: normVelX, options: [], animations: {
                    var transform  = CGAffineTransform.identity
                    transform = CGAffineTransform(translationX: 0, y: translation.y)
                    card.transform = transform
                }, completion: nil)
                
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: normVelY, options: [], animations: {
                    var transform  = CGAffineTransform.identity
                    transform = CGAffineTransform(translationX: 0, y: 0)
                    card.transform = transform
                }, completion: nil)
            }
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: [], animations: {
                self.setupTransforms(0)
            }, completion: nil)
        }
    }
}
