run("Close All");

run("Open...");

defaultname="num_channels";
num_channels=getNumber("How many Channels?", 0);
defaultname="num_Z";
num_Z=getNumber("How many Z-Stacks?", 0);
defaultname="num_tiles";
num_tiles=getNumber("How many Tiles?", 0);

//Read the Title of the image to split

title = getTitle();

//Split the image into the number of tiles indicated before 

run("Stack Splitter", "number=num_tiles");

//Close the unsplitted image

close(title);


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