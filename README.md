# best_buy_api_sample
This is a prototype app used to search for lighting products at nearby best buy locations

## Features
- google authentication
- display all lighting products avaialable through Best Buy website
- products are cached locally, until refreshed on pulldown
- show stores within a mile radius that have chosen product in stock
- store shopping cart data in Core data
- image caching with KingFisher library

## TODO
- core data and user defaults are set app wide, not for individual user
- allow for dynamic entry of zip codes for storesApi
- search for stores using user coordinates
- change user flow as to get user location/zip upon login instead of upon searching for stores
  - this will allow for the lightingProductApi to fetch only products that are available in selected region
  
