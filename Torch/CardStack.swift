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
        
        setupTransforms()
        
        if cards.count == 1 {
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    func setupTransforms() {
        for (i, card) in cards.enumerated() {
            if i == 0 { continue; }
            
            var transform = CGAffineTransform.identity
            
            if i % 2 == 0 {
                transform = CGAffineTransform(translationX: CGFloat(i) * 4, y: 0)
                .rotated(by: CGFloat(Double.pi)/80*CGFloat(i))
            } else {
                transform = CGAffineTransform(translationX: -CGFloat(i) * 4, y: 0)
                .rotated(by: -CGFloat(Double.pi)/80*CGFloat(i))
            }
            card.transform = transform
        }
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! CardView
        
        let translation = gesture.translation(in: self)
        
        var percent = translation.x / self.bounds.midX
        percent = min(percent, 1)
        percent = max(percent, -1)
        
        var transform = CGAffineTransform.identity
        transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        .rotated(by: CGFloat(Double.pi)*percent/20)
        
        card.transform = transform
        
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: [], animations: {
                card.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
