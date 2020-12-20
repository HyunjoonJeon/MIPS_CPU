int findnegative(){
    int arr[10];

    for(int i=0; i<10; i++){
        arr[i] = i-5;
    }

    int count = 0;
    for(int i=0; i<10; i++){
        if(arr[i] < 0){
            count ++;
        }
    }

    return count;
}