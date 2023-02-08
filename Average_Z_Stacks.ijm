//Macro for the automatization of the Avaraging of multiple Z-Stacks recorded with micro-manager
//Coded by the Basque Resource for Advanced Light Microscopy (BRALM).


//Close everything to start

run("Close All");

//Open your file and get the Title

run("Open...");
title = getTitle();

//Define the Number of Z-Stacks, Replicas and Pixel Width

defaultname="num_Z";
num_Z=getNumber("How many Z-Stacks?", 0);
defaultname="num_Replicas";
num_Replicas=getNumber("How many Replicas?", 0);
defaultname="pixelwidth";
pixelwidth=getNumber("What is the pixel width?", 0);

run("Properties...", "channels=1 slices="+num_Z*num_Replicas+" frames=1 pixel_width="+pixelwidth+" pixel_height="+pixelwidth+"");

for (i = 1; i < num_Z+1; i++) {

selectWindow(title);
run("Make Substack...", "slices="+i+"-"+num_Z*num_Replicas+"-"+num_Z+"");
}

close(title);

for (i = 1; i < num_Z+1; i++) {
	selectWindow("Substack ("+i+"-"+num_Z*num_Replicas+"-"+num_Z+")");
	run("Z Project...", "projection=[Average Intensity]");
	close("Substack ("+i+"-"+num_Z*num_Replicas+"-"+num_Z+")");
}
run("Images to Stack", "name=Stack_AVG use");