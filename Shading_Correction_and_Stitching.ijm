//Macro for the automatization of the shading/vignetting correction and image stitching with FiJi.
//Coded by the Basque Resource for Advanced Light Microscopy (BRALM).

//Note1: The plugin BaSic should be installed in FiJi.

//Note2: The individual tile images to process (in *.tif or *.ims format) should be stored in the same directory without other different images on it. 

//Note3: Remember the adquisition parameters of your microscope (row by row, colum by colum, snake mode, ...) to proceed corrcetly with the Stitching.


// ************ Start ************ //

//Read me

text0=""
text1="Macro for the automatization of the shading/vignetting correction and image stitching with Fiji/ImageJ.";
text2="Written by the Basque Resource for Advanced Light Microscopy (BRALM) - www.bralm.cf";
text3="The individual tile images to process should be converted to .tiff or .ims format and stored in the same directory without";
text4="any other different images on it.";
text5="The plugin BaSiC should be installed in Fiji via Help > Update > Manage Update Sites";
text6="The macro will ask for the number of channels, number of Z-stacks and number of Tiles of you experiment and also";
text7="for the number of tiles in the X and Y axis and the way the tiles were adquired (row by row, colum by colum, snake mode, ...)";
text8="Be sure that you have all this information to preceed with the execution of this macro";
  
  Dialog.create("");
  Dialog.addMessage(text1);
  Dialog.addMessage(text0);
  Dialog.addMessage(text2);
  Dialog.addMessage(text0);
  Dialog.addMessage(text3);
  Dialog.addMessage(text4);
  Dialog.addMessage(text0);
  Dialog.addMessage(text5);
  Dialog.addMessage(text0);
  Dialog.addMessage(text6);
  Dialog.addMessage(text7);
  Dialog.addMessage(text0);
  Dialog.addMessage(text8);
  Dialog.show();

// Close All warning

text0=""
text1="All your opened images in Fiji will be closed before starting with this Macro";
text2="and not saved modifications will be lost.";
text3="Are you sure you want to continue?";

Dialog.create("");
  Dialog.addMessage(text1);
  Dialog.addMessage(text2);
  Dialog.addMessage(text0);
  Dialog.addMessage(text3);
  Dialog.show();

//Close everything to start

run("Close All");

//Select the directory, open the image sequence and read the Title of the resulting image

Dialog.create("");
text1="Select the folder that contains the separated tile images in .tiff or .ims format";
  Dialog.addMessage(text1);
  Dialog.show();

dir0 = getDirectory("Choose the Directory of the images to process");
File.openSequence(dir0);
title = getTitle();

//Define the Number of Channels, Z-Stacks and Tiles

defaultname="num_channels";
num_channels=getNumber("How many Channels?", 0);

