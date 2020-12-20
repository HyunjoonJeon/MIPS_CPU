int arrayread(){
    int arr[10];
     
    for(int i=0; i<10; i++){
        arr[i] = i;
    }

    int currval = 0;
    for(int i=0; i<10; i++){
        if(arr[i] != i){
            return 1;
        }
        currval = i;
    }

    return currval;
}