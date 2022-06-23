// Macro to split a sequence of tiles (with x channels & y z-stacks) imported with Fiji (using File --> Import --> Image Sequence)
// first into separated tiles (with x channels) and finally the sequence of tiles in the same tiff (with x channels) splitted in y z-stacks

run("Close All");

run("Open...");

title = getTitle();

//Define the Number of Channels, Z-Stacks and Tiles

defaultname="num_channels";
num_channels=getNumber("How many Channels?", 0);
defaultname="num_Z";
num_Z=getNumber("How many Z-Stacks?", 0);
defaultname="num_tiles";
num_tiles=getNumber("How many Tiles?", 0);

//Directory to save the separated tiles (with x channels)

dir1 = getDirectory("Choose the Directory of the images to save the tiles");

for (i=1;i<num_tiles*num_Z+1;i++) {
        selectWindow(title);
        run("Duplicate...", "duplicate range="+i*num_channels-num_channels+1+"-"+i*num_channels+"");
        saveAs("tiff", dir1 + "z-stack_" + i);
        close();
        print(""+i+"/"+num_tiles*num_Z+"");
}

run("Close All");

//Directory to save the sequence of tiles splitted in y z-stacks (with x channels)

dir2 = getDirectory("Choose the Directory of the images to save the splitted z-stacks");

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " filter=z start="+i+" step=20");
        saveAs("tiff", dir2 + "z-stack_" + i);
        close();
        print(""+i+"/"+num_Z+"");
}

run("Close All");
