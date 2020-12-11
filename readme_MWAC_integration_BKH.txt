Process mwac data for NWERN sites

[to export this sheet from DIMA, follow the same process as exporting the Excel report (in the original "readme" file), but instead export the flux integration option]

Make sure and remove the last row of "999" and extra space up to the last data value in input file before use *will eventually try and figure this out...

Easiest use: add the text file to the folder that contains the code, or vice versa

[from BKH] open command prompt (i.e. click windows, type “cmd”; mac, I’m not sure)
Ensure the input text file is in the same folder as the “mwac_int.py” file.

Copy the file directory of this folder “as text”, return to command prompt and type:
	Cd paste directory

Now, with the “usage” below, type your input file name, and whatever you want your output file to be called. Replace HEIGHT with 1.0 (if you want to integrate from 0 to 1 meters), 
and replace SIZE with the inlet size of the dust trap you are using.

usage: python mwac_int.py -i inputfile.txt -o outputfile.txt HEIGHT SIZE

For Red Hills, the Comand prompt will look something like this:

C:\Users\Howard> cd C:\Users\Administrator\Documents\NWERN\NWERN_Analysis\flux_integration

then usage will be the next line after changing your directory:

C:\Users\Administrator\Documents\NWERN\NWERN_Analysis\flux_integration> python mwac_int.py -i redhillsinput.txt -o redhillsoutput.txt 1 0.0002395

If no errors occur, you will find the exported file with the name you choose in the working folder.

If you run into problems with python not finding the correct packages (i.e. numpy, scipy), you must use “pip” to install these libraries (I think it’s easiest to do this into the working folder). 

I.e. C:\Users\Administrator\Documents\NWERN\NWERN_Analysis\flux_integration> pip install numpy

[end BKH]


	where Height is desired integration height and size is mwac opening (0.000234 m^2 for NWERN MWACS)
	
	***Area of Network MWAC inlet***
	Inner Diameter of Network MWAC inlet = 0.68 inches = 0.017272 m
	Radius of network MWAC inlet = 0.008636
	Area of network MWAC inlet = 2.34 x 10^04 m^
