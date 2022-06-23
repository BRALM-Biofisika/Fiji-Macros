//Define the Number of Channels, Z-Stacks and Tiles

defaultname="num_channels";
num_channels=getNumber("How many Channels?", 0);
defaultname="num_Z";
num_Z=getNumber("How many Z-Stacks?", 0);
defaultname="num_tiles";
num_tiles=getNumber("How many Tiles?", 0);

dir1 = getDirectory("Choose the Directory of the images to open");

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " filter=z start="+i+" step=20");
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

run("Save");