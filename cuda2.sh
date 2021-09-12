nvcc -c cuda2.cu -arch=sm_20
echo 'Finish compiling cuda2.cu' 
nvcc -c main.cu -arch=sm_20
echo 'Finish compiling main.cu'  
g++ -o exe2 cuda2.o main.o `OcelotConfig -l` `pkg-config opencv --cflags --libs`
echo 'Finish generating object code' 
./exe2 "v" 
mv output.jpg output2.jpg
echo 'Finish executing'
