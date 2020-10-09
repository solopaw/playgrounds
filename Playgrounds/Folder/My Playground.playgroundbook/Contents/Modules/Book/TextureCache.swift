//
//  TextureCache.swift
//
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import SpriteKit

// A cache for textures.
public class TextureCache: NSObject, NSCacheDelegate {
    
    // The shared `TextureCache`.
    public static let shared = TextureCache()
    
    private var cache = NSCache<NSString, SKTexture>()
    
    // Older textures are purged when the addition of another texture would exceed `sizeLimitMB`. The default is 0 MB: no limit.
    public var sizeLimitMB: Int = 0 {
        didSet {
            cache.totalCostLimit = sizeLimitMB * 1000 * 1000
        }
    }
    
    override init() {
        super.init()
        cache.delegate = self
    }
    
    // Adds a texture to the cache with a key and cost (MB).
    public func add(_ texture: SKTexture, forKey key: String, cost: Int) {
        NSLog("TextureCache add texture \(key) size: \(texture.size()) at cost: \(cost/Double(1000000))")
        cache.setObject(texture, forKey: key as NSString, cost: cost)
    }
    
    // Adds an image to the cache with a key.
    public func add(_ image: UIImage, forKey key: String) {
        add(SKTexture(image: image), forKey: key, cost: image.memorySize)
    }
    
    public subscript(key: String) -> SKTexture? {
        // Returns a cached texture if available.
        get {
            return cache.object(forKey: key as NSString)
        }
    }
    
    // MARK: NSCacheDelegate
    public func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        NSLog("TextureCache evicted: \(obj)")
    }
}
