int fib(int n){
    if (n==0) return 0;
    else if (n==1) return 1;
    else return fib(n-1)+fib(n-2);
}

int main(){
    int f = 3;
    int fibo = fib(f);
    return 0;
}
