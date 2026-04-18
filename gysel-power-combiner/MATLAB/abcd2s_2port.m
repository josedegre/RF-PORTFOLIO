function S = abcd2s_2port(T, ZS, ZL)
    N = size(T,3);
    A = reshape(T(1,1,:),[N,1]);
    B = reshape(T(1,2,:),[N,1]);
    C = reshape(T(2,1,:),[N,1]);
    D = reshape(T(2,2,:),[N,1]);

    if isscalar(ZS), ZS = repmat(ZS,N,1); else, ZS = ZS(:); end
    if isscalar(ZL), ZL = repmat(ZL,N,1); else, ZL = ZL(:); end

    Delta = A.*ZL + B + C.*ZS.*ZL + D.*ZS;

    S11 = ( A.*ZL + B - C.*ZS.*ZL - D.*ZS ) ./ Delta;
    S21 = ( 2*sqrt(ZS.*ZL) ) ./ Delta;
    S12 = ( 2*(A.*D - B.*C).*sqrt(ZS.*ZL) ) ./ Delta;  % ojo: (AD-BC)
    S22 = ( -A.*ZL + B - C.*ZS.*ZL + D.*ZS ) ./ Delta;
    S = zeros(2,2,N);
    S(1,1,:) = reshape(S11,[1 1 N]);
    S(1,2,:) = reshape(S12,[1 1 N]);
    S(2,1,:) = reshape(S21,[1 1 N]);
    S(2,2,:) = reshape(S22,[1 1 N]);
end
