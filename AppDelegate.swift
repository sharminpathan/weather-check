class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController:UIViewController!
    var navController:UINavigationController!
    var cityList:[[AnyObject]]=[["Add City","add.png","weather.jpg",""]]
    var checkBoxList=[true,true,true,true,true]
    var defaults=NSUserDefaults.standardUserDefaults()
    var imageDict = ["Clear":"sun.jpg","Mist":"mist.png","Cloud":"cloud.jpg","Snow":"snow.jpg","Rain":"rain.jpg","Fog":"fog.jpg","Haze":"haze.jpg","Smoke":"fog.jpg"]
    var bgImageDict = ["Clear":"sunBG.jpg","Mist":"mistBG.jpg","Cloud":"cloudBG.jpg","Snow":"snowBG.jpg","Rain":"rainBG.jpeg","Fog":"fogBG.jpg","Haze":"fogBG.jpg","Smoke":"smokeBG.jpg","Clouds":"cloudBG.jpg"]

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window{
            navController = UINavigationController()
            viewController = ViewController()
            self.navController.pushViewController(viewController, animated: false)
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            self.window!.rootViewController = navController
            
            self.window!.backgroundColor = UIColor.whiteColor()
            self.window!.makeKeyAndVisible()
            
            if let cityArray = defaults.objectForKey("cities") as? [AnyObject]{
                for item in cityArray {
                    cityList.append([item,"","",""])
                }
            }
            
            }
        
        return true
    }
