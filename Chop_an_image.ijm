// Macro for chopping an image into X x Y tiles, where X and Y are the number of divisions chosen by the user.

//Define number of X and Y tiles

defaultname="num_x";
num_x=getNumber("How many images in X axis?", 0);
defaultname="num_y";
num_y=getNumber("How many images in Y axis?", 0);

//Chop the image in X and Y tiles

id = getImageID(); 
title = getTitle(); 
getLocationAndSize(locX, locY, sizeW, sizeH); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width / num_x; 
tileHeight = height / num_y; 
for (y = 0; y < num_y; y++) { 
offsetY = y * height / num_y; 
 for (x = 0; x < num_x; x++) { 
offsetX = x * width / num_x; 
selectImage(id); 
 call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
tileTitle = title + " [" + x + "," + y + "]"; 
 run("Duplicate...", "title=");
makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
 run("Crop"); 
} 
}

//Close the unchopped image

close(title);

//Select the destination Directory and save all the chopped tiles one by one

dir1 = getDirectory("Choose Destination Directory");
for (i=0;i<num_x*num_y;i++) {
        selectImage(i+1);
        saveAs("tiff", dir1 + "chop_" + i+1);
}

run("Close All");