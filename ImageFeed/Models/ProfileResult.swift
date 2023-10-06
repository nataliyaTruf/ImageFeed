//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 06/10/2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}
