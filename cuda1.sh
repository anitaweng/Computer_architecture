nvcc -c cuda1.cu -arch=sm_20
echo 'Finish compiling cuda1.cu' 
nvcc -c main.cu -arch=sm_20
echo 'Finish compiling main.cu'  
g++ -o exe1 cuda1.o main.o `OcelotConfig -l` `pkg-config opencv --cflags --libs`
echo 'Finish generating object code'
./exe1 "v"
mv output.jpg output1.jpg
echo 'Finish executing'
