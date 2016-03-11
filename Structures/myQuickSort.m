function [x,ind] = myQuickSort(x) 
% Sort vector x in ascending order using the Quicksort algorithm with 
% in-place partitioning. 

n= length(x);
if n<=1
    return
else
    pivot= x(ceil(rand*n));
    i = 1;
    j = n;
    while i <= j
        while i < n && x(i) < pivot
            i = i+1;
        end
        while j > 1 && x(j) > pivot
            j = j-1;
        end
        if i<=j
        t = x(i);
        x(i) = x(j);
        x(j) = t;
        i = i + 1;
        j = j - 1;
        end
    end
% Sort each part through recursive calls
    x(1:j)= myQuickSort(x(1:j)); 
    x(i:end)= myQuickSort(x(i:end));
end