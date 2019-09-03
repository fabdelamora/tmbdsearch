//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Fabriccio De la Mora on 3/7/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overViewTextView: UITextView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet var backgroundBlur: UIImageView!
    
    func configureView() {
        if let movie = movie, let voteAverage = voteAverageLabel, let overView = overViewTextView, let releaseDate = releaseDateLabel {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundBlur.addSubview(blurEffectView)
            backgroundBlur.alpha = 0.0
            
            self.title = movie.title
            overView.setContentOffset(CGPoint.zero, animated: false)
            overView.text = movie.overview
            voteAverage.text = "\(movie.voteAverage)"
            releaseDate.text = movie.releaseDate.date()?.timezonedString() ?? "Unknown"
            
            posterImageView.alpha = 0.0
            posterImageView.sd_setImage(with: getMoviePoster(movie), placeholderImage: nil, options: []) {[unowned self] (image, error, imageCacheType, imageUrl) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.posterImageView.alpha = 1.0
                    self.backgroundBlur.image = self.posterImageView.image
                    self.backgroundBlur.alpha = 1.0
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var movie: Movie? {
        didSet {
            configureView()
        }
    }
    
    private func getMoviePoster(_ movie:Movie) -> URL {
        let movieFetch = MovieFetch()
        return movieFetch.posterUrlForResource(movie.posterPath, width:780)
    }

}

