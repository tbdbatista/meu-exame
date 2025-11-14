import UIKit
import QuickLook
import WebKit

/// FileViewerViewController displays files (PDFs, images, etc.) within the app
final class FileViewerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let fileURL: URL
    private let fileName: String
    private var localFileURL: URL?
    private let storageService: StorageServiceProtocol?
    
    // MARK: - UI Components
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    init(fileURL: URL, fileName: String, storageService: StorageServiceProtocol? = nil) {
        self.fileURL = fileURL
        self.fileName = fileName
        self.storageService = storageService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Check if URL is remote or local
        if fileURL.scheme == "http" || fileURL.scheme == "https" {
            // Remote URL - download first
            downloadAndShowFile()
        } else {
            // Local URL - show directly
            showFile(url: fileURL)
        }
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = fileName
        
        // Close button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        // Activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true) { [weak self] in
            // Clean up temporary file
            self?.cleanupTemporaryFile()
        }
    }
    
    // MARK: - File Handling
    
    private func downloadAndShowFile() {
        activityIndicator.startAnimating()
        
        // Extract storage path from Firebase Storage URL
        guard let storagePath = extractStoragePath(from: fileURL) else {
            // If we can't extract path, try direct download from URL
            downloadFromURL()
            return
        }
        
        // Download from Firebase Storage
        storageService?.download(from: storagePath) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let data):
                    self?.saveAndShowFile(data: data)
                case .failure(let error):
                    print("❌ FileViewer: Error downloading from storage: \(error.localizedDescription)")
                    // Fallback to direct URL download
                    self?.downloadFromURL()
                }
            }
        }
    }
    
    private func downloadFromURL() {
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: fileURL) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    print("❌ FileViewer: Error downloading from URL: \(error.localizedDescription)")
                    self?.showError(message: "Não foi possível baixar o arquivo.")
                    return
                }
                
                guard let data = data else {
                    self?.showError(message: "Arquivo vazio ou inválido.")
                    return
                }
                
                self?.saveAndShowFile(data: data)
            }
        }.resume()
    }
    
    private func saveAndShowFile(data: Data) {
        // Save to temporary directory
        let tempDir = FileManager.default.temporaryDirectory
        let tempFileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            try data.write(to: tempFileURL)
            localFileURL = tempFileURL
            showFile(url: tempFileURL)
        } catch {
            print("❌ FileViewer: Error saving file: \(error.localizedDescription)")
            showError(message: "Não foi possível salvar o arquivo.")
        }
    }
    
    private func showFile(url: URL) {
        // Determine file type by extension
        let fileExtension = url.pathExtension.lowercased()
        
        // For images, use UIImageView directly (more reliable than QuickLook)
        if ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic", "heif"].contains(fileExtension) {
            showImageView(url: url)
        } else if fileExtension == "pdf" {
            // For PDFs, try QuickLook first, fallback to WebView
            if QLPreviewController.canPreview(url as QLPreviewItem) {
                showQuickLookPreview(url: url)
            } else {
                showWebView(url: url)
            }
        } else {
            // For other types, try QuickLook, fallback to WebView
            if QLPreviewController.canPreview(url as QLPreviewItem) {
                showQuickLookPreview(url: url)
            } else {
                showWebView(url: url)
            }
        }
    }
    
    private func showImageView(url: URL) {
        guard let imageData = try? Data(contentsOf: url),
              let image = UIImage(data: imageData) else {
            showError(message: "Não foi possível carregar a imagem.")
            return
        }
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        // Set content size based on image size
        DispatchQueue.main.async {
            let imageSize = image.size
            let scrollSize = scrollView.bounds.size
            if scrollSize.width > 0 && scrollSize.height > 0 {
                let widthRatio = scrollSize.width / imageSize.width
                let heightRatio = scrollSize.height / imageSize.height
                let scale = min(widthRatio, heightRatio, 1.0)
                let scaledWidth = imageSize.width * scale
                let scaledHeight = imageSize.height * scale
                scrollView.contentSize = CGSize(width: max(scaledWidth, scrollSize.width), height: max(scaledHeight, scrollSize.height))
            } else {
                scrollView.contentSize = imageSize
            }
        }
        
        activityIndicator.stopAnimating()
    }
    
    private func showQuickLookPreview(url: URL) {
        // Verify file exists before trying to preview
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("⚠️ FileViewer: File does not exist at path: \(url.path)")
            showWebView(url: url)
            return
        }
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self
        
        // Add as child view controller
        addChild(previewController)
        view.addSubview(previewController.view)
        previewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        previewController.didMove(toParent: self)
        
        activityIndicator.stopAnimating()
    }
    
    private func showWebView(url: URL) {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        activityIndicator.stopAnimating()
    }
    
    private func extractStoragePath(from url: URL) -> String? {
        // Firebase Storage URLs have format:
        // https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{path}?alt=media&token={token}
        let urlString = url.absoluteString
        
        guard urlString.contains("firebasestorage.googleapis.com"),
              let pathRange = urlString.range(of: "/o/"),
              let queryRange = urlString.range(of: "?") else {
            return nil
        }
        
        let pathStart = urlString.index(pathRange.upperBound, offsetBy: 0)
        let pathEnd = queryRange.lowerBound
        var path = String(urlString[pathStart..<pathEnd])
        
        // Decode URL encoding
        path = path.removingPercentEncoding ?? path
        
        return path
    }
    
    private func cleanupTemporaryFile() {
        if let localURL = localFileURL {
            try? FileManager.default.removeItem(at: localURL)
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(
            title: "Erro",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    deinit {
        cleanupTemporaryFile()
    }
}

// MARK: - QLPreviewControllerDataSource

extension FileViewerViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let urlToPreview: URL = localFileURL ?? fileURL
        return urlToPreview as QLPreviewItem
    }
}

// MARK: - QLPreviewControllerDelegate

extension FileViewerViewController: QLPreviewControllerDelegate {
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        cleanupTemporaryFile()
    }
    
    func previewController(_ controller: QLPreviewController, failedToLoadPreviewItem item: QLPreviewItem, withError error: Error) {
        print("❌ FileViewer: QuickLook failed to load preview: \(error.localizedDescription)")
        // Fallback to WebView if QuickLook fails
        if let url = item.previewItemURL {
            DispatchQueue.main.async { [weak self] in
                controller.view.removeFromSuperview()
                controller.removeFromParent()
                self?.showWebView(url: url)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension FileViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first { $0 is UIImageView }
    }
}

