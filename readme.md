# Keyword Searches In Safari
-----------------------
[![App Store Button](https://raw.githubusercontent.com/EddieCameron/keyword-searches-in-safari/master/App%20Store/AppStoreButton.svg?sanitized=true)](https://apps.apple.com/us/app/search-key/id1526844137?mt=12)

#### It does it, but in Safari 13+, ala [Omnikey](http://marioestrada.github.io/safari-omnikey/) or the original [Safari keyword search](http://safarikeywordsearch.aurlien.net)

- 🔍 quickly search anywhere from the address bar. e.g: type `w laika` to search Wikipedia
- 📝 customize your keyword searches via the toolbar icon
- 🥡 comes with a couple common searches already enabled: wikipedia(w), duckduckgo(d), google(g)
- 🧊 does this and nothing else

## Caveats!
This uses a pretty hacky workaround to get around Safari's lack of search bar callbacks. It intercepts any address bar search page loading, extracts the search query, and if a keyword is found it will redirect you. I would like to fix these issues some day.
- It can't distinguish between some valid search URL's and those that came from the address bar (eg: if you type your keyword directly into a Google search box, it will redirect you to your keyword search)
- Local (file:///) URLs don't work because of sandboxing

## How to use
- Install .app from app store or download from releases, it will prompt you to open Safari's extension settings where you can enable/disable the extension.
- Click on the toolbar icon to add/remove keywords. When providing search URLs, use `{search}` to mark where the search terms should be inserted (e.g: `https://www.google.com?q={search}`) I would also like to add context menu support eventually

## How to help
I did this very quickly in probably not a great way. I am open to suggestions in Issues.
