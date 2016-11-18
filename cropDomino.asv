function [D] = cropDomino(cornerPoints,A)

%-------------------------------------
c = cornerPoints(:,1);
r = cornerPoints(:,2);

k = boundary(double(c),double(r));

if length(k)< 1
    D = A;
else
    for i=1:4
        c1(i) = c(k(i));
        r1(i) = r(k(i));
    end
    %B=imresize(A,0.6);
    
    C = roipoly(A,c1,r1);
    
    
    D = bsxfun(@times, A, cast(C,'like',A));

end
%imshow(D)

end