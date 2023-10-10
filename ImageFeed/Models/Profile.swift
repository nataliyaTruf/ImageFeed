//
//  Profile.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 06/10/2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension Profile {
    init(result profile: ProfileResult) {
        self.init(
            username: profile.username,
            name: "\(profile.firstName ?? "")  \(profile.lastName ?? "")",
            loginName: "@\(profile.username)",
            bio: profile.bio
        )
    }
}