//
//  Untitled.swift
//  ImageFeed
//
//  Created by Максим Карпов on 16.12.2024.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?

    var loadRequestCalled: Bool = false

    func load(request: URLRequest) {
        loadRequestCalled = true
    }

    func setProgressValue(_ newValue: Float) {

    }

    func setProgressHidden(_ isHidden: Bool) {

    }
}
