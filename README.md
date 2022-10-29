# Flickr Photo App
A photo gallery using Flickr API, with search support and a detail page where the users can take a closer look to the photo.

## Features

- User can view recent photos using Flickr API.
- User can see the details of the searched photo.
- User can see a closer look of that photo.
- Support multiple languages (english and romanian)
- Support dark mode and light mode

## Requirements

- iOS/iPadOS 13.0+
- Swift 5.0

## Supported Platforms
- iPhone (iOS 13.0+)
- iPad (iPados 13.0+)

## How to Build

At first, run the following command in terminal:

```
git clone <#SSH/HTTPS#>
```

Then go to project directory.
```
cd <project's root directory>
```

And then, install dependenies through cocoapod into project:

```
pod install
```

Finally, open ```FlickrPhotoApp.xcworkspace``` file. Build and Run the project. That's it.

## Project Architecture

- Used MVVM archetectural design pattern.
- Also used some other design patterns like ```singleton, protocol etc```.

## Third party libraies

- 'SnapKit', '5.6.0'
- 'SDWebImage', '5.13.4'
- 'MBProgressHUD', '1.2.0'
- 'Alamofire', '5.6.2'
- 'Lightbox', '2.5.0'

## Limitations

- User can't upload and download the images.
- No unit testing added.

## Future Update

- Will add user login/registration option
- Will add image upload feature
- Will add image download feature
- Will add unit testing

## Availability
This app is not in appstore currently but you can take a look the video which is cover all the features. [Watch the video](https://youtu.be/lrLL_HUkk3g)
