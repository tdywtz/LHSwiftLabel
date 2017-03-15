//
//  DownloadManager.swift
//  LHLabel
//
//  Created by bangong on 17/3/15.
//  Copyright © 2017年 luhai. All rights reserved.
//

import UIKit
import Alamofire

class DownloadManager: NSObject {
    func request(_ urlString: String, res: @escaping (DataResponse<Any>) -> Void){
        Alamofire.request(urlString).responseJSON { (response) in
         
        }
    }

}
