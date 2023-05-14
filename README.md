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


---
## 사용한 Protocol

- UserListRepositoryProtocol, UserListUseCaseProtocol
```Swift
// Github API search/Users 호출
// https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-users
func searchUsers(accessToken: String?, query: String, page: Int) -> Observable<SearchUsersResponse>
```

- AuthorizationRepositoryProtocol, AuthorizationUseCaseProtocol
```Swift
// Github API login/oauth/access_token 호출
// https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#2-users-are-redirected-back-to-your-site-by-github

func requestAccessToken(code: String) -> Observable<AccessToken>
```

- AuthorizationViewModel
```Swift
protocol AuthorizationViewModelInput {
    var authorizationUseCase: AuthorizationUseCase { get }
    
    func clearToken()
    func requestAccessToken(_code: String)
    func hasAuthorization() -> Bool
}

protocol AuthorizationViewModelOutput {
    var code: BehaviorRelay<String?> { get }
    var accessToken: BehaviorRelay<String?> { get }
}

typealias AuthorizationViewModelProtocol = AuthorizationViewModelInput & AuthorizationViewModelOutput
```

- UserListViewModel
```Swift
protocol UserListViewModelInput {
    var authorizationViewModel: AuthorizationViewModel { get }
    var useCase: UserListUseCase { get }
    
    func didSearch(string: String)
    func loadNextPage()
    func searchUsers()
}

protocol UserListViewModelOutput {
    var items: BehaviorRelay<[User]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isEmpty: BehaviorRelay<Bool> { get }
    var query: BehaviorRelay<String> { get }
    var isPagingEnded: BehaviorRelay<Bool> { get }
}

typealias UserListViewModelProtocol = UserListViewModelInput & UserListViewModelOutput
```