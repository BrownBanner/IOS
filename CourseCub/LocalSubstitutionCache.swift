//
//  LocalSubstitutionCache.swift
//  WebView
//
//  Created by Hariharan Krishnaswamy on 3/5/15.
//  Copyright (c) 2015 codecamp101. All rights reserved.
//

import Foundation

class LocalSubstitutionCache: NSURLCache {
    
    let cachedResponses: NSMutableDictionary = NSMutableDictionary()
    
    func substituteString() -> NSDictionary {
        return ["/idp/css/shib.css":"shib.css"]
    }
    
    func mimeTypeForPath(originalPath: NSString) -> NSString {
        return "text/css"
    }
    
    override func cachedResponseForRequest(request: NSURLRequest) -> NSCachedURLResponse? {
        
        let subs = ["https://sso.cis-qas.brown.edu/idp/css/shib.css":"shib.css"]
        var pathString: NSString = request.URL!.absoluteString!
        
        
        if pathString != "https://sso.cis-qas.brown.edu/idp/css/shib.css" {
            return super.cachedResponseForRequest(request)
        }
        
        let substitutionFileName: NSString = subs[pathString as String]!
        
        if substitutionFileName.length == 0 {
            return super.cachedResponseForRequest(request)
        }
        
        
        //var cachedResponse: NSCachedURLResponse? = (cachedResponses.valueForKey(pathString) as NSCachedURLResponse)
        
        var cachedResponse: NSCachedURLResponse? = NSCachedURLResponse()
        
        /*if cachedResponse != nil {
        println("cachedResponse is not nil")
        
        return (cachedResponse as NSCachedURLResponse?)
        }*/
        
        
        let substitutionFilePath: NSString = NSBundle.mainBundle().pathForResource(substitutionFileName.stringByDeletingPathExtension, ofType: substitutionFileName.pathExtension)!
        
        println(substitutionFilePath)
        
        assert(substitutionFilePath.length != 0, "File path Doesn't Exist")
        
        let data: NSData = (NSData.dataWithContentsOfMappedFile(substitutionFilePath as String) as! NSData)
        
        let response: NSURLResponse = NSURLResponse.self.init(URL: request.URL!,MIMEType: mimeTypeForPath(pathString) as String,expectedContentLength: data.length,textEncodingName: nil)
        cachedResponse = NSCachedURLResponse.self.init(response: response,data: data)
        
        if (cachedResponses.count == 0) {
            cachedResponses.setValue(cachedResponse, forKey: pathString as String)
        }
        
        return cachedResponse
    }
    
    
    
}