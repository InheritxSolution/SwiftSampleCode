//
//  CommonConstants.swift
//  Code_structure_with_login
//
//  Created by vishal lakum on 13/11/20.
//  Copyright © 2020 vishal lakum. All rights reserved.
//

import Foundation
import UIKit

//multiple storyboard cosntants
let mainSB = UIStoryboard(name: "Main", bundle: nil)
let dashboardSB = UIStoryboard(name: "Dashboard", bundle:nil)
let guestSB = UIStoryboard(name: "Guest", bundle:nil)

struct NOTIFICATION_TYPE
{
    static let SURVEY   = "Survey"
    static let POST     = "Post"
    static let COMMENT  = "Comment"
}

struct MediaAccess {
    static let actionFileTypeHeading = "Select Image"
    static let actionFileTypeDescription = "Chose Soource Of image"
    static let camera = "Camera"
    static let phoneLibrary = "Phone Library"
    static let video = "Video"
    static let audio = "Audio"
    static let file = "File"
    
    static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
    
    static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
    
    static let settingsBtnTitle = "Settings"
    
    static let cancelBtnTitle = "Cancel"
}

struct UserDefaultsKey
{
    static let USER_ID              = "user_id"
    static let IS_USER_LOGGED_IN    = "is_user_logged_in"
    static let DEVICE_TOKEN         = "device_token"
    static let USER_TOKEN           = "user_token"
    static let ALL_KEYS             = [USER_ID,USER_TOKEN,IS_USER_LOGGED_IN,DEVICE_TOKEN]
}

