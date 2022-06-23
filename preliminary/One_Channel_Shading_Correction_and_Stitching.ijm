//Macro for the automatization of the shading/vignetting correction and image stitching with FiJi.
// Coded by the Basque Resource for Advanced Light Microscopy (BRALM).

//Note1: The plugin BaSic should be installed in FiJi.

//Note2: The tile images to process (in *.tif or *.ims format) should be stored in the same directory without other different images on it. 

//Note3: Remember the adquisition parameters of your microscope (row by row, colum by colum, snake mode, ...) to proceed corrcetly with the Stitching.


// ************ Start ************ //


//Close everything to start

run("Close All");

//Select the directory, open the image sequence and read the Title of the resulting image

dir0 = getDirectory("Choose the Directory of the images to process");
File.openSequence(dir0);
title = getTitle();

//Correct the Shading/Vignetting with BaSic plugin//Correct the Shading/Vignetting with BaSic plugin

//To only estimate Flat-field change option: shading_model=[Estimate flat-field only (ignore dark-field)]

run("BaSiC ", "processing_stack=title flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");

//Close the uncorected image and Global Shading
//If only Flat-field is calculated, please comment the close("Dark-field:"+title) line

close(title);
close("Flat-field:"+title);
close("Dark-field:"+title);

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

saveAs("tiff", dir1 + "Stitched_Corrected");
