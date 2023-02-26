//
//  YoutubeVideo.swift
//  Netflix Clone
//
//  Created by Toan Phan Nguyen Song on 24/02/2023.
//

import Foundation

struct YoutubeVideoResponse: Codable{
    let items: [YoutubeVideoElement]
}

struct YoutubeVideoElement: Codable{
    let kind: String
    let etag: String
    let id: YoutubeVideoId
}

struct YoutubeVideoId: Codable{
    let kind: String
    let videoId: String
}
