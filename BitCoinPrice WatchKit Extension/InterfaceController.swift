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
    
   
    @IBOutlet var priceLbl: WKInterfaceLabel!
    
    @IBOutlet var updatingLbl: WKInterfaceLabel!

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (UserDefaults.standard.value(forKey: "price") as? NSNumber) != nil {
            // We have a previous price
            self.updatingLbl.setText("Updating...")
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
        } else {
            // If we don't have a previous price
            priceLbl.setText("Getting Price")
            self.updatingLbl.setText("")
        }
        getPrice()
    }
    
    
    // This function goes out to the internet to coindesk and gets the current price of Bitcoin, then brings it back
    func getPrice(){
        
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        
        URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            if error == nil {
                print("it works")
                
                if data != nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                        
                        guard let bpi = json["bpi"] as? [String:Any], let USD = bpi["USD"] as? [String:Any],
                            let price = USD["rate_float"] as? NSNumber  else {
                            return
                        }
                        // Check to see if data is coming over
//                        print(rateFloat)
                        
                        // U.S. Dollars formatter
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .currency
                        formatter.locale = Locale(identifier: "en_US")
                        
                        self.priceLbl.setText(formatter.string(from: price))
                        self.updatingLbl.setText("Updated")
                        
                        UserDefaults.standard.set(price, forKey: "price")
                        UserDefaults.standard.synchronize()
                        
                        if CLKComplicationServer.sharedInstance().activeComplications != nil {
                        
                            for comp in CLKComplicationServer.sharedInstance().activeComplications! {
                                CLKComplicationServer.sharedInstance().reloadTimeline(for: comp)
                            }
                        
                        }
                        
                    } catch {}
                }
            } else {
                print("it didnt work")
            }
        }.resume()
    }

}
