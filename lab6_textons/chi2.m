function [d2] = chi2(h1,h2)
%function d2 = chi2(h1,h2)
%
% This function implements chi square similarity metric but as required by
% fitcknn funcion.
%
% Input:
%   h1:	a 1 X n row vector.
%   h2:	a m X n matrix.
%
% Output:
%   d2:	a m X 1 vector of distances between h1 and each row of h2.
%
% José Valero <ja.valero@uniandes.edu.co>
% March 2016
%
    d2 = zeros(size(h2,1),1);
    
    for j = 1:size(h2,1)
        d2(j) = sum(((h1 - h2(j,:)).^2)./(h1 + h2(j,:)));
    end
    
end
