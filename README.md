# github-user-search-ios
Github OpenAPI로 사용자를 검색하는 iOS 앱입니다


---
## 개발 stack
- Minimum Target : iOS 13
- Swift
- SPM
    + Then
    + Moya
    + SuperEasyLayout
    + RxSwift
    + NSObject-Rx
    + AlamofireImage
- UI : Code-based


---
## 실행 방법
```bash
cd path_to_project_folder/GithubUserSearch
open GithubUserSearch.xcodeproj
```


---
## 사용한 Extension

- UIScrollView+
```Swift
/**
y 좌표 기준 pagination 필요 여부를 반환

- parameters:
    - preloadingPoint: 1 = frame.size.height, 1.5 = frame.size.height * 1.5
*/
func isNeedPagination(preloadingPoint: CGFloat = 1.5) -> Bool
```

- URL+
```Swift
/**
url에 queryItems를 추가

- parameters:
    - parameters: queryItems에 추가할 dictionary array
*/
func appending(_ parameters: [String: String?]) -> URL
```