//Break the macro if the number of channls is more than 4
if (num_channels>4) {
	getBoolean("The maximum number of channels is 4", "OK", "Quit");
	 break ;
}
else {

defaultname="num_Z";
num_Z=getNumber("How many Z-Stacks?", 0);
defaultname="num_tiles";
num_tiles=getNumber("How many Tiles?", 0);

//Select Macro for number of Z

if (num_Z<2) {

run("Properties...", "channels=num_channels slices=["+num_tiles*num_Z+"] frames=1");

//Split Channels only if channels > 1

if (num_channels>1) {
	
run("Make Composite", "display=Composite");

run("Split Channels");

titleC1 = "C1-"+title;
titleC2 = "C2-"+title;
titleC3 = "C3-"+title;
titleC4 = "C4-"+title;

}

//For 1 Channel

if (num_channels == 1) {

//Correct the Shading/Vignetting with BaSic plugin

//To only estimate Flat-field change option: shading_model=[Estimate flat-field only (ignore dark-field)]

run("BaSiC ", "processing_stack=title flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");

// Convert the image to Number of Channels, Z-Stacks and Tiles defined previously

run("Properties...", "channels=num_channels slices=num_Z frames=num_tiles") ;

//Close the uncorected image and Global Shading
//If only Flat-field is calculated, please comment the close("Dark-field:"+title) line

close(title);
close("Flat-field:"+title);
close("Dark-field:"+title);

}

//For 2 channels

if (num_channels == 2) {

//Correct the Shading/Vignetting with BaSic plugin & Convert the image to Number of Channels, Z-Stacks and Tiles defined previously
//To only estimate Flat-field change option: shading_model=[Estimate flat-field only (ignore dark-field)]
//If only Flat-field is calculated, please comment the close("Dark-field:"+titleCX) lines

run("BaSiC ", "processing_stack=["+titleC1+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC1);
close("Flat-field:"+titleC1);
close("Dark-field:"+titleC1);

run("BaSiC ", "processing_stack=["+titleC2+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC2);
close("Flat-field:"+titleC2);
close("Dark-field:"+titleC2);

titleCor1 = "Corrected:"+titleC1;
titleCor2 = "Corrected:"+titleC2;

//Merge the 2 Channels

run("Merge Channels...", "c1=["+titleCor1+"] c2=["+titleCor2+"] create");
run("Properties...", "channels=num_channels slices=num_Z frames=num_tiles") ;
run("Make Composite", "display=Composite");

}

//For 3 Channels

if (num_channels == 3) {

//Correct the Shading/Vignetting with BaSic plugin & Convert the image to Number of Channels, Z-Stacks and Tiles defined previously
//To only estimate Flat-field change option: shading_model=[Estimate flat-field only (ignore dark-field)]
//If only Flat-field is calculated, please comment the close("Dark-field:"+titleCX) lines

run("BaSiC ", "processing_stack=["+titleC1+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC1);
close("Flat-field:"+titleC1);
close("Dark-field:"+titleC1);

run("BaSiC ", "processing_stack=["+titleC2+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC2);
close("Flat-field:"+titleC2);
close("Dark-field:"+titleC2);

run("BaSiC ", "processing_stack=["+titleC3+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC3);
close("Flat-field:"+titleC3);
close("Dark-field:"+titleC3);

titleCor1 = "Corrected:"+titleC1;
titleCor2 = "Corrected:"+titleC2;
titleCor3 = "Corrected:"+titleC3;

//Merge the 3 Channels

run("Merge Channels...", "c1=["+titleCor1+"] c2=["+titleCor2+"] c3=["+titleCor3+"] create");
run("Properties...", "channels=num_channels slices=num_Z frames=num_tiles") ;
run("Make Composite", "display=Composite");
}

//For 4 Channels

if (num_channels == 4) {

//Correct the Shading/Vignetting with BaSic plugin & Convert the image to Number of Channels, Z-Stacks and Tiles defined previously
//To only estimate Flat-field change option: shading_model=[Estimate flat-field only (ignore dark-field)]
//If only Flat-field is calculated, please comment the close("Dark-field:"+titleCX) lines

run("BaSiC ", "processing_stack=["+titleC1+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC1);
close("Flat-field:"+titleC1);
close("Dark-field:"+titleC1);

run("BaSiC ", "processing_stack=["+titleC2+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC2);
close("Flat-field:"+titleC2);
close("Dark-field:"+titleC2);

run("BaSiC ", "processing_stack=["+titleC3+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC3);
close("Flat-field:"+titleC3);
close("Dark-field:"+titleC3);

run("BaSiC ", "processing_stack=["+titleC4+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=num_Z frames=num_tiles") ;

close(titleC4);
close("Flat-field:"+titleC4);
close("Dark-field:"+titleC4);
close("Dark-field:"+titleC4);

titleCor1 = "Corrected:"+titleC1;
titleCor2 = "Corrected:"+titleC2;
titleCor3 = "Corrected:"+titleC3;
titleCor4 = "Corrected:"+titleC4;

//Merge the 4 Channels

run("Merge Channels...", "c1=["+titleCor1+"] c2=["+titleCor2+"] c3=["+titleCor3+"] c4=["+titleCor4+"] create");
run("Properties...", "channels=num_channels slices=num_Z frames=num_tiles") ;
run("Make Composite", "display=Composite");
}

//CONTINUATION FOR ALL the IFs

//Read the Title of the image to split

title = getTitle();

//Split the image into the number of tiles indicated before 

run("Stack Splitter", "number=num_tiles");

//Close the unsplitted image

close(title);

Dialog.create("");
text1="Select the folder to save the BaSiC corrected tiles";
  Dialog.addMessage(text1);
  Dialog.show();

//Select the destination Directory and save all the corrected tiles one by one

if (num_channels < 2) {
dir1 = getDirectory("Choose Destination Directory");
for (i=0;i<num_tiles;i++) {
        selectImage(i+1);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        saveAs("tiff", dir1 + "tile_" + i+1);
}
}

else {

if (num_tiles < 10) {
dir1 = getDirectory("Choose Destination Directory");
for (i=1;i<num_tiles+1;i++) {
        selectImage("stk_000"+i+"_"+title);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        run("Make Composite", "display=Composite");
        saveAs("tiff", dir1 + "tile_" + i);
}

}

else {
dir1 = getDirectory("Choose Destination Directory");
for (i=1;i<10;i++) {
        selectImage("stk_000"+i+"_"+title);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        run("Make Composite", "display=Composite");
        saveAs("tiff", dir1 + "tile_" + i);
}        
for (i=10;i<num_tiles+1;i++) {
        selectImage("stk_00"+i+"_"+title);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        run("Make Composite", "display=Composite");
        saveAs("tiff", dir1 + "tile_" + i);
}

}

}
//Close everything

run("Close All");

//Run the Stitching plugin (The parameters should be introduced by hand in the plugin GUI)

Dialog.create("");
text0="";
text1="For the Stitching, first select the way the tiles were adquired (row by row, colum by colum, snake mode, ...) and then, ";
text2="fill out only the number of tiles by X and Y axis, the folder with the BaSiC corrected tiles and the name of your files";
text3="that should be tile_{i}.tif (only one i inside the { } )";
text4="The stitched image will be saved in the same directory named as 'Stitched_Corrected'";
  Dialog.addMessage(text1);
  Dialog.addMessage(text2);
  Dialog.addMessage(text3);
  Dialog.addMessage(text0);
  Dialog.addMessage(text4);
  Dialog.show();

run("Grid/Collection stitching");

//Convert the image to the Number of Channels indicated before

run("Properties...", "channels=num_channels slices=num_Z frames=1");

//Save the final stitched and corrected image

saveAs("tiff", dir1 + "Stitched_Corrected");

}

}

// ******* For more than one Z ******* //

if (num_Z>1) {

text1="Choose the Directory to save the individual tiles";

Dialog.create("");
  Dialog.addMessage(text1);
  Dialog.show();

//Directory to save the separated tiles (with x channels)

dir0 = getDirectory("Choose the Directory to save the individual tiles");

for (i=1;i<num_tiles*num_Z+1;i++) {
        selectWindow(title);
        run("Duplicate...", "duplicate range="+i*num_channels-num_channels+1+"-"+i*num_channels+"");
        saveAs("tiff", dir0 + "z-stack_" + i);
        close();
        print(""+i+"/"+num_tiles*num_Z+"");
}

run("Close All");

//Directory to save the sequence of tiles splitted in y z-stacks (with x channels)

text1="Choose the Directory to save the splitted z-stacks";

Dialog.create("");
  Dialog.addMessage(text1);
  Dialog.show();

dir1 = getDirectory("Choose the Directory to save the splitted z-stacks");

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir0, " filter=z start="+i+" step="+num_Z+"");
        saveAs("tiff", dir1 + "z-stack_" + i);
        close();
        print(""+i+"/"+num_Z+"");
}

