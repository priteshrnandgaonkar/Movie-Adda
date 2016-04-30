//
//  MovieTableViewCell.swift
//  Movie Adda
//
//  Created by Pritesh Nandgaonkar on 30/04/16.
//  Copyright © 2016 Pritesh Nandgaonkar. All rights reserved.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var year: UILabel!
    
    func populateCell(movie: Movie) {
        title.text = movie.title
        year.text = movie.year
    }
    
}