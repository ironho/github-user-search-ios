//
//  UIScrollView+.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/10.
//

import UIKit

extension UIScrollView {
    
    /**
     - parameters:
        - preloadingPoint: 1 = frame.size.height, 1.5 = frame.size.height * 1.5
     */
    func isNeedPagination(preloadingPoint: CGFloat = 1.5) -> Bool {
       let height: CGFloat = frame.size.height
       let contentHeight: CGFloat = contentSize.height
       let contentOffsetY: CGFloat = contentOffset.y
       let distanceFromBottom: CGFloat = contentHeight - contentOffsetY
       return distanceFromBottom < (height * preloadingPoint)
   }
    
}
