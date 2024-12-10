import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private let bilder = URLRequestBilder.shared
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private(set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private init(){}
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = photosRequest(page: nextPage, perPage: 10) else { return }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.task = nil
                switch result {
                case .success(let json):
                    self.photos.append(contentsOf: json.map(self.updatePhoto(_:)))
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self)
                    completion(.success(String(nextPage)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        
    }
    
    func changeLike(photoID: String, isLike: Bool, _ comletion: @escaping (Result<Void, Error>) -> Void){
        assert(Thread.isMainThread)
        
        guard let request = likeRequest(photoID: photoID, isLike: isLike)
        else {
            comletion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.task = nil
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoID}) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                    }
                case .failure(let error):
                    comletion(.failure(error))
                }
            }
        }
        self.task = task
    }
    private func photosRequest(page: Int, perPage: Int) -> URLRequest? {
        bilder.makeHTTPRequst(path: "/photos?page=\(page)" + "&per_page=\(perPage)",
                              httpMethod: "GET",
                              baseURLString: Constant.baseURLString)
    }
    
    private func likeRequest(photoID: String, isLike: Bool) -> URLRequest?{
        bilder.makeHTTPRequst(path: "/photos/\(photoID)/like",
                              httpMethod: isLike ? "POST" : "DELETE" ,
                              baseURLString: Constant.baseURLString)
        
    }
    
    private func updatePhoto(_ updatePhoto: PhotoResult) -> Photo {
        return Photo.init(id: updatePhoto.id,
                          size: CGSize(width: updatePhoto.width, height: updatePhoto.height),
                          createdAt:ISO8601DateFormatter().date(from: updatePhoto.createdAt ?? ""),
                          welcomeDescription: updatePhoto.description,
                          thumbImageURL: updatePhoto.urls.thumb,
                          largeImageURL: updatePhoto.urls.full,
                          isLiked: updatePhoto.likedByUser)
    }
    
}
