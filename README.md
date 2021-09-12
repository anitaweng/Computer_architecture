# Computer_architecture

This is a the code using **GPU** with **C++**. It aims to mirror the image and turns it to the gray scale.
cuda1 and cuda2 are two different block and thread settings. The details please refer to the **Report_309505001.pdf**.

```
1. install opencv (sudo apt-get install libopencv-dev)
   However, the version of ubuntu is too old, so one wants to install opencv should edit the /etc/apt/sources.list file and turn all "tw.archive" or "archive" in the url into "old-releases". Also, one needs to add following lines if they not exist:
   deb http://old-releases.ubuntu.com/ubuntu precise main restricted universe   
   deb-src http://old-releases.ubuntu.com/ubuntu precise restricted main multiverse universe

   deb http://old-releases.ubuntu.com/ubuntu precise-updates main restricted universe  
   deb-src http://old-releases.ubuntu.com/ubuntu precise-updates restricted main multiverse universe

   Then type "sudo apt-get update" and "sudo apt-get upgrade" in the terminal.
   Finally, you can try to install opencv library for c++.

2. The default testing file is images.jpeg in the folder

3. sh cuda1.sh
   #one can change the "v" or "h" for control the mirror direction in the script file.

4. sh cuda2.sh
   #one can change the "v" or "h" for control the mirror direction in the script file.

5. sh clean.sh (if you wish to clean the generate files)
```
Example:

![images](https://user-images.githubusercontent.com/42642215/132988636-ae3fc666-6d89-4607-b1fe-ab62ae938e3b.jpeg)


![output2v](https://user-images.githubusercontent.com/42642215/132988616-bc3b5f76-ac68-4eb3-a76a-3ad277ced70c.jpg)


Reference: https://github.com/ShivayaDevs/Photops
