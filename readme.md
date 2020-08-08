# Keyword Searches In Safari
-----------------------

#### It does that, but in Safari 13+, ala [Omnikey](http://marioestrada.github.io/safari-omnikey/) or the original [Safari keyword search](http://safarikeywordsearch.aurlien.net)

## Caveats!
This uses a pretty hacky workaround to get around Safari's lack of search bar callbacks. It intercepts any Google page loading, extracts the search query, and if a keyword is found it will redirect you. I would like to fix these issues some day.
- Currently only works if you have Google set as your default search
- It will try to run on any URL that has both "Google" and a "q" query parameter (eg: if you type your keyword directly into a Google search box, it will redirect you to your keyword search)
- Local (file:///) URLs don't work

## How to use
- Install .app from releases or source, it will prompt you to open Safari's extension settings where you can enable/disable the extension.
- Click on the toolbar icon to add/remove keywords. When providing search URLs, use `{search}` to mark where the search terms should be inserted (e.g: `https://www.google.com?q={search}`) I would also like to add context menu support eventually
