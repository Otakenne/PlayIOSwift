//
//  APICaller.swift
//  PlayIO
//
//  Created by Otakenne on 10/01/2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {
        
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        
        AuthManager.shared.withValidToken { token in
            guard let url = url else {
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/me"),
                      type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getNewReleases(completion: @escaping (Result<NewReleaseResponse, Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/browse/new-releases?limit=50"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(NewReleaseResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getFeaturedPlaylist(completion: @escaping (Result<FeaturedPlaylistResponse, Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/browse/featured-playlists?limit=50"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getRecommendation(genres: Set<String>, completion: @escaping (Result<RecommendationsResponse , Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: "\(Constants.baseURL)/recommendations?limit=50&seed_genres=\(seeds)"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/recommendations/available-genre-seeds"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/albums/\(album.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/playlists/\(playlist.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                    print(result)
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/browse/categories?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func search(query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        let encoddedQueryString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        createRequest(with: URL(
            string: "\(Constants.baseURL)/search?limit=10&q=\(encoddedQueryString)&type=album,artist,playlist,track"),
            type: .GET
        ) { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    
                    var searchResult: [SearchResult] = []
                    searchResult.append(contentsOf: result.albums.items.compactMap({ album in
                            .album(model: album)
                    }))
                    searchResult.append(contentsOf: result.artists.items.compactMap({ artist in
                            .artist(model: artist)
                    }))
                    searchResult.append(contentsOf: result.playlists.items.compactMap({ playlist in
                            .playlist(model: playlist)
                    }))
                    searchResult.append(contentsOf: result.tracks.items.compactMap({ track in
                            .track(model: track)
                    }))
                    
                    completion(.success(searchResult))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylist(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/me/playlists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
//                    print("Results : \(result)")
                    let playlists = result.items
                    completion(.success(playlists))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                let urlString = "\(Constants.baseURL)/users/\(profile.id ?? "")/playlists"
                self?.createRequest(with: URL(string: urlString), type: .POST) { bodyRequest in
                    var request = bodyRequest
                    let json = [ "name": name]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String : Any], response["id"] as? String != nil {
                                print("Created")
                                completion(true)
                            } else {
                                print("Failed to create")
                                completion(false)
                            }
                            
                        } catch {
                            completion(false)
                        }
                    }
                    
                    task.resume()
                }

            case .failure(_):
                break
            }
        }

    }
    
    public func addTrackToPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: "\(Constants.baseURL)/playlists/\(playlist.id)/track"), type: .POST) { bodyRequest in
            var request = bodyRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String : Any], response["snapshot_id"] as? String != nil {
                        print("Added")
                        completion(true)
                    } else {
                        print("Failed to create")
                        completion(false)
                    }
                    
                } catch {
                    completion(false)
                }
            }
            
            task.resume()
        }
    }
    
//    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool) -> Void) {
//        createRequest(with: URL(string: "\(Constants.baseURL)/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
//            let task = URLSession.shared.dataTask(with: request) { data, _, error in
//                guard let data = data, error == nil else {
//                    completion(.failure(APIError.failedToGetData))
//                    return
//                }
//                
//                do {
//                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
//                    let playlists = result.playlists.items
//                    completion(.success(playlists))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            
//            task.resume()
//        }
//    }
}
