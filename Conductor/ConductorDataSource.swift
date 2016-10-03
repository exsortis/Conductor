//
//  IntroductionDataSource.swift
//  CharacterAdvisor
//
//  Created by Paul Schifferer on 7/4/16.
//  Copyright © 2016 Pilgrimage Software. All rights reserved.
//

import UIKit


/**
 * Canonical data source for a conductor view. You can make your own, but this one should do everything you need.
 */
open class ConductorDataSource : NSObject, UIPageViewControllerDataSource {

    // MARK: - Properties

    /**
     * Property for accessing page data set during initialization.
     */
    open fileprivate(set) var pageData : [ConductorPageData]

    /**
     * Property to store the starting page of the view.
     */
    open var startingPage : Int = 0

    // MARK: - Initialization

    /**
     * Designated initializer for this data source.
     *
     * - parameter pageData: An array of `ConductorPageData` objects describing each page in the view.
     */
    public required init(pageData : [ConductorPageData]) {
        self.pageData = pageData
    }


    // MARK: - API

    open func viewController(for pageNumber : Int, from storyboard : UIStoryboard) -> UIViewController? {

        if let vc = storyboard.instantiateViewController(withIdentifier: "ConductorPageView") as? ConductorPageViewController {
            vc.pageNumber = pageNumber

            var pageData = self.pageData[pageNumber]

            if pageNumber == self.pageData.count - 1 {
                // last page
                pageData.hideSkipButton = true
            }
            else {
                // not the last page
                pageData.advanceText = nil
            }

            vc.pageData = pageData

            return vc
        }

        return nil
    }


    // MARK: - Page view controller data source methods

    @objc open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if let ivc = viewController as? ConductorPageViewController {
            let pageNumber = ivc.pageNumber

            if pageNumber > 0 {
                return self.viewController(for: pageNumber - 1, from: viewController.storyboard!)
            }
        }

        return nil
    }

    @objc open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if let ivc = viewController as? ConductorPageViewController {
            let pageNumber = ivc.pageNumber

            if pageNumber < pageData.count - 1 {
                return self.viewController(for: pageNumber + 1, from: viewController.storyboard!)
            }
        }

        return nil
    }

    open func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageData.count
    }
    
    open func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return startingPage
    }
    
}
