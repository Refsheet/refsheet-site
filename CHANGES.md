# TDB

## Active Projects

- Moving old JavaScript to new bundle, which is honestly a huge refactor but it had to be done.

## Known Bugs

- Some cases of the attributes panel fail to render, but I don't have enough data to reproduce.

## TODO

- V2 gallery module doesn't show anything when there is nothing to show.
- V1 Character pages don't have loading shadow anymore
- User profiles don't render loading spinner anymore

## Bug Fixes

- Fixed a bug where conversations couldn't open when you clicked them.
- Fixed some pages causing an "Aw, Snap!" error in Chrome. Hopefully.
- Fixed the Discord link in the page footer.
- Fixed the tooltip on the swatch bar, so hovering a color shows you the name and hex code again!

## Major Things

- V1 character galleries now use the V2 image gallery component. For now, the top-3 feature is removed,
  but the images will now auto-update when processing is done.
- Text modules in V1 profiles now use the V2 profile widget, kinda. This means you get the fun markdown editor.

# Framework

- Expanded automated testing to cover more areas of the site, hopefully preventing more bugs from happening.
- Temporarily removed bug reporting and logging to save costs. This will be re-enabled when Patreon reaches about
  $1200/mo or so.


# 03/08/2020

## Active Projects

- V2 Profiles
- V2 Forums

## New Bugs

- V2 richtext entry doesn't work due to changed interface to that component
- Possible bug in registration form conflicting with login form
- Change email / patreon link auth addresses have the wrong email in the URL >:U

## Bug Fixes

- Fixed an issue where streaming notifications wouldn't authorize even though a user is signed in
- Fixed notification menu not doing anything when you click on an item

## Major Things

- Speed improvement when loading lists of users, mostly in the forums ($-)

## Minor Things

- Notifications menu is now available for all users ($+)
- Introduced validation structure to frontend to show errors before submitting some forms
- Introduced policy structure to frontend to easily control who is allowed to do what

## WIPs

- V2 profile work continues, now with Settings, Delete and Transfer forms ($++)
- V2 forum work continues, with a "create discussion" view working and several other views ($+)
- V2 forums now support search and sort!

## Framework

- Improved metric reporting and image server scaling based on queue size, not CPU usage ($--)
- Implemented some metrics on request duration to identify slow queries and speed up the site ($+++)


# 01/20/20

Focus for this period has been the new public API, another round of updates to get V2 profiles closer to completion,
and more work on the V2 Forums. I'm introducing an "Active Projects" section to the changelog, mostly so I can make
sure it doesn't get too bloated:

## Active Projects

- Public API
- V2 Profiles
- V2 Forums

## Bug Fixes

- Fixed character color scheme creation and editing on V1 profiles
- Fixed an issue causing User pages to not render if characters have a color scheme
- Fixed redirects after login if a login was requested to access a certain page
- Minor improvement on 500 error page to vertically center
- Fixed an issue where translations weren't loading after new keys were added
- Added Watermark option back to the image settings
- Language settings in the footer now apply without reloading the page

## Major Things

- Added revision history tracker to all characters
- Replaced the markdown editor with React-MDE, which is actually maintained and should work on mobile
- The [privacy policy](https://refsheet.net/privacy) has been updated to clarify our data usage

## Minor Things

- Added image crop priority to image settings
- Added several more tests to ensure site features don't accidentally break

## WIPs

- Added a first draft of the public API + Documentation
- Added revision history (view only) to V2 profiles
- Added character settings (view only) to V2 profiles
- Added new color scheme tool (draft) to V2 profiles
- Added the reply box UI to V2 forums

## Framework

- Implemented a better role system to allow for more scalable authorization
- Another Rails upgrade, we're just about ready to upgrade from 5.2 to 6.0
- Added GZip compression to assets, which should speed up site loading time
- Configured webpack to emit styles and process SASS, which will allow styles to move to V2 bundle
- Upgraded React to 16.12.0
- Upgraded react-materialize to remove duplicate react requirement
- Found a workaround for matching image similarity, so image matching can continue


# 01/02/20

Wrapping up the round of minor improvements and other Fun Things(tm).

## Bug Fixes

- Fixed input boxes on character profiles (color and size)
- Fixed checkboxes on most* of the site
- Fixed upload button in the avatar/header image select box
- Fixed an issue with concurrent image uploads sometimes failing to initialize sort order and crashing
- Fixed an issue loading image comments when a page was not specified
- Fixed an issue loading suggested users to follow (introduced in Rails 5.2)
- Fixed character profile URLs to always generate even if somehow the name was blank or had non-url-able characters

## Major Things

- Style change for mobile navbar, fixed several broken navbar things on mobile
- The new image lightbox now works on mobile devices, too

## Minor Things

- Added some warnings when trying to upload images without selecting a character
- Reintroduced formatting for image descriptions (though hashtags can't link as a result)
- Added Watermark option back to images
- Fixed the spacing between lightbox close button and the lightbox itself to prevent overlap

## WIPs

- More cleanup work on preparing V2 of the Forums [Preview Here](https://refsheet.net/v2/forums)

## Framework

- Image processing now takes priority over every other background job, which fixes the issue where images would
  get stuck behind email sending, geocoding, etc.


# 12/28/19

Core update to Rails, bringing us to current. Several security fixes and minor bugfixes from the lightbox release.

## Bug Fixes

- Source URL field is back in the image settings
- Components which are in development will now be hidden on production servers

## Minor Things

- No more pumpkins :(
- Adjusted font weights on navbar to be slightly more legible

## WIPs

- Back-end code for the Artist profiles is being deployed with this change

## Framework

- Updated Rails from 5.0 to 5.2
- Fixed several issues with our automated testing
- Started migrating to Active Storage for saving images


# 12/26/19

Several bug fixes, an update to the Materialize framework, and upload anywhere + new lightbox.

## Bug Fixes

- Fixed "Important Notes" getting stuck when you enter only spaces
- Fixed drag and drop so it doesn't trigger the upload popup

## New Features

- Both V1 and V2 profiles use the new uploader for images
- The new uploader is available anywhere, just drag and drop!
- New lightbox for all image views, including timeline
- Back/forward navigation in the lightbox

## Minor Things

- Added more translations throughout the app
- Images now crop to the top, not the center, by default

## Framework

- Added Prettier to clean up Javascript and maintain a standard style
- Updated Materialize to 1.0.0 (which might break old V1 code)
- Tighter integration with the Apollo / GraphQL cache for more dynamic page updates
- Added React component `compose()` helper to encourage state / HOC bindings