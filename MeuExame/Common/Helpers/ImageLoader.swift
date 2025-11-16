import UIKit

/// Helper class for loading images from URLs
final class ImageLoader {
    
    /// Cache for loaded images
    private static var imageCache: [String: UIImage] = [:]
    
    /// Loads an image from a URL string and sets it to an image view
    /// - Parameters:
    ///   - urlString: The URL string of the image
    ///   - imageView: The UIImageView to set the image to
    ///   - placeholder: Optional placeholder image to show while loading
    ///   - completion: Optional completion handler called when image is loaded (or fails)
    static func loadImage(
        from urlString: String,
        into imageView: UIImageView,
        placeholder: UIImage? = nil,
        completion: ((UIImage?) -> Void)? = nil
    ) {
        // Check cache first
        if let cachedImage = imageCache[urlString] {
            imageView.image = cachedImage
            completion?(cachedImage)
            return
        }
        
        // Set placeholder if provided
        if let placeholder = placeholder {
            imageView.image = placeholder
        }
        
        // Validate URL
        guard let url = URL(string: urlString) else {
            print("⚠️ ImageLoader: Invalid URL string: \(urlString)")
            completion?(nil)
            return
        }
        
        // Load image asynchronously
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ ImageLoader: Error loading image - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("⚠️ ImageLoader: Invalid image data from URL: \(urlString)")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            // Cache the image
            imageCache[urlString] = image
            
            // Update UI on main thread
            DispatchQueue.main.async {
                imageView.image = image
                completion?(image)
            }
        }.resume()
    }
    
    /// Clears the image cache (useful for memory management)
    static func clearCache() {
        imageCache.removeAll()
    }
}

