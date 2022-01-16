<div id="top"></div>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/ericdke/MovieNut">
    <img src="images/movienut_rounded.png" alt="Logo" width="128" height="128">
  </a>

<h3 align="center">MovieNut</h3>

  <p align="center">
    An iOS application for posting movie reviews to Pnut.io
    <br />
  </p>
</div>

<!-- ABOUT THE PROJECT -->
## About The Project

[![MovieNut][product-screenshot]](https://example.com)

In the beginning, MovieNut was a CLI utility born during a [Pnut.io](https://pnut.io/) hackathon. 

I wanted to quickly code something that would find a movie by its title, accept a review, and send the whole thing as a formatted post to Pnut.

Then I made an [Android version](https://pnut.io/apps/id/cm-Jnn2MRXyLpKDJ7RE0OWE49MBCGu4H) because I wanted to learn Kotlin. It's not great, but it works, and I did indeed learn a lot.

Finally, I made an iOS version, entirely in UIKit, that I tried to release but Apple App Review refused to publish it and I didn't want to start a battle with them about this, so I didn't insist and retired this version.

But then I thought: why not make a new version, with SwiftUI this time instead of UIKit; that could be a cool way to improve my SwiftUI skills. And so this new iOS version was born.

It will never be released on the App Store, though - if you want it, build it!

As it was coded hackathon-style, it's far from perfect, UI-wise and code-wise. Contributions, fixes, requests, bug reports, are welcome. :)


### Made With

Xcode 12, Swift, SwiftUI, and bits of UIKit


### Instructions

Create a new Xcode project with Swift selected as language. 

Clone the repo into the project.

Add a `MovieNut/Constants/Credentials.swift` file containing this:

```swift
enum Credentials {
    static let tmdbAPIKey = "your TMDB api key"
    static let clientId = "your PNUT client id"
}
```

Grab an API key from the tmdb site and a dev client id on Pnut (both free).

You're ready to go! Build and install on your iOS device.


<!-- LICENSE -->
## License

See `LICENSE.md` for more information.


<!-- CONTACT -->
## Contact

Pnut    - [@ericd](https://pnut.io/@ericd)

Twitter - [@ritsz](https://twitter.com/twitter_handle)

[product-screenshot]: /images/mnios.jpg