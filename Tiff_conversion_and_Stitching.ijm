//Macro for the automatization of Tiff conversion of indidual Tiles and posterior stitching
// Coded by the Basque Resource for Advanced Light Microscopy (BRALM).


// ************ Start ************ //


//Close everything to start

run("Close All");

//Select the directory, open the image sequence and read the Title of the resulting image

dir0 = getDirectory("Choose the Directory of the images to process");
File.openSequence(dir0);
title = getTitle();

//Define the Number of Channels, Z-Stacks and Tiles

defaultname="num_channels";
num_channels=getNumber("How many Channels?", 0);
defaultname="num_Z";
num_Z=getNumber("How many Z-Stacks?", 0);
defaultname="num_tiles";
num_tiles=getNumber("How many Tiles?", 0);

// Convert the image to Number of Channels, Z-Stacks and Tiles defined previously

run("Properties...", "channels=num_channels slices=num_Z frames=num_tiles");

//Read the Title of the image to split

title = getTitle();

//Split the image into the number of tiles indicated before 

run("Stack Splitter", "number=num_tiles");

//Close the unsplitted image

close(title);

//Select the destination Directory and save all the corrected tiles one by one

dir1 = getDirectory("Choose Destination Directory");
for (i=0;i<num_tiles;i++) {
        selectImage(i+1);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        saveAs("tiff", dir1 + "tile_" + i+1);
}

//Close everything

run("Close All");

//Run the Stitching plugin (The parameters should be introduced by hand in the plugin GUI)

run("Grid/Collection stitching");

//Convert the image to the Number of Channels indicated before

run("Properties...", "channels=num_channels slices=num_Z frames=1");

//Save the final stitched and corrected image

saveAs("tiff", dir1 + "Stitched");