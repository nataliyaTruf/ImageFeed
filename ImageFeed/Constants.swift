//
//  Constants.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 17/09/2023.
//

import Foundation

enum Constants {
    static let accessKey: String = "YIdDeipnqmyFrGPIPRGkH_xyqPr1WoZTsiBUG24Ug7c"
    static let secretKey: String = "35jhiuXM_bBuBfVw4WstuCw9TPNLFw88vYx5FCj8p1Q"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
}
