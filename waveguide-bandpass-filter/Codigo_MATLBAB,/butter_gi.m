function g = butter_gi(N)
    g = zeros(1, N+2); g(1)=1; g(end)=1;
    for k = 1:N
        g(k+1) = 2*sin((2*k-1)*pi/(2*N));
    end
end