import Foundation
import UIKit


class addCityController: UIViewController,UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SendIndexDelegate {
    
    var searchBar:UISearchBar!
    var table:UITableView!
    var activityIndicator:UIActivityIndicatorView!
    var cityName:String!
    var results:NSArray!
    var test:NSDictionary!
    var addButton:UIButton!
    var image:UIImage!
    var imageName:String!
    var gps:String!
    var index:Int!
    var temp:AnyObject!
    var bgImageName:String!
    var imageDict = ["Clear":"sun.jpg","Mist":"mist.png","Cloud":"cloud.jpg","Snow":"snow.jpg","Rain":"rain.jpg","Fog":"fog.jpg","Haze":"haze.jpg","Smoke":"fog.jpg"]
    var bgImageDict = ["Clear":"sunBG.jpg","Mist":"mistBG.jpg","Cloud":"cloudBG.jpg","Snow":"snowBG.jpg","Rain":"rainBG.jpeg","Fog":"fogBG.jpg","Haze":"fogBG.jpg","Smoke":"smokeBG.jpg","Clouds":"cloudBG.jpg"]

    var weatherKeys=["Climate","Humidity","Pressure","Latitude","Longitude"]
    var weatherValues = [AnyObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
     var vc = leftMenuView(frame: CGRectMake(0,65,UIScreen.mainScreen().bounds.width-200,UIScreen.mainScreen().bounds.height))
    var bgImageView:UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="Add City"
        
        bgImageName="weather.jpg"
        bgImageView=UIImageView(frame: UIScreen.mainScreen().bounds)
        var bgImage=UIImage(named: bgImageName)
        bgImageView.contentMode=UIViewContentMode.ScaleAspectFill
        bgImageView.image=bgImage
        self.view.addSubview(bgImageView)
        self.view.sendSubviewToBack(bgImageView)
        vc.delegate=self
        
        navContSetup()
        searchBarSetup()
        tableViewSetup()
        gpsCity()
        displayCity()
        
        vc.hidden=true
        self.view.addSubview(vc)
    }
    
    
    func tableViewSetup() {
        table=UITableView(frame: CGRectMake(12,350,350,180))
        table.layer.cornerRadius=20
        table.layer.borderColor=UIColor.redColor().CGColor
        table.delegate      =   self
        table.dataSource    =   self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(table)
        table.hidden=true
    }
    
    
    func tempLabelSetup() {
        var label=UILabel(frame: CGRectMake(15,70,350,350))
        label.text="\(temp) C"
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(120.0)
        self.view.addSubview(label)
        if(bgImageName=="fogBG.jpg" || bgImageName=="smokeBG.jpg" || bgImageName=="rainBG.jpeg") {
         label.textColor=UIColor.whiteColor()
        }
    }
    
    
    func weatherSetup() {
        tableBorderSetup()
        bgImageView.image=UIImage(named: bgImageName)
        self.title=self.cityName
        self.table.reloadData()
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden=true
        self.table.hidden=false
    }
    
    
    func navContSetup() {
        let font = UIFont(name: "Arial", size: 25)
        var leftBarButtonItem = UIBarButtonItem(title: "=", style: .Plain, target: self, action: "menuClicked:")
        leftBarButtonItem.setTitleTextAttributes([NSFontAttributeName:font!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backClicked:")
    }
    
    
    func activityIndicatorSetup() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x:(UIScreen.mainScreen().bounds.width)/2, y: (UIScreen.mainScreen().bounds.height)/2, width: 0, height: 0)
        activityIndicator.transform = CGAffineTransformMakeScale(3, 3);
        activityIndicator.color=UIColor.blackColor() //(red: 0.5, green: 0.754, blue: 1, alpha: 2.0)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    
    func addButtonSetup() {
        addButton=UIButton(frame: CGRectMake(140,570,100,30))
        addButton.addTarget(self, action: "addClicked:", forControlEvents:
            UIControlEvents.TouchDown)
        addButton.backgroundColor=UIColor.whiteColor()
        addButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.blackColor().CGColor
        addButton.layer.shadowColor = UIColor.blackColor().CGColor
        addButton.layer.shadowOpacity=2
        addButton.setTitle("ADD", forState: UIControlState.Normal)
        addButton.titleLabel!.font=UIFont.boldSystemFontOfSize(20.0)
        self.view.addSubview(addButton)
    }
    
    
    func tableBorderSetup() {
        table.layer.borderWidth=2
        if(bgImageName=="fogBG.jpg" || bgImageName=="smokeBG.jpg" || bgImageName=="snow.jpg" || bgImageName=="rainBG.jpeg") {
         table.layer.borderColor=UIColor.grayColor().CGColor
        }
        else if(bgImageName=="sunBG.jpg") {
         table.layer.borderColor=UIColor.orangeColor().CGColor
        }
        else if(bgImageName=="mistBG.jpg") {
         table.layer.borderColor=UIColor.greenColor().CGColor
        }
        else {
         table.layer.borderColor=UIColor.blueColor().CGColor
        }
    }
    
    
    func searchBarSetup() {
        searchBar = UISearchBar(frame: CGRectMake(0, 80, UIScreen.mainScreen().bounds.width, 20))
        searchBar.delegate=self
        searchBar.text="Enter City"
        self.view.addSubview(searchBar)
    }
    
    
    func displayCity(){
        if(index != nil){
            self.title=""
            searchBar.hidden=true
            var city=appDelegate.cityList[index+1]
            cityName=city[0] as String
            imageName=city[1] as String
            bgImageName=city[2] as String
            bgImageView.image=UIImage(named: bgImageName)
            temp=city[3]
            tempLabelSetup()
            self.table.reloadData()
            self.table.hidden=false
            tableBorderSetup()
            
            self.weatherKeys.removeAll(keepCapacity: false)
        
            self.weatherKeys = city[4] as [String]
            self.weatherValues = city[5] as [AnyObject]
        }
    }
    
    
    func gpsCity(){
        if(gps != nil){
            searchBar.hidden=true
            self.title="Your Location"
            self.cityName=gps
            search()
        }
    }
    
    
    func search(){
        
        activityIndicatorSetup()
        
        let urlCity = (cityName).stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var url=NSURL(string:"http://api.openweathermap.org/data/2.5/weather?q="+urlCity+"&appid=44db6a862fba0b067b1930da0d769e98")!
        
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            var jsonResult: Dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as Dictionary<String, AnyObject>
            println(jsonResult)
            self.results = jsonResult["weather"] as NSArray
            self.test = jsonResult["main"] as NSDictionary
            
            if(self.results == nil){
                self.navigationController?.popViewControllerAnimated(true)
                return
            }
            
            self.imageName="cloud.jpg"
            self.bgImageName="weather.jpg"
            for item in self.results{
                for(key,value) in self.imageDict{
                if(item["main"]! as NSString == key){
                    
                    self.imageName = value
                    break;
                    }
                }
                
                for(key,value) in self.bgImageDict{
                if(item["main"]! as NSString == key){
                        
                    self.bgImageName = value
                    break;
                    }
                }
                
                self.weatherValues.insert(item["description"]!! as String, atIndex:0)
            }
            
            self.weatherValues.insert(self.test["humidity"]!, atIndex:1)
            self.weatherValues.insert(self.test["pressure"]!, atIndex:2)
            self.temp = (self.test["temp"]!) as Int - 273
            self.test = jsonResult["coord"] as NSDictionary
            self.weatherValues.insert(self.test["lat"]!, atIndex:3)
            self.weatherValues.insert(self.test["lon"]!, atIndex:4)
            
            for i in 0...4{
                if(self.appDelegate.checkBoxList[i]==false){
                    self.weatherKeys.removeAtIndex(i-(5-self.weatherKeys.count))
                    self.weatherValues.removeAtIndex(i-(5-self.weatherValues.count))
                }
            }
            
            self.tableViewSetup()
            self.addButtonSetup()
            self.tempLabelSetup()
            self.weatherSetup()
    })
    task.resume()
}

    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.text=""
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.cityName=searchBar.text.uppercaseString
        search()
    }
        
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherKeys.count
    }
    
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 35
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath: indexPath) as UITableViewCell
            
            if weatherValues.count != 0 {
                var keyLabel=UILabel(frame: CGRectMake(90,5,80,30))
                keyLabel.font = UIFont.boldSystemFontOfSize(15.0)
                var valueLabel=UILabel(frame: CGRectMake(190,5,150,30))
                valueLabel.font = UIFont.boldSystemFontOfSize(15.0)
                keyLabel.text = "\(weatherKeys[indexPath.row])"
                valueLabel.text = "\(weatherValues[indexPath.row])"
                
                cell.addSubview(keyLabel)
                cell.addSubview(valueLabel)
                return cell
            }
            return cell
    }
    
    
    func menuClicked(sender: AnyObject?) {
        if self.navigationItem.leftBarButtonItem?.title=="X" {
            self.navigationItem.leftBarButtonItem?.title="="
            vc.hidden=true
        }
        else{
            self.navigationItem.leftBarButtonItem?.title="X"
            vc.hidden=false
        }
    }
    
    
    func addClicked(sender: AnyObject?) {
        var flag=0
        for city in appDelegate.cityList{
            if cityName == city[0] as String{
                flag=1
                let alert = UIAlertController(title: "Error!", message: "City Already Exists", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Go back", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        if flag == 0 {
            var city=[cityName,imageName,bgImageName,temp]
            city.append(weatherKeys)
            city.append(weatherValues)
            appDelegate.cityList.append(city)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func sendIndex(row : Int){
        
        switch row {
        case 0:
            menuClicked(self)
            let alert = UIAlertController(title: "About", message: "Test Weather App", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Go back", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        case 1:
            menuClicked(self)
            if(gps == nil){
            var addController=addCityController()
            addController.gps="THANE"
            addController.search()
            self.navigationController?.pushViewController(addController, animated: true)
            }
        case 2:
            menuClicked(self)
        case 3:
            menuClicked(self)
        case 4:
            var cities=[AnyObject]()
            for i in 1...appDelegate.cityList.count-1 {
                cities.append(appDelegate.cityList[i][0])
            }
            appDelegate.defaults.setObject(cities, forKey: "cities")
            exit(0)
        default:
            println("no index")
            
        }
    }
    
    
    func backClicked(sender: AnyObject?){
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}
