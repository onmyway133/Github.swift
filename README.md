# Github.swift

[![CI Status](http://img.shields.io/travis/onmyway133/GithubSwift.svg?style=flat)](https://travis-ci.org/onmyway133/GithubSwift)
[![Version](https://img.shields.io/cocoapods/v/GithubSwift.svg?style=flat)](http://cocoadocs.org/docsets/GithubSwift)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/GithubSwift.svg?style=flat)](http://cocoadocs.org/docsets/GithubSwift)
[![Platform](https://img.shields.io/cocoapods/p/GithubSwift.svg?style=flat)](http://cocoadocs.org/docsets/GithubSwift)

![](Screenshots/Banner.png)

## Description

- A Swift implementation of [octokit.objc](https://github.com/octokit/octokit.objc), using [RxSwift](https://github.com/ReactiveX/RxSwift), [Alamofire](https://github.com/Alamofire/Alamofire) and [Tailor](https://github.com/zenangst/Tailor)
- Try to use more Swift style as possible

## Usage

#### Client

- User: identify a user
- Server: identify server (Github or Github Enterprise)
- Client: make request. If associated with a valid token, it is considered authenticated client

```swift
let _ =
  Client.signInUsingWebBrowser(Server.dotComServer, scopes: [.Repository])
    .flatMap { client in
      return client.fetchUserRepositories()
    }.subscribeNext { repositories in
      repositories.forEach { print($0.name)
    }
  }
```

#### Request Descriptor

Make your own request using `RequestDescriptor`, using syntax from [Construction](https://github.com/onmyway133/Construction)

```swift
let requestDescriptor: RequestDescriptor = construct {
  $0.path = "repos/\(owner)/\(name)"
  $0.etag = "12345"
  $0.offset = 2
  $0.perPage = 50
  $0.parameters["param"] = "value"
  $0.headers["header"] = "value"
  $0.method = .PUT  
}

return enqueue(requestDescriptor).map {
  return Parser.one($0)
}
```

#### Pagination

- The `subscribe` gets called many times if there is pagination

```swift
client
.fetchUserRepositories()
.subscribeNext { repositories in
  // This gets called many times depending pagination
  repositories.forEach { print($0.name)
}
```

- Use `toArray` if we want `subscribe` to be called once with all the values collected

```swift
client
.fetchUserRepositories()
.toArray()
.subscribeNext { repositories: [[Repository]] in
  repositories.flatMap({$0}).forEach { print($0.name)
}
```

## Features

#### Metadata

- Fetch server metadata

#### Sign in

- Native flow
- OAuth flow

#### User

- Follow
- Unfollow
- Fetch user info

#### Repository

- Fetch repositories
- Create repository
- Fetch commits
- Fetch pull requests
- Fetch issues
- Watch

#### Pull request

- Make pull requests

#### Issue

- Create issue
- Fetch issues

#### Organization

- Fetch organizations
- Fetch teams

#### Search

- Search repositories

#### Event

- Fetch user events

#### Gists

- Fetch gists

#### Git

- Create tree
- Create blob
- Create commit

#### Activity

- Star
- Unstar

#### Notification

- Fetch notifications

## Installation

**GithubSwift** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GithubSwift'
```

**GithubSwift** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "onmyway133/Github.swift"
```

## Author

Khoa Pham, onmyway133@gmail.com

## Contributing

We would love you to contribute to **GithubSwift**, check the [CONTRIBUTING](https://github.com/onmyway133/GithubSwift/blob/master/CONTRIBUTING.md) file for more info.

## License

**GithubSwift** is available under the MIT license. See the [LICENSE](https://github.com/onmyway133/GithubSwift/blob/master/LICENSE.md) file for more info.
