import UIKit



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SendIndexDelegate { // delClickedDelegate {
    
    var searchBar:UISearchBar!
    var table:UITableView!
    var results:NSArray!
    var test:NSDictionary!
    var activityIndicator:UIActivityIndicatorView!
    var rightBarButton=UIBarButtonItem()
    var collectionView:UICollectionView!
    var containerView:UIView!
    var imageList=["add.jpg"]
    var tempList=[""]
    var cityList=[[]]
    var city=[AnyObject]()
    var weatherValues=[AnyObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var vc = leftMenuView(frame: CGRectMake(0,65,UIScreen.mainScreen().bounds.width-200,UIScreen.mainScreen().bounds.height))
    var weatherKeys=["Climate","Humidity","Pressure","Latitude","Longitude"]
    var delButton:UIButton!
    var cityView:cityCardView!
    var panGesture: UIPanGestureRecognizer!
    var delGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title="Weather App"
        vc.delegate = self
        navContSetup()
        collectionViewSetup()
        refreshCity()
        gestureSetup()
        delButtonSetup()
        
        vc.hidden=true
        self.view.addSubview(vc)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        collectionView.reloadData()
    }
    
    
    func delButtonSetup() {
        delButton=UIButton(frame: CGRectMake(300,15,30,20))
        delButton.backgroundColor=UIColor.orangeColor()
        delButton.setTitle("Del", forState: .Normal)
        delButton.addTarget(self, action: "delClicked:", forControlEvents:
            UIControlEvents.TouchDown)
    }
    
    
    func refreshCity() {
        for i in 1...appDelegate.cityList.count-1 {
        let urlCity = (appDelegate.cityList[i][0] as String).stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
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
            
            self.appDelegate.cityList[i][1] = "cloud.jpg"
            self.appDelegate.cityList[i][2] = "weather.jpg"
            for item in self.results{
                for(key,value) in self.appDelegate.imageDict {
                    if(item["main"]! as NSString == key){
                        self.appDelegate.cityList[i][1] = value
                        break;
                    }
                }
                
                for(key,value) in self.appDelegate.bgImageDict {
                    if(item["main"]! as NSString == key) {
                        self.appDelegate.cityList[i][2] = value
                        break;
                    }
                }
                
                self.weatherValues.insert(item["description"]!! as String, atIndex:0)
            }
            
            self.weatherValues.insert(self.test["humidity"]!, atIndex:1)
            self.weatherValues.insert(self.test["pressure"]!, atIndex:2)
            self.appDelegate.cityList[i][3] = (self.test["temp"]!) as Int - 273
            self.test = jsonResult["coord"] as NSDictionary
            self.weatherValues.insert(self.test["lat"]!, atIndex:3)
            self.weatherValues.insert(self.test["lon"]!, atIndex:4)
            
            for i in 0...4{
                if(self.appDelegate.checkBoxList[i]==false){
                    self.weatherKeys.removeAtIndex(i-(5-self.weatherKeys.count))
                    self.weatherValues.removeAtIndex(i-(5-self.weatherValues.count))
                }
            }
            self.appDelegate.cityList[i].append(self.weatherKeys)
            self.appDelegate.cityList[i].append(self.weatherValues)
            self.collectionView.reloadData()
            print("Done")
        })
        task.resume()
        }
    }
    
    
    func navContSetup() {
        let image = UIImage(named: "gps.png") as UIImage?
        var rightButton=UIButton(frame: CGRectMake(200,20,23,23))
        rightButton.setImage(image, forState: .Normal)
        rightButton.addTarget(self, action: "gpsClicked:", forControlEvents:.TouchUpInside)
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem=rightBarButton
        
        let font = UIFont(name: "Arial", size: 25)
        var leftBarButtonItem = UIBarButtonItem(title: "=", style: .Plain, target: self, action: "recognizePanGesture:")
        leftBarButtonItem.setTitleTextAttributes([NSFontAttributeName:font!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    
    func collectionViewSetup() {
        
        var bgImageView=UIImageView(frame: UIScreen.mainScreen().bounds)
        var bgImage=UIImage(named: "weather.jpg")
        bgImageView.contentMode=UIViewContentMode.ScaleAspectFill
        bgImageView.image=bgImage
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 340, height: 50)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.backgroundView=bgImageView
        self.view.addSubview(collectionView)
    }
    
    
    func gestureSetup(){
        panGesture = UIPanGestureRecognizer(target: self, action: Selector("recognizePanGesture:"))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        collectionView.addGestureRecognizer(panGesture)
    }
    
    
    func recognizePanGesture(sender: UIPanGestureRecognizer)
    {
        
        //let translation = panGesture.translationInView(self.view)
        
        if panGesture.view!.center.x < 300 && vc.hidden == true {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.panGesture.view!.center = CGPointMake(self.panGesture.view!.center.x + 170, self.panGesture.view!.center.y)
                }, completion: nil)
            menuClicked(self)
        }
        
        else {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.panGesture.view!.center = CGPointMake(self.panGesture.view!.center.x - 170, self.panGesture.view!.center.y)
                }, completion: nil)
            menuClicked(self)
        }
        
        //panGesture.setTranslation(CGPointMake(0,0), inView: self.view)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.cityList.count
    }
    
    
    func activityIndicatorSetup() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRectMake(15,3,45,45)
        activityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
        activityIndicator.color=UIColor.blackColor()
        activityIndicator.startAnimating()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.cornerRadius=10
        cell.layer.shadowColor = UIColor.grayColor().CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 3.0);
        cell.layer.shadowRadius = 3.0;
        cell.layer.shadowOpacity = 2.0;
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).CGPath;
        
        cityView = cityCardView(frame: CGRectMake(0,0,330,40))
        delGesture = UIPanGestureRecognizer(target: self, action: Selector("delPanGesture:"))
        var imageView=UIImageView(frame: CGRectMake(20,10,30,30))
        
        if(indexPath.row>0){
            imageView=UIImageView(frame: CGRectMake(15,3,45,45))
            delButtonSetup()
            delButton.layer.setValue(indexPath.row, forKey: "index")
            cityView.addGestureRecognizer(delGesture)
            
            
            if(appDelegate.cityList[indexPath.row][1] as String != "") {
                cityView.tempLabel.text="\(appDelegate.cityList[indexPath.row][3]) C"
                cityView.cityLabel.frame=CGRect(x:66,y:7,width:200,height:20)
            }
            else {
                cityView.tempLabel.text=""
            }
        }
        
        imageView.image = UIImage(named: appDelegate.cityList[indexPath.row][1] as String)
        cityView.addSubview(imageView)

        if(appDelegate.cityList[indexPath.row][1] as String == "") {
            activityIndicatorSetup()
            cityView.addSubview(activityIndicator)
        }
        
        cityView.cityLabel.text=appDelegate.cityList[indexPath.row][0] as? String
        for view in cell.subviews {
        view.removeFromSuperview()
        }
        
        cell.addSubview(delButton)
        cell.addSubview(cityView)
        return cell
    }
    
    func delPanGesture(sender: UIPanGestureRecognizer) {
        
        if self.delGesture.view!.frame.size.width == 330 {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.delGesture.view!.frame.size.width = 260
            }, completion: nil)
        }
        
        else {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.delGesture.view!.frame.size.width = 330
                }, completion: nil)
        }
        
    }
    
    func delClicked(sender: UIButton) {
        let i : Int = (sender.layer.valueForKey("index")) as Int!
        appDelegate.cityList.removeAtIndex(i)
        collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row==0){
            self.navigationController?.pushViewController(addCityController(), animated: true)
        }
        else {
            var addCity=addCityController()
            addCity.index=indexPath.row-1
            self.navigationController?.pushViewController(addCity, animated: true)
        }
    }
    
    
    func gpsClicked(sender: AnyObject?) {
        var addController=addCityController()
        addController.gps="THANE"
        self.navigationController?.pushViewController(addController, animated: true)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sendIndex(row : Int){
        
        switch row {
        case 0:
            menuClicked(self)
            let alert = UIAlertController(title: "About", message: "Test Weather App", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Go back", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        case 1:
            gpsClicked(self)
        case 2:
            self.navigationController?.pushViewController(addCityController(), animated: true)
        case 3:
            self.navigationController?.pushViewController(addCityController(), animated: true)
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
}
