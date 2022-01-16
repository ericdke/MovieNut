import Foundation

struct Movie: Codable {
    
    let title: String
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let release_date: String?
    let id: Int
    let original_title: String?
    
    private enum CodingKeys: String, CodingKey {
        case title, overview, poster_path, backdrop_path, release_date, id, original_title
    }
    
    let imageSize: (w: Int, h: Int) = (780, 585)
    let smallImageSize: (w: Int, h: Int) = (185, 138)
    var review = ""
    var rating: Float = 2.5
    var imdbID: String? = nil
    var directorArray = [String]()
    var castArray = [String]()
    var director = ""
    var cast = ""
    
    init(from movie: Movie, rating: Float, review: String) {
        self.rating = rating
        self.review = review
        self.title = movie.title
        self.overview = movie.overview
        self.poster_path = movie.poster_path
        self.backdrop_path = movie.backdrop_path
        self.release_date = movie.release_date
        self.id = movie.id
        self.original_title = movie.original_title
        self.imdbID = movie.imdbID
        self.director = movie.director
        self.cast = movie.cast
        self.directorArray = movie.directorArray
        self.castArray = movie.castArray
    }

    var imagePath: String? {
        if let p = poster_path {
            return "\(TMDbURLComponents.imageBaseURL)w\(imageSize.w)\(p)"
        }
        return nil
    }
    
    var smallImagePath: String? {
        if let p = poster_path {
            return "\(TMDbURLComponents.imageBaseURL)w\(smallImageSize.w)\(p)"
        }
        return nil
    }
    
    var bigImagePath: String? {
        if let p = poster_path {
            return "\(TMDbURLComponents.imageBaseURL)original\(imageSize.w)\(p)"
        }
        return nil
    }
    
    var imageBackdropPath: String? {
        if let p = backdrop_path {
            return "\(TMDbURLComponents.imageBaseURL)w300\(imageSize.w)\(p)"
        }
        return nil
    }
    
    func titleWithYear() -> String {
        if let d = release_date, !d.isBlank, d.count > 3 {
            let sub = d.substring(to: 4)
            return "\(title) (\(sub))"
        } else {
            return title
        }
    }
    
    private func textForMessage() -> String {
        var text = titleWithYear()
        if let o = original_title, original_title != title {
            text = "\(text)\n(\(o))\n\n"
        } else {
            text = "\(text)\n\n"
        }
        if !director.isBlank {
            text = "\(text)\(director)\n\n"
        }
        if !cast.isBlank {
            text = "\(text)\(cast)\n\n"
        }
        text = "\(text)Rating: \(rating.toPrettyString())/5\n\n\(review)"
        if let i = imdbID {
            let u = "[IMDb](https://www.imdb.com/title/\(i))"
            return "\(text)\n\n\(u)"
        }
        return text
    }
    
    var textLengthBeforeReview: Int { return textForMessage().count }
    
    func jsonDataForReview() -> Data {
        let text = textForMessage()
        var obj: [String: Any] = [:]
        var rev: [String: Any] = ["title": title, "release_date": release_date ?? "?", "rating": rating, "tmdb_id": id, "review": review]
        if let o = original_title, original_title != title {
            rev["original_title"] = o
        }
        if let i = imdbID {
            rev["imdb_url"] = "https://www.imdb.com/title/\(i)"
        }
        if !directorArray.isEmpty {
            rev["director"] = directorArray
        }
        if !castArray.isEmpty {
            rev["cast"] = castArray
        }
        if let _ = poster_path {
            let iv: [String: Any] = ["version": "1.0", "type": "photo", "title": titleWithYear(), "url": imagePath!, "width": imageSize.w, "height": imageSize.h, "thumbnail_url": smallImagePath!, "thumbnail_width": smallImageSize.w, "thumbnail_height": smallImageSize.h, "embeddable_url": bigImagePath!, "provider_name": "TMDb", "provider_url": "https://www.themoviedb.org"]
            let it: [String: Any] = ["type": "io.pnut.core.oembed", "value": iv]
            rev["poster_url"] = imagePath!
            let rt: [String: Any] = ["type": "io.aya.movie.review", "value": rev]
            obj = ["text": text, "raw": [it, rt]]
        } else {
            let rt: [String: Any] = ["type": "io.aya.movie.review", "value": rev]
            obj = ["text": text, "raw": [rt]]
        }
        return try! JSONSerialization.data(withJSONObject: obj, options: [])
    }
    
}
