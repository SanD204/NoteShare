import UIKit

class College {
    var title: String
    var subtitle: String
    var image: UIImage
    init(title: String, subtitle: String, image: UIImage) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}

struct Subject {
    let title: String
    let subtitle: String
    let image: UIImage
    let pdfURL: URL
}

struct ExploreSubject {
    let title: String
    let subtitle: String
    let image: UIImage
}

struct Note {
    let title: String
    let description: String
    let author: String
    let coverImage: UIImage?
    let dateCreated: Date
    let lastModified: Date
    init(title: String, description: String, author: String, coverImage: UIImage?,
         dateCreated: Date = Date(), lastModified: Date = Date()) {
        self.title = title
        self.description = description
        self.author = author
        self.coverImage = coverImage
        self.dateCreated = dateCreated
        self.lastModified = lastModified
    }
}
struct CNote {
    let title: String
    let description: String
    let author: String
    let coverImage: UIImage?
    let dateCreated: Date
    let lastModified: Date
    let pdfUrl: URL
    
    init(title: String, description: String, author: String, coverImage: UIImage?,
         dateCreated: Date = Date(), lastModified: Date = Date() , pdfUrl: URL) {
        self.title = title
        self.description = description
        self.author = author
        self.coverImage = coverImage
        self.dateCreated = dateCreated
        self.lastModified = lastModified
        self.pdfUrl = pdfUrl
    }
}

struct RecentFile {
    let name: String
    let icon: UIImage?
    let dateModified: Date
    let fileSize: String
    let pdfURL: URL
    
    init(name: String, icon: UIImage?, dateModified: Date = Date(), fileSize: String = "0 KB" , pdfURL: URL) {
        self.name = name
        self.icon = icon
        self.dateModified = dateModified
        self.fileSize = fileSize
        self.pdfURL = pdfURL
    }
}

struct ScannedDocument {
    let id: UUID
    let title: String
    let pdfUrl: URL
    let thumbnailImage: UIImage
    let dateCreated: Date
    let numberOfPages: Int
    
    init(id: UUID = UUID(),
         title: String,
         pdfUrl: URL,
         thumbnailImage: UIImage,
         dateCreated: Date = Date(),
         numberOfPages: Int) {
        self.id = id
        self.title = title
        self.pdfUrl = pdfUrl
        self.thumbnailImage = thumbnailImage
        self.dateCreated = dateCreated
        self.numberOfPages = numberOfPages
    }
}

struct NoteCard {
   let title: String
   let author: String
   let description: String
   let coverImage: UIImage?
   let pdfUrl: URL

   init(title: String, author: String, description: String,pdfUrl: URL,coverImage: UIImage?) {
       self.title = title
       self.author = author
       self.description = description
       self.coverImage = coverImage
       self.pdfUrl = pdfUrl
   }
}
