//
//  RssTitlePresenter.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit

class RssTitlePresenter: NSObject {

    // MARK: - vars & lets
    private let locationManager = LocationManager()
    private let rssFirestoreDao = RssFirestoreDao()
    weak var rssTitleView: RssTitleDelegate?
    var placemark: Placemark!
    var currentFeedUrl: String = ""
    var feedItems: [FeedItem] = []
    var elementName: String!
    var parser: XMLParser!

    let ITEM_ELEMENT_NAME = "item"
    let TITLE_ELEMENT_NAME = "title"
    let LINK_ELEMENT_NAME = "link"
    let DATE_ELEMENT_NAME = "pubDate"

    // MARK: - Program lifecycle
    func viewDidLoad(segment: Int) {
        changedSegment(segment: 0)
    }
    
    func viewWillAppear(segment: Int) {
        checkGPSStatus()
    }
    
    // MARK: - RssFirestoreDao
    func downloadRssURL(category: String, authority: String) {
        // todo: startHUD
        rssFirestoreDao.fetchRssUrl(category: category, authority: authority) { result in
            // todo: stopHUD
            guard case .success(let data) = result else {
                print(result as! Error)
                return
            }
            guard let url = data else {
                print(" ... url is invalid")
                return
            }
            self.currentFeedUrl = url
            self.startParser()
        }
    }
    
    func startParser() {
        guard let feedURL = URL(string: self.currentFeedUrl) else {
            // alertURL ivalid
            return
        }
        self.parser = XMLParser(contentsOf: feedURL)
        self.parser.delegate = self
        self.parser.parse()
    }

    // MARK: - LocationManager
    func checkGPSStatus() {
        let status = locationManager.checkAuthorization()
        switch status {
        case .always:
            fallthrough
        case .whenInUse:
            startGPS()
        case .denied, .restricted:
            break
        case .notDetermined:
            locationManager.askAuthorization()
        }
    }
    
    func startGPS() {
        locationManager.startUpdatingLocation { result in
            self.locationManager.stopUpdatingLocation()
            guard case .success(let locations) = result else {
                print(" ... failed to get location")
                return
            }
            guard let location = locations.first else {
                print(" ... location is nil(invalid)")
                return
            }
            self.locationManager.gpsToAddress(location: location) { result in
                guard case .success(let placemark) = result else {
                    return
                }
                guard let cPlacemark = placemark, let _ = cPlacemark.address else {
                    return
                }
                self.placemark = cPlacemark
            }
        }

    }

    // MARK: - Segment Func
    func changedSegment(segment: Int) {
        var category = ""
        var authority = ""
        switch segment {
        case 0:
            category = "日本"
            authority = "内閣府"
        case 1:
            category = "気象庁"
            authority = "新着情報"
        case 2:
            guard let prefecture = self.placemark.administrativeArea else {
                return
            }
            category = prefecture
            category = ""
        case 3:
            guard let prefecture = self.placemark.administrativeArea, let city = self.placemark.locality else {
                return
            }
            category = prefecture
            category = city
        default: break
        }
        downloadRssURL(category:  category, authority: authority)
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        self.rssTitleView?.segueToDetail(indexPath: indexPath)
    }
    
    // MARK: - TableView Func
    func numberOfRowsInSection(section: Int) -> Int {
        return self.feedItems.count
    }

    func cellForRowAt(indexPath: IndexPath) -> FeedItem {
        return self.feedItems[indexPath.row]
    }

}

// MARK: - XMLParserDelegate
extension RssTitlePresenter: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = nil
        if elementName == ITEM_ELEMENT_NAME {
            self.feedItems.append(FeedItem())
        } else {
            self.elementName = elementName
        }

    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.feedItems.count > 0 {
            let lastItem = self.feedItems[self.feedItems.count - 1]
            switch self.elementName {
            case TITLE_ELEMENT_NAME:
                let tmpString = lastItem.title
                lastItem.title = (tmpString != nil) ? tmpString! + string : string
            case DATE_ELEMENT_NAME:
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "EEE,dd MMM yyyy HH:mm:ss ZZZZ"
                    
                let r_date = dateFormatter.date(from: string)
                if let d = r_date {
                    // ロケールを日本語にして曜日を取得
                    dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
                    dateFormatter.dateFormat = "yyyy年MM月dd日(E)"
                    lastItem.date = dateFormatter.string(from: d)
                } else {
                    print("型が一致しません。")
                }
            case LINK_ELEMENT_NAME:
                lastItem.url = string
            default: break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.elementName = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.rssTitleView?.reloadTableView()
    }
}
