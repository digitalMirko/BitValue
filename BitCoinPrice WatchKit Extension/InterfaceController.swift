//
//  InterfaceController.swift
//  BitCoinPrice WatchKit Extension
//
//  Created by Mirko Cukich on 12/25/16.
//  Copyright © 2016 Digital Mirko. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        getPrice()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // This function goes out to the internet to coindesk and gets the current price of Bitcoin, then brings it back
    func getPrice(){
        
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        
        URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            if error == nil {
                print("it worked")
                
                if data != nil {
                    let json = JSONSerialization.jsonObject(with: data!, options: [])
                    as? [String:Any]
                    
                }
            } else {
                print("it didnt work")
            }
        }.resume()
    }

}
