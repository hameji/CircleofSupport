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
    
    // MARK: - Program Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func makePDFView() {
        let pdfView = PDFView(frame: self.view.frame)
        guard let pdfURL = URL(string: url) else {
            // todo: url is invalid
            return
        }

        let document = PDFDocument(url: pdfURL) {
            
        }
        pdfView.document = document
        pdfView.backgroundColor = .lightGray
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        
        self.view.addSubview(pdfView)
    }
}

extension PdfViewController: PDFDocumentDelegate {
    
}