run("Close All");

//For 1 Channel

if (num_channels == 1) {
	
for (i=1;i<num_Z+1;i++) {
//       File.openSequence(dir1, " start="+i+" step="+num_Z+"");
		open(""+dir1+"/z-stack_"+i+".tif");
        title = getTitle();

//Correct the Shading/Vignetting with BaSic plugin

//To only estimate Flat-field change option: shading_model=[Estimate flat-field only (ignore dark-field)]

run("BaSiC ", "processing_stack=z-stack_"+i+".tif flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");

// Convert the image to Number of Channels, Z-Stacks and Tiles defined previously

run("Properties...", "channels=num_channels slices=1 frames=num_tiles") ;

//Close the uncorected image and Global Shading
//If only Flat-field is calculated, please comment the close("Dark-field:"+title) line

close(title);
close("Flat-field:"+title);
close("Dark-field:"+title);

}

//Concatenate all the z-stacks into one file

run("Concatenate...", "all_open title=BaSiC_Corrected_Tiles open");
run("Properties...", "channels=num_channels slices=num_tiles frames=num_Z") ;
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");

}

//For 2 Channels

if (num_channels == 2) {

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " start="+i+" step="+num_Z+"");
        title = getTitle();
		run("Properties...", "channels=num_channels slices=num_tiles frames=1");
		run("Make Composite", "display=Composite");
        run("Split Channels");

