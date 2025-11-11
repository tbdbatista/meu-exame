import Foundation

// MARK: - Storage Service Protocol

/// Protocol defining storage operations for file management
protocol StorageServiceProtocol {
    /// Uploads data to Firebase Storage
    /// - Parameters:
    ///   - data: The file data to upload
    ///   - path: Storage path (e.g., "exames/userId/fileName.pdf")
    ///   - completion: Result with download URL or error
    func upload(data: Data, to path: String, completion: @escaping (Result<String, Error>) -> Void)
    
    /// Downloads data from Firebase Storage
    /// - Parameters:
    ///   - path: Storage path to download from
    ///   - completion: Result with data or error
    func download(from path: String, completion: @escaping (Result<Data, Error>) -> Void)
    
    /// Deletes a file from Firebase Storage
    /// - Parameters:
    ///   - path: Storage path to delete
    ///   - completion: Result with success or error
    func delete(from path: String, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - FirebaseManager Extension

extension FirebaseManager: StorageServiceProtocol {
    // Already implements upload, download via FirebaseStorageService
    // Just need to add delete method
}

