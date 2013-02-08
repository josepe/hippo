function k=arr2vec(i,j,N)

% returns the column index of coordinates i,j in NXN matrix

if i>N
    error('i should be =<N');
end
k=i+N*(j-1);