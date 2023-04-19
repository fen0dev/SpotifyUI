//
//  SampleData.swift
//  SpotifyNewUI
//
//  Created by Giuseppe, De Masi on 23/03/22.
//

import Foundation

struct Album: Identifiable {
    
    var id = UUID().uuidString
    var albumName: String
    var albumImage: String
    var listeners: String
    var isLiked: Bool = false
    
}

var stackAlbums: [Album] = [

    Album(albumName: "Resurrection", albumImage: "2pac_cover", listeners: "33 Mln"),
    Album(albumName: "Nothing Was The Same", albumImage: "drake_cover", listeners: "56 Mln"),
    Album(albumName: "Highest In The Room", albumImage: "trvs_cover", listeners: "21 Mln"),
    Album(albumName: "My Year", albumImage: "aaron_cover", listeners: "50 Mln")
    
]

var albums: [Album] = [

    Album(albumName: "Resurrection", albumImage: "2pac_cover", listeners: "33 Mln"),
    Album(albumName: "Nothing Was The Same", albumImage: "drake_cover",  listeners: "56 Mln", isLiked: true),
    Album(albumName: "Highest In The Room", albumImage: "trvs_cover", listeners: "21 Mln"),
    Album(albumName: "My Year", albumImage: "aaron_cover", listeners: "50 Mln", isLiked: true)

]
