//
//  Extension+Profile.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 06/01/2024.
//

import Foundation

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
