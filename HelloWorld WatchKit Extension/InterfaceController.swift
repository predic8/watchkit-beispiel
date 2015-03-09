//
//  InterfaceController.swift
//  HelloWorld WatchKit Extension
//
//  Created by Daniel Bonnauer on 09.03.15.
//  Copyright (c) 2015 Daniel Bonnauer. All rights reserved.
//

// Thanks to Pixabay for the provided Images.

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var curTemp: WKInterfaceLabel!
    @IBOutlet var backgroundImage: WKInterfaceGroup!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        getWeatherForLocation("Bonn")
    }
    
    func getWeatherForLocation(ort:String) {
        var url : String = "http://api.openweathermap.org/data/2.5/weather?q=\(ort)&units=metric"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                var main = jsonResult["main"]as! NSDictionary
                var temperatur = main["temp_max"] as! Double
                
                var wetter = jsonResult["weather"]as! NSArray
                var wetter0 = wetter[0] as! NSDictionary
                var himmel = wetter0["main"] as! String
                
                self.updateBenutzerInterface(himmel, temperatur: temperatur)
                
            } else {
                println("Fehler bei Ausführung des Rest-Ausrufs: \(error)");
            }
        })
    }
    
    func updateBenutzerInterface(himmel:String, temperatur:Double) {
        switch himmel {
        case "Clouds":
            self.backgroundImage.setBackgroundImageNamed("wolken")
            break
        case "Haze":
            self.backgroundImage.setBackgroundImageNamed("nebel")
            break
        case "Rain":
            self.backgroundImage.setBackgroundImageNamed("regen")
            break
        case "Clear":
            self.backgroundImage.setBackgroundImageNamed("sonne")
        default:
            
            break
        }
        
        self.curTemp.setText(String(format: "%.2f", temperatur))
    }

}