titleC1 = "C1-"+title;
titleC2 = "C2-"+title;

        run("BaSiC ", "processing_stack=["+titleC1+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC1);
close("Flat-field:"+titleC1);
close("Dark-field:"+titleC1);

run("BaSiC ", "processing_stack=["+titleC2+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC2);
close("Flat-field:"+titleC2);
close("Dark-field:"+titleC2);

titleCor1 = "Corrected:"+titleC1;
titleCor2 = "Corrected:"+titleC2;

//Merge the 2 Channels

run("Merge Channels...", "c1=["+titleCor1+"] c2=["+titleCor2+"] create");
run("Properties...", "channels=num_channels slices=1 frames=num_tiles") ;
run("Make Composite", "display=Composite");
}

run("Concatenate...", "all_open title=BaSiC_Corrected_Tiles open");
run("Properties...", "channels=num_channels slices=num_tiles frames=num_Z") ;
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");

}

//For 3 Channels

if (num_channels == 3) {

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " start="+i+" step="+num_Z+"");
        title = getTitle();
		run("Properties...", "channels=num_channels slices=num_tiles frames=1");
		run("Make Composite", "display=Composite");
        run("Split Channels");

titleC1 = "C1-"+title;
titleC2 = "C2-"+title;
titleC3 = "C3-"+title;

        run("BaSiC ", "processing_stack=["+titleC1+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC1);
close("Flat-field:"+titleC1);
close("Dark-field:"+titleC1);

run("BaSiC ", "processing_stack=["+titleC2+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC2);
close("Flat-field:"+titleC2);
close("Dark-field:"+titleC2);

run("BaSiC ", "processing_stack=["+titleC3+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC3);
close("Flat-field:"+titleC3);
close("Dark-field:"+titleC3);

titleCor1 = "Corrected:"+titleC1;
titleCor2 = "Corrected:"+titleC2;
titleCor3 = "Corrected:"+titleC3;

//Merge the 3 Channels

run("Merge Channels...", "c1=["+titleCor1+"] c2=["+titleCor2+"] c3=["+titleCor3+"] create");
run("Properties...", "channels=num_channels slices=1 frames=num_tiles") ;
run("Make Composite", "display=Composite");
}

run("Concatenate...", "all_open title=BaSiC_Corrected_Tiles open");
run("Properties...", "channels=num_channels slices=num_tiles frames=num_Z") ;
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");

}

//For 4 Channels

if (num_channels == 4) {

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " start="+i+" step="+num_Z+"");
        title = getTitle();
		run("Properties...", "channels=num_channels slices=num_tiles frames=1");
		run("Make Composite", "display=Composite");
        run("Split Channels");

