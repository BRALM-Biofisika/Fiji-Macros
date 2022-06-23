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

//Directorio para guardar
dir1 = getDirectory("Choose the Directory of the images to save");

for (i=1;i<num_tiles*num_Z+1;i++) {
        selectWindow(title);
        run("Duplicate...", "duplicate range="+i*num_channels-num_channels+1+"-"+i*num_channels+"");
        saveAs("tiff", dir1 + "z-stack_" + i);
        close();
        print(""+i+"/"+num_tiles*num_Z+"");
}

run("Close All");

//Directorio para guardar

dir2 = getDirectory("Choose the Directory of the images to save");

for (i=1;i<num_Z+1;i++) {
        File.openSequence(dir1, " filter=z start="+i+" step=20");
        saveAs("tiff", dir2 + "z-stack_" + i);
        close();
        print(""+i+"/"+num_Z+"");
}

run("Close All");