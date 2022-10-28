//
//  LnTools.swift
//  DLive
//
//  Created by 健崔 on 2022/9/13.
//  Copyright © 2022 Lino Corp. All rights reserved.
//

import UIKit
let headIndex = 3
let tailIndex = 4
class LNTools: NSObject {
   
//    #MARK: ------------------ public interface safeString---------------------
    static func LnSafeString(str : String) -> Bool {
        if(str.isEmpty){
            return false
        }
        if(str.count <= 0) {
            return false
        }
        return true
    }
    
    
// MARK: -----------only number  public interface -----------

   static func LNIsNumber(str:String) ->Bool {
        var  allNunber = true
        for c in str {
            if ( c < "0" ||  c > "9") {
                allNunber = false
               break
            }
        }
        return allNunber
    }
    
// MARK: -----------email  public interface -----------
//    12345678904@163.com  -->> 123****8904@163.com
    
    static func LNsafeEmaile(email : String) -> String {
        let postion = LNTools.LNLastAppearIndex(firstStr: email, sub: "@")
        let mailStr = email as NSString?
        let headStr = mailStr?.substring(to: postion)  as NSString?
        let tail = mailStr?.substring(from: postion)
        if headStr!.length < 3 {
           return email
        }
        if headStr!.length > 7 {
            return  LNEmailAddEncryp(headStr: headStr, tail: tail, headEncrypIndex: headIndex, tailEncrypIndex: tailIndex)
        } else {
            return LNEmailAddEncryp(headStr: headStr, tail: tail, headEncrypIndex: 2, tailEncrypIndex: 1)
        }
    }
    // MARK: -----------cout  public interface -----------

    static func LNsafeStringLog(str : String) -> String {
        let coutStr = str as NSString?
      
        if coutStr!.length > 7 {
            return  LNCoutAddEncryp(cout: coutStr,  headEncrypIndex: headIndex, tailEncrypIndex: tailIndex) as String
        } else {
            return  LNCoutAddEncryp(cout: coutStr,  headEncrypIndex: 2, tailEncrypIndex: 1) as String
        }
    }
    
    
   //encryp method  email private interface
    static func LNEmailAddEncryp(headStr : NSString? ,tail : String?, headEncrypIndex : Int, tailEncrypIndex : Int) -> String {
        let preStr = headStr?.substring(to: headEncrypIndex)
        let tailStr = headStr?.substring(from: headStr!.length - tailEncrypIndex)
        let encrypCout = headStr!.length - headEncrypIndex - tailEncrypIndex
        var num = 0;
        var encrypStr  : NSString? = ""
        while num < encrypCout {
            encrypStr =   encrypStr?.appending("*") as NSString?
            num = num + 1
        }
        let backStr = NSString(format: "%@%@%@", preStr!,encrypStr!,tailStr!)
        let total = backStr.appending(tail!)
        return total
    }
    
    //encryp method  cout private interface
     static func LNCoutAddEncryp(cout : NSString?, headEncrypIndex : Int, tailEncrypIndex : Int) -> NSString {
         let preStr = cout?.substring(to: headEncrypIndex)
         let tailStr = cout?.substring(from: cout!.length - tailEncrypIndex)
         let encrypCout = cout!.length - headEncrypIndex - tailEncrypIndex
         var num = 0;
         var encrypStr  : NSString? = ""
         while num < encrypCout {
             encrypStr =   encrypStr?.appending("*") as NSString?
             num = num + 1
         }
         let backStr = NSString(format: "%@%@%@", preStr!,encrypStr!,tailStr!)
         return backStr
     }
    
    static func LNLastAppearIndex(firstStr : String ,sub : String) -> Int {
        var pos = -1;
        if  let range =  firstStr.range(of:sub, options: true ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = firstStr.distance(from: firstStr.startIndex, to: range.lowerBound)
            }
        }
       return pos
    }
       
}