titleC1 = "C1-"+title;
titleC2 = "C2-"+title;
titleC3 = "C3-"+title;
titleC4 = "C4-"+title;

        run("BaSiC ", "processing_stack=["+titleC1+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC1);
close("Flat-field:"+titleC1);
close("Dark-field:"+titleC1);

run("BaSiC ", "processing_stack=["+titleC2+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC2);
close("Flat-field:"+titleC2);
close("Dark-field:"+titleC2);

run("BaSiC ", "processing_stack=["+titleC3+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC3);
close("Flat-field:"+titleC3);
close("Dark-field:"+titleC3);

run("BaSiC ", "processing_stack=["+titleC4+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate both flat-field and dark-field] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
run("Properties...", "channels=1 slices=1 frames=num_tiles") ;

close(titleC4);
close("Flat-field:"+titleC4);
close("Dark-field:"+titleC4);

titleCor1 = "Corrected:"+titleC1;
titleCor2 = "Corrected:"+titleC2;
titleCor3 = "Corrected:"+titleC3;
titleCor4 = "Corrected:"+titleC4;

//Merge the 4 Channels

run("Merge Channels...", "c1=["+titleCor1+"] c2=["+titleCor2+"] c3=["+titleCor3+"] c4=["+titleCor4+"] create");
run("Properties...", "channels=num_channels slices=1 frames=num_tiles") ;
run("Make Composite", "display=Composite");
}

run("Concatenate...", "all_open title=BaSiC_Corrected_Tiles open");
run("Properties...", "channels=num_channels slices=num_tiles frames=num_Z") ;
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");

}

// ****** Continuation for all the IFs ****** //

//Read the Title of the image to split

title = getTitle();

//Split the image into the number of tiles indicated before 

run("Stack Splitter", "number=num_tiles");

//Close the unsplitted image

close(title);

Dialog.create("");
text1="Select the folder to save the BaSiC corrected tiles";
  Dialog.addMessage(text1);
  Dialog.show();

//Save the Tiles

if (num_tiles < 10) {
dir3 = getDirectory("Choose Destination Directory");
for (i=1;i<num_tiles+1;i++) {
        selectImage("stk_000"+i+"_"+title);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        run("Make Composite", "display=Composite");
        saveAs("tiff", dir3 + "tile_" + i);
}

}

else {
dir3 = getDirectory("Choose Destination Directory");
for (i=1;i<10;i++) {
        selectImage("stk_000"+i+"_"+title);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        run("Make Composite", "display=Composite");
        saveAs("tiff", dir3 + "tile_" + i);
}        
for (i=10;i<num_tiles+1;i++) {
        selectImage("stk_00"+i+"_"+title);
        run("Properties...", "channels=num_channels slices=num_Z frames=1");
        run("Make Composite", "display=Composite");
        saveAs("tiff", dir3 + "tile_" + i);
}
}

//Close everything

run("Close All");

//Run the Stitching plugin (The parameters should be introduced by hand in the plugin GUI)

Dialog.create("");
text0="";
text1="For the Stitching, first select the way the tiles were adquired (row by row, colum by colum, snake mode, ...) and then, ";
text2="fill out only the number of tiles by X and Y axis, the folder with the BaSiC corrected tiles and the name of your files";
text3="that should be tile_{i}.tif (only one i inside the { } )";
text4="The stitched image will be saved in the same directory named as 'Stitched_Corrected'";
  Dialog.addMessage(text1);
  Dialog.addMessage(text2);
  Dialog.addMessage(text3);
  Dialog.addMessage(text0);
  Dialog.addMessage(text4);
  Dialog.show();

run("Grid/Collection stitching");

//Convert the image to the Number of Channels indicated before

run("Properties...", "channels=num_channels slices=num_Z frames=1");

//Save the final stitched and corrected image

saveAs("tiff", dir3 + "Stitched_Corrected");
}
