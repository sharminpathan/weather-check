import Foundation
import UIKit


protocol SendIndexDelegate{
    func sendIndex(Int);
}

class leftMenuView:UIView, UITableViewDelegate, UITableViewDataSource{
    var table:UITableView!
    var cellLabel=["About","Weather near me","Add new location","Set parameters","Close App"]
    
    var delegate : SendIndexDelegate?
    var climateCheck:UIButton!
    var pressureCheck:UIButton!
    var latitudeCheck:UIButton!
    var longitudeCheck:UIButton!
    var humidityCheck:UIButton!
    var parameterList=["climate","humidity","pressure","latitude","longitude"]
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        self.backgroundColor=UIColor.whiteColor()
        
        tableViewSetup()
        buttonsSetup()
    }
    
    func tableViewSetup() {
        table=UITableView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width-200,350))
        table.delegate      =   self
        table.dataSource    =   self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(table)
    }
    
    func buttonsSetup() {
        climateCheck=UIButton(frame: CGRectMake(10,45,20,20))
        climateCheck.layer.borderColor=UIColor.blackColor().CGColor
        climateCheck.layer.borderWidth=2
        climateCheck.addTarget(self, action: "climateClicked:", forControlEvents:
            UIControlEvents.TouchDown)
        climateCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        
        humidityCheck=UIButton(frame: CGRectMake(10,68,20,20))
        humidityCheck.layer.borderColor=UIColor.blackColor().CGColor
        humidityCheck.layer.borderWidth=2
        humidityCheck.addTarget(self, action: "humidityClicked:", forControlEvents:
            UIControlEvents.TouchDown)
        humidityCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        
        pressureCheck=UIButton(frame: CGRectMake(10,91,20,20))
        pressureCheck.layer.borderColor=UIColor.blackColor().CGColor
        pressureCheck.layer.borderWidth=2
        pressureCheck.addTarget(self, action: "pressureClicked:", forControlEvents:
            UIControlEvents.TouchDown)
        pressureCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        
        latitudeCheck=UIButton(frame: CGRectMake(10,114,20,20))
        latitudeCheck.layer.borderColor=UIColor.blackColor().CGColor
        latitudeCheck.layer.borderWidth=2
        latitudeCheck.addTarget(self, action: "latitudeClicked:", forControlEvents:
            UIControlEvents.TouchDown)
        latitudeCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        
        longitudeCheck=UIButton(frame: CGRectMake(10,137,20,20))
        longitudeCheck.layer.borderColor=UIColor.blackColor().CGColor
        longitudeCheck.layer.borderWidth=2
        longitudeCheck.addTarget(self, action: "longitudeClicked:", forControlEvents:
            UIControlEvents.TouchDown)
        longitudeCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellLabel.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if(indexPath.row==3){
            return 170
        }
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as UITableViewCell
        var label=UILabel(frame: CGRectMake(10,5,150,30))
        label.text=cellLabel[indexPath.row]
        
        cell.addSubview(label)
        
        if(indexPath.row==3){
            var climateLabel=UILabel(frame: CGRectMake(35,45,100,20))
            climateLabel.text="climate"
            var humidityLabel=UILabel(frame: CGRectMake(35,68,100,20))
            humidityLabel.text="humidity"
            var pressureLabel=UILabel(frame: CGRectMake(35,91,100,20))
            pressureLabel.text="pressure"
            var latitudeLabel=UILabel(frame: CGRectMake(35,114,100,20))
            latitudeLabel.text="latitude"
            var longitudeLabel=UILabel(frame: CGRectMake(35,137,100,20))
            longitudeLabel.text="longitude"
            
            cell.addSubview(climateLabel)
            cell.addSubview(pressureLabel)
            cell.addSubview(latitudeLabel)
            cell.addSubview(longitudeLabel)
            cell.addSubview(humidityLabel)
            cell.addSubview(climateCheck)
            cell.addSubview(pressureCheck)
            cell.addSubview(latitudeCheck)
            cell.addSubview(longitudeCheck)
            cell.addSubview(humidityCheck)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if let temp = self.delegate {
            delegate?.sendIndex(indexPath.row)
        }else{
            println("optional value contains nill value")
        }
    }
    
    func climateClicked(sender: AnyObject?){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if(appDelegate.checkBoxList[0]==true){
            appDelegate.checkBoxList[0]=false
            climateCheck.setImage(nil, forState: .Normal)
        }
        else{
            appDelegate.checkBoxList[0]=true
            climateCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        }
    }
    
    func humidityClicked(sender: AnyObject?){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if(appDelegate.checkBoxList[1]==true){
            appDelegate.checkBoxList[1]=false
            humidityCheck.setImage(nil, forState: .Normal)
        }
        else{
            appDelegate.checkBoxList[1]=true
            humidityCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        }
    }
    
    func pressureClicked(sender: AnyObject?){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if(appDelegate.checkBoxList[2]==true){
            appDelegate.checkBoxList[2]=false
            pressureCheck.setImage(nil, forState: .Normal)
        }
        else{
            appDelegate.checkBoxList[2]=true
            pressureCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        }
    }
    
    func latitudeClicked(sender: AnyObject?){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if(appDelegate.checkBoxList[3]==true){
            appDelegate.checkBoxList[3]=false
            latitudeCheck.setImage(nil, forState: .Normal)
        }
        else{
            appDelegate.checkBoxList[3]=true
            latitudeCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        }
    }
    
    func longitudeClicked(sender: AnyObject?){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if(appDelegate.checkBoxList[4]==true){
            appDelegate.checkBoxList[4]=false
            longitudeCheck.setImage(nil, forState: .Normal)
        }
        else{
            appDelegate.checkBoxList[4]=true
            longitudeCheck.setImage(UIImage(named: "check.jpg"), forState: UIControlState.Normal)
        }
    }
 }
