//
//  String+Extensions.swift
//  Kubazar
//
//  Created by Oleg Pochtovy on 29.11.17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import Foundation
extension String {
    
    func convertToDate() -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date: Date? = dateFormatterGet.date(from: self)
        if let date = date {
            
            let timeInterval = Date().timeIntervalSince(date)
            print("timeInterval =", timeInterval)
            
            if timeInterval < 3600 {
                
                let minutes = Int(timeInterval / 60)
                return String(minutes) + " min ago"
                
            } else if timeInterval < 7200 {
                
                let minutes = Int((timeInterval - 3600) / 60)
                return "1 hour " + String(minutes) + " min ago"
                
            } else if timeInterval < 86400 {
                
                let hours = Int(timeInterval / 3600)
                return String(hours) + " hours ago"
                
            } else if timeInterval < 90000 {
                
                return "1 day 1 hour ago"
                
            } else if timeInterval < 172800 {
                
                let hours = Int((timeInterval - 86400) / 3600)
                return "1 day " + String(hours) + " hours ago"
                
            } else if timeInterval < 2635200 {
                
                let days = Int(timeInterval / 86400)
                return String(days) + " days ago"
                
            } else if timeInterval < 5270400 {
                
                return "1 month ago"
                
            } else if timeInterval < 31622400 {
                
                let months = Int(timeInterval / 2635200)
                return String(months) + " months ago"
                
            } else if timeInterval < 63244800 {
                
                return "1 year ago"
                
            } else {
                
                let years = Int(timeInterval / 31622400)
                return String(years) + " years ago"
                
            }
        }
        
        return ""
    }
}
