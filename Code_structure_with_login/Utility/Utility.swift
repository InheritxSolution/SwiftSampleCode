//
//  Utility.swift
//  Code_structure_with_login
//
//  Created by vishal lakum on 13/11/20.
//  Copyright © 2020 vishal lakum. All rights reserved.
//

import Foundation
import SDWebImage
import SwiftyJSON

let defaults = UserDefaults.standard
typealias APIResponseBlock = (_ model:JSON) -> Void
typealias APIFailureResponseBlock = (_ error: Error?) -> Void

class Utility : NSObject{
    

    //Save and Retrive Is Login
    class var userLoggedin: Bool{
        get {
            if let isLogin = defaults.object(forKey: UserDefaultsKey.IS_USER_LOGGED_IN){
                return isLogin as? Bool ?? false
            }else{
                return false
            }
        }

        set {
            defaults.set(newValue, forKey: UserDefaultsKey.IS_USER_LOGGED_IN)
        }
    }
    
    
    class var userToken: String{
        get {
            if let mytoken = defaults.object(forKey: UserDefaultsKey.USER_TOKEN){
                return mytoken as? String ?? ""
            }else{
                return ""
            }
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKey.USER_TOKEN)
        }
    }

    
    //MARK:- ~~~~~~~~~~ clear imageCatch
    
    func ClearImageCatch(){
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }

}

func showValidationErrorAlert(msg:String,completion:@escaping (()->()))  {
    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default) { (okBtn) in
        completion()
    }
    alert.addAction(okAction)
    getTopMostViewController()?.present(alert, animated: true, completion: {
    })
}

struct errorCODE
{
    static let noInternet = -1009
    static let connectionLost = -1005
    static let requestTimeOut = -1001
    static let jsonParseError = 3840
    static let jsonParError = 4
}

