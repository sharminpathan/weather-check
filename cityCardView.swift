import Foundation
import UIKit

class cityCardView: UIView {

    var cityLabel:UILabel!
    var tempLabel:UILabel!
    var delButton:UIButton!
    var activityIndicator:UIActivityIndicatorView!
    var panRecognizer:UIPanGestureRecognizer!
    var lastLocation:CGPoint = CGPointMake(350,15)
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.backgroundColor=UIColor.whiteColor()
        
        cityLabel=UILabel(frame: CGRectMake(63,15,200,20))
        cityLabel.textColor=UIColor.orangeColor()//(red: 0.6, green: 0.754, blue: 10, alpha: 2.0)
        cityLabel.font = UIFont.boldSystemFontOfSize(20.0)
        
        tempLabel=UILabel(frame: CGRectMake(66,25,100,20))
        tempLabel.textColor=UIColor.orangeColor()//(red: 0.5, green: 0.754, blue: 10, alpha: 2.0)
        
        panRecognizer = UIPanGestureRecognizer(target:self, action:"detectPan:")
        self.gestureRecognizers = [panRecognizer]
        
        self.addSubview(cityLabel)
        self.addSubview(tempLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
