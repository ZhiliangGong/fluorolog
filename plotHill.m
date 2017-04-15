function b=plotHill(k1,ks)
%ks can be a vector
    alpha = linspace(0,0.3,100);

    figure;
    hold on;
    for i = 1:length(ks)
        b = (k1*alpha.*(1+alpha*ks(i)).^5)./(k1*alpha.*(1+alpha*ks(i)).^5+1);
        plot(alpha,b);
    end
    hold off;

end
