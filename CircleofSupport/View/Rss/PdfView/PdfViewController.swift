//
//  RssContentViewController.swift
//  CircleofSupport
//
//  Created by Hajime Taniguchi on 2019/11/01.
//  Copyright © 2019 Hajime Taniguchi. All rights reserved.
//

import UIKit
import PDFKit

class PdfViewController: UIViewController  {

    var url: String!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pdfView: PDFView!
    
    private let pdfPresenter = PdfPresenter()
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pdfPresenter.pdfView = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setPDFContent(url: url)
    }
    
    func setPDFContent(url: String) {
        self.activityIndicator.startAnimating()
        guard let pdfURL = URL(string: url) else {
            self.pdfPresenter.urlisNil()
            // todo: url is invalid
            return
        }
        guard let document = PDFDocument(url: pdfURL) else {
            self.pdfPresenter.documentisNil()
            return
        }
        pdfView.document = document
        pdfView.backgroundColor = .lightGray
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        activityIndicator.stopAnimating()
    }
}

extension PdfViewController: PdfDelegate {
    func alertInvalidUrl() {
        let alert = UIAlertController(title: "Urlが正しくありませんでした。", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertInvalidDocument() {
        let alert = UIAlertController(title: "Urlはpdfではありませんでした。", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "はい", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }

    func startIndicator() {
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
    }
    
    func stopIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0.0
    }
}
