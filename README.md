# TOUREASE

TourEase is a mobile app which assist tourists to get a maximum experience in their Sri Lankan visit.

Key services we offer:
- Comprehensive information about travel destinations
- Trip Planning feature 
- Weather forecast

Mobile Application powered by firebase cloud services and designed in a way where users can get a seamless travel experience.

## PROBLEM STATEMENT

Process of planning and navigating trips to explore Sri Lanka currently causes significant challenges for tourists.

- Low information on destinations
- Inefficient Trip Planning
- Weather Uncertainty

## SOLUTION : Tour assisting mobile application

- Store popular cities and travel destinations with details about each place.
- Integrate google map with application to show possible travel routes.
- Integrate weather APIs to provide weather predications of user selected places.

## ARCHITECTURE

![image](https://github.com/Maneesha-Rupasinghe/tourease_new/assets/113690953/07a3e8d9-6123-4fec-8941-a6becd403a56)

## TECHNOLOGIES

![image](https://github.com/Maneesha-Rupasinghe/tourease_new/assets/113690953/f989d6d0-45cb-4905-b6e2-d67fffde463e)

## IMPLEMENTATION

![image](https://github.com/Maneesha-Rupasinghe/tourease_new/assets/113690953/ae77f384-40ef-48aa-a818-d7166591175a)

![image](https://github.com/Maneesha-Rupasinghe/tourease_new/assets/113690953/838f990b-c22e-4331-b4d4-b3784d2e4a16)

- For each city, we create a firebase collection and popular destinations related to that city are stored in that collection. We load data to above 2 pages from firebase storage after validating the input that user entered through search bar related to city.
- Need to improve this UI

  ![image](https://github.com/Maneesha-Rupasinghe/tourease_new/assets/113690953/d347a7cc-e22a-44ee-bc50-a6b728815f53)

## FUTURE IMPROVEMENTS

- Expand the database and add more travel destinations
- Update location information and weather forecast real time
- AR - enable a more interactive and informative explore of Sri Lanka using Augmented Reality
- Hotel reservations : Implement a hotel booking system within the app. Allows users to book accommodations, transportation, and guided tours

## CONCLUSION

TourEase, a travel assisting mobile application designed for tourists visiting Sri Lanka, successfully addresses common challenges through features such as comprehensive destination information, efficient trip planning, accurate weather forecasts, city-based search, and user-centric design, aiming to enhance the overall tourist experience and contribute to Sri Lanka's tourism industry.

## REFERENCES

- [Google Maps platform documentation | distance matrix API | google for developers](https://developers.google.com/maps/documentation/distance-matrix)
- [Firebase documentation](https://firebase.google.com/docs?gad_source=1&gclid=Cj0KCQjwhfipBhCqARIsAH9msbmkgMxMqgOAOAOxwVFkG8xGzKekg32o-9PRn1L83NNgO_4S2xtHyoAaAnJhEALw_wcB&gclsrc=aw.ds )
- [Flutter](https://docs.flutter.dev/get-started/install?gclid=Cj0KCQjwhfipBhCqARIsAH9msbkTw4BWhr6LnExJYRx8qR5WMKMKjB_uTiJn0OHFwPwejNZibJ9rlpgaAvYNEALw_wcB&gclsrc=aw.ds)
- [Google_maps_flutter: Flutter Package](https://pub.dev/packages/google_maps_flutter )
- [Google Map API](https://developers.google.com/maps/documentation/routes/opt-way)
