// Macro to apply the BaSiC shading correction to a sequence of z-stacks (with x channels & y tiles) saved in the same directory.

//Define the Number of Channels, Z-Stacks and Tiles

defaultname="num_channels";
num_channels=getNumber("How many Channels?", 0);
defaultname="num_Z";
num_Z=getNumber("How many Z-Stacks?", 0);
defaultname="num_tiles";
num_tiles=getNumber("How many Tiles?", 0);

dir1 = getDirectory("Choose the Directory of the images to open");

//For 1 Channel

if (num_channels == 1) {
	
for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " filter=z start="+i+" step=num_Z");
        title = getTitle();
		run("Properties...", "channels=num_channels slices=num_tiles frames=1");
		run("Make Composite", "display=Composite");
//        run("Split Channels");	

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

//Concatenate all the z-stacks into one file

run("Concatenate...", "all_open title=BaSiC_Corrected_Tiles open");
run("Properties...", "channels=num_channels slices=num_tiles frames=num_Z") ;
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");

//run("Save");

}
//For 2 Channels

if (num_channels == 2) {

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " filter=z start="+i+" step=num_Z");
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

//run("Save");

}

//For 3 Channels

if (num_channels == 3) {

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " filter=z start="+i+" step=num_Z");
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

//run("Save");

}

//For 4 Channels

if (num_channels == 4) {

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " filter=z start="+i+" step=num_Z");
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

//run("Save");

}

// ****** Continuation for all the IFs ****** //

//Read the Title of the image to split

title = getTitle();

//Split the image into the number of tiles indicated before 

run("Stack Splitter", "number=num_tiles");

//Close the unsplitted image

close(title);

//Save the Tiles

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

run("Close All");
