# Using this template

## Folder struture

The *package* folder is for the final build of the .sigmapackage, which is the distribution file used for installing EG Sigma Apps.

The *src* folder is for all source files, e.i. .pas files and resources such as .png files, etc. Remember that the main pas file must have af filename starting with !!, ffor example !!myapp.pas

The *ps* folder are PowerShell scripts, used by the bat files in the root folder.

The root folder:
- build.bat: Will build the .sigmapackage in the *package* folder. The build process expects "C:\Program Files\7-Zip\7z.exe" to be available. Please adjust to use other zip tools.
- buildAndUploadBeta.bat: Will also build, but in addition upload to an ftp server, defined in config.json
- buildAndUploadRelease.bat: Will also build, but in addition upload to an ftp server, defined in config.json
- bumpBuild.bat: Will increase the 1.0.X.0 in the version number, in both the .sigmabundleproj file and the install.xml file (located in the *package* folder)
- bumpMinor.bat: Will increase the 1.X.0.0 in the version number (and reset build to 0), in both the .sigmabundleproj file and the install.xml file (located in the *package* folder)
- config.json: Contains basic info about the app, such a productkey, name, description, folders, etc.
- myapp.sigmabundleproj file: This file is used to builda .sigmabundle file, which contains the app source code and resources. This build proces requires EG Sigma. Drag the .sigmabundleproj file into EG Sigma to edit and build the .sigmabundle file. The .sigmabundle file should be saved in the *package* folder and referenced in the install.xml file. It is recommened to rename the myapp.sigmabundleproj file (also update config.json).

## Developer keys, productkeys, etc

To obtain keys for developing and for products, please contact EG Support.

## Steps for creating and deploying an app

First go through all the files in this template, and adjust.

When editing of an app is done:
1. Adjust version by using the bumpMinor or bumpBuild (or manually adjust in myapp.sigmabundleproj and install.xml files)
2. Drag the myapp.sigmabundleproj file into EG Sigmaa, go through the wizard. If any new source file should be included, add them in the process and finally build the .sigmabundle file, choose the *packagee * folder as destination
3. Run the build.bat (or one of the other build commands)
4. Find the resulting .sigmapackage file in the *package* folder,  install in EG Sigmaa, and test.

Go to:
https://products.sigmaestimates.com/
to submit the app for deployment in the store, and for existing subscribers.