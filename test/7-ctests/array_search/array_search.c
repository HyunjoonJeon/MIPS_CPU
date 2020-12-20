int searcharray(){
    int arr[5];

    for(int i=0; i<10; i++){
        arr[i] = i + 3;
    }

    int searchvalue = 10;
    for(int i=0; i<10; i++){
        if (arr[i] == searchvalue){
            return i;
        }
    }

    return -1;
}