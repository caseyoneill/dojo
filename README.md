<h3 align="center">
  <a href="https://github.com/fastlane/fastlane">
    <img src="assets/fastlane.png" width="150" />
    <br />
    fastlane
  </a>
</h3>
<p align="center">
  <a href="https://github.com/fastlane/deliver">deliver</a> &bull; 
  <a href="https://github.com/fastlane/snapshot">snapshot</a> &bull; 
  <a href="https://github.com/fastlane/frameit">frameit</a> &bull; 
  <a href="https://github.com/fastlane/PEM">PEM</a> &bull; 
  <a href="https://github.com/fastlane/sigh">sigh</a> &bull; 
  <a href="https://github.com/fastlane/produce">produce</a> &bull;
  <a href="https://github.com/fastlane/cert">cert</a> &bull;
  <a href="https://github.com/fastlane/spaceship">spaceship</a> &bull;
  <a href="https://github.com/fastlane/pilot">pilot</a> &bull;
  <a href="https://github.com/fastlane/boarding">boarding</a> &bull;
  <b>dojo</b> &bull;
  <a href="https://github.com/fastlane/scan">scan</a>
</p>
-------

<p align="center">
  <img src="assets/gym.png" height="110">
</p>

dojo
============

[![Twitter: @KauseFx](https://img.shields.io/badge/contact-@KrauseFx-blue.svg?style=flat)](https://twitter.com/KrauseFx)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/fastlane/dojo/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/gym.svg?style=flat)](http://rubygems.org/gems/dojo)
[![Build Status](https://img.shields.io/travis/fastlane/dojo/master.svg?style=flat)](https://travis-ci.org/fastlane/dojo)

###### Building your app has never been easier

Get in contact with the developer on Twitter: [@KrauseFx](https://twitter.com/KrauseFx)

-------
<p align="center">
    <a href="#whats-dojo">Features</a> &bull; 
    <a href="#installation">Installation</a> &bull; 
    <a href="#usage">Usage</a> &bull; 
    <a href="#tips">Tips</a> &bull; 
    <a href="#need-help">Need help?</a>
</p>

-------

<h5 align="center"><code>dojo</code> is part of <a href="https://fastlane.tools">fastlane</a>: connect all deployment tools into one streamlined workflow.</h5>

# What's dojo?

`dojo` builds and packages Android apps for you. It takes care of all the heavy lifting and makes it super easy to generate a signed `apk` file :muscle:

`dojo` is a replacement for [shenzhen](https://github.com/nomad/shenzhen).

### Before `dojo`

```
xcodebuild clean archive -archivePath build/MyApp \
                         -scheme MyApp
xcodebuild -exportArchive \
           -exportFormat ipa \
           -archivePath "build/MyApp.xcarchive" \
           -exportPath "build/MyApp.ipa" \
           -exportProvisioningProfile "ProvisioningProfileName" 
```

### With `dojo`

```
dojo
```

### Why `dojo`?

`dojo` uses the latest APIs to build and sign your application which results in much faster build times.

              |  Dojo Features
--------------------------|------------------------------------------------------------
:rocket:            | `dojo` builds 30% faster than other build tools like [shenzhen](https://github.com/nomad/shenzhen)
:checkered_flag: | Beautiful inline build output
:book:     | Helps you resolve common build errors like code signing issues
:mountain_cableway: | Sensible defaults: Automatically detect the project, its schemes and more
:link:  | Works perfectly with [fastlane](https://fastlane.tools) and other tools
:package: | Automatically generates a `apk` file
:bullettrain_side: | Don't remember any complicated build commands, just `dojo`
:wrench:  | Easy and dynamic configuration using parameters and environment variables
:floppy_disk:   | Store common build settings in a `Dojofile` 
:outbox_tray: | All archives are stored and accessible in the Xcode Organizer
:computer: | Supports Android applications

![/assets/gymScreenshot.png](/assets/gymScreenshot.png)

-----

![/assets/gym.gif](/assets/gym.gif)

# Installation

    sudo gem install dojo

Make sure, you have the latest version of the Xcode command line tools installed:

    xcode-select --install

# Usage

    dojo

That's all you need to build your application. If you want more control, here are some available parameters:

    dojo --workspace "Example.xcworkspace" --scheme "AppName" --clean

If you need to use a different xcode install, use xcode-select or define DEVELOPER_DIR:

    DEVELOPER_DIR="/Applications/Xcode6.2.app" dojo

For a list of all available parameters use

    dojo --help

If you run into any issues, use the `verbose` mode to get more information

    dojo --verbose

In general, if you run into issues while exporting the archive, try using:

    dojo --use_legacy_build_api true

Set the right export method if you're not uploading to App Store or TestFlight:

    dojo --export_method ad-hoc

To pass boolean parameters make sure to use `dojo` like this:

    dojo --include_bitcode true --include_symbols false

To access the raw `xcodebuild` output open `~/Library/Logs/dojo`

# Dojofile

Since you might want to manually trigger a new build but don't want to specify all the parameters every time, you can store your defaults in a so called `Dojofile`.

Run `dojo init` to create a new configuration file. Example:

```ruby
scheme "Example"

sdk "iphoneos9.0"

clean true

output_directory "./build"    # store the ipa in this folder
output_name "MyApp"           # the name of the ipa file
```

# Automating the whole process

`dojo` works great together with [fastlane](https://fastlane.tools), which connects all deployment tools into one streamlined workflow. 

Using `fastlane` you can define a configuration like

```ruby
lane :beta do
  xctool
  dojo(scheme: "MyApp")
  crashlytics
end
```

You can then easily switch between the beta provider (e.g. `testflight`, `hockey`, `s3` and more).

For more information visit the [fastlane GitHub page](https://github.com/fastlane/fastlane).

# How does it work?

`dojo` uses the latest APIs to build and sign your application. The 2 main components are 

- `xcodebuild` 
- [xcpretty](https://github.com/supermarin/xcpretty)

When you run `dojo` without the `--silent` mode it will print out every command it executes.

To build the archive `dojo` uses the following command:

```
set -o pipefail && \
xcodebuild -scheme 'Example' \
-project './Example.xcodeproj' \
-configuration 'Release' \
-destination 'generic/platform=iOS' \
-archivePath '/Users/felixkrause/Library/Developer/Xcode/Archives/2015-08-11/ExampleProductName 2015-08-11 18.15.30.xcarchive' \
archive | xcpretty
```

After building the archive it is being checked by `dojo`. If it's valid, it gets packaged up and signed into an `ipa` file.

`dojo` automatically chooses a different packaging method depending on the version of Xcode you're using.

### Xcode 7 and above

```
/usr/bin/xcrun xcodebuild -exportArchive \
-exportOptionsPlist '/tmp/dojo_config_1442852529.plist' \
-archivePath '/Users/fkrause/Library/Developer/Xcode/Archives/2015-09-21/App 2015-09-21 09.21.56.xcarchive' \
-exportPath '/tmp/1442852529'
```

`dojo` makes use of the new Xcode 7 API which allows us to specify the export options using a `plist` file. You can find more information about the available options by running `xcodebuild --help`.

Using this method there are no workarounds for WatchKit or Swift required, as it uses the same technique Xcode uses when exporting your binary.

### Xcode 6 and below

```
/usr/bin/xcrun /path/to/PackageApplication4Dojo -v \
'/Users/felixkrause/Library/Developer/Xcode/Archives/2015-08-11/ExampleProductName 2015-08-11 18.15.30.xcarchive/Products/Applications/name.app' -o \
'/Users/felixkrause/Library/Developer/Xcode/Archives/2015-08-11/ExampleProductName.ipa' \ 
--sign "identity" --embed "provProfile"
```

Note: the official PackageApplication script is replaced by a custom PackageApplication4Dojo script. This script is obtained by applying a [set of patches](https://github.com/fastlane/dojo/tree/master/lib/assets/package_application_patches) on the fly to fix some known issues in the official Xcode PackageApplication script.

Afterwards the `ipa` file is moved to the output folder. The `dSYM` file is compressed and moved to the output folder as well.

# Tips
## [`fastlane`](https://fastlane.tools) Toolchain

- [`fastlane`](https://fastlane.tools): Connect all deployment tools into one streamlined workflow
- [`deliver`](https://github.com/fastlane/deliver): Upload screenshots, metadata and your app to the App Store
- [`snapshot`](https://github.com/fastlane/snapshot): Automate taking localized screenshots of your iOS app on every device
- [`frameit`](https://github.com/fastlane/frameit): Quickly put your screenshots into the right device frames
- [`PEM`](https://github.com/fastlane/PEM): Automatically generate and renew your push notification profiles
- [`produce`](https://github.com/fastlane/produce): Create new iOS apps on iTunes Connect and Dev Portal using the command line
- [`cert`](https://github.com/fastlane/cert): Automatically create and maintain iOS code signing certificates
- [`spaceship`](https://github.com/fastlane/spaceship): Ruby library to access the Apple Dev Center and iTunes Connect
- [`pilot`](https://github.com/fastlane/pilot): The best way to manage your TestFlight testers and builds from your terminal
- [`boarding`](https://github.com/fastlane/boarding): The easiest way to invite your TestFlight beta testers 
- [`scan`](https://github.com/fastlane/scan): The easiest way to run tests of your iOS and Mac app

##### [Like this tool? Be the first to know about updates and new fastlane tools](https://tinyletter.com/krausefx)

## Use the 'Provisioning Quicklook plugin'
Download and install the [Provisioning Plugin](https://github.com/chockenberry/Provisioning).

# Need help?
Please submit an issue on GitHub and provide information about your setup

# License
This project is licensed under the terms of the MIT license. See the LICENSE file.

> This project and all fastlane tools are in no way affiliated with Apple Inc. This project is open source under the MIT license, which means you have full access to the source code and can modify it to fit your own needs. All fastlane tools run on your own computer or server, so your credentials or other sensitive information will never leave your own computer. You are responsible for how you use fastlane tools.
