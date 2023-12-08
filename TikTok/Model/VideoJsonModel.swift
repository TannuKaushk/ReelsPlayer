//
//  Model.swift
//  TikTok
//
//  Created by TORVIS on 01/09/23.
//


import Foundation


    // MARK: - VideoJsonModel
    class VideoJsonModel: NSObject, Codable {
        let transcodings: [Transcoding]

        init(transcodings: [Transcoding]) {
            self.transcodings = transcodings
        }
    }

    // MARK: - Transcoding
    class Transcoding: NSObject, Codable {
        let httpuri: String

        init(httpuri: String) {
            self.httpuri = httpuri
        }
    }
