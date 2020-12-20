int count(){
    int arr[20];

    for(int i=0; i<20; i++){
        arr[i] = i%3;
    }

    int count = 0;
    for(int i=0; i<20; i++){
        if(arr[i] == 2){
            count ++;
        }
    }

    return count;
}