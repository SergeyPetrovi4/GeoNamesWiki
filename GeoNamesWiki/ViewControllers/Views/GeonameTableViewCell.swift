//
//  GeonameTableViewCell.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 06/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import UIKit
import Kingfisher

class GeonameTableViewCell: UITableViewCell {
    
    typealias ActionHandler = ((Int) -> Void)
    
    @IBOutlet weak var thumbnailImg: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var featureLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    private var geoname: GeoName?
    private var completion: ActionHandler?
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbnailImg.layer.cornerRadius = 8.0
        self.thumbnailImg.clipsToBounds = true
    }
    
    // MARK: - Configure
    
    func configure(withGeoname geoname: GeoName, completion: @escaping ActionHandler) {
        
        self.completion = completion
        self.geoname = geoname
        
        self.titleLabel.text = self.geoname?.title
        self.summaryLabel.text = self.geoname?.summary
        
        if let countryCode = self.geoname?.countryCode {
            self.countryCodeLabel.isHidden = false
            self.countryCodeLabel.text = "Cc: \(countryCode)"
            
        } else {
            self.countryCodeLabel.isHidden = true
        }
        
        
        if let feature = self.geoname?.feature {
            self.featureLabel.isHidden = false
            self.featureLabel.text = "Ftr: \(feature)"
            
        } else {
            self.featureLabel.isHidden = true
        }
        
        if let elevation = self.geoname?.elevation {
            self.elevationLabel.isHidden = false
            self.elevationLabel.text = "Elt: \(elevation)"
            
        } else {
            self.elevationLabel.isHidden = true
        }
        
        if let rank = self.geoname?.rank {
            self.rankLabel.isHidden = false
            self.rankLabel.text = "Rank: \(rank)"
            
        } else {
            self.rankLabel.isHidden = true
        }
        
        if let url = URL(string: self.geoname?.thumbnailImg ?? "") {
            self.thumbnailImg.kf.setImage(with: url)
        }                
    }
    
    // MARK: - Action

    @IBAction func didTapMoreButton(_ sender: UIButton) {
        
        guard let geoname = self.geoname else {
            print("Can`t get Geoname")
            return
        }
        
        self.completion?(geoname.geoNameId)
    }
    
    // MARK: - Override
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.selectionStyle = .none
    }
}
