function p = orderOfAccuracy(f1, f2, f3, r12, r23)
% p = orderOfAccuracy(f1, f2, f3, r12, r23)
% all inputs must be the same size and shape.
% f1 = fine mesh solution
% f2 = medium mesh solution
% f3 = coarse mesh solution
% r12 = refinement factor between mesh h1 and h2
% r23 = refinement factor between mesh h2 and h3
%
% Function to compute the order of accuracy with the modification (i.e.
% abs)

%silence fzero output
options = optimset('Display','off');


rat=abs( (f3-f2)./(f2-f1) );

I1=find(f3==f2);
I2=find(f2==f1);
rat(I1)=1;
rat(I2)=1;


if (r12==r23)
   p = log(rat)./log(r12);
else
    
 pbrack=[-100:.25:-4.25,-4:.05:4,4.25:.25:100];%, 10:100];
 for i=1:numel(rat)   
    ptrans = @(p) log( (r12.^p-1).*rat(i)+r12.^p)./log(r12.*r23) - p;
    pbrack_guess=ptrans(pbrack); 
    pbrack_test = pbrack_guess(1:end-1).*pbrack_guess(2:end); 
    I=find(pbrack_test<=0 & imag(pbrack_test)==0 ); 
    
    [pguess]=max(pbrack(I));

     if isempty(pguess); pguess=log(rat(i))/log( .5*r12+.5*r23 ); end;
%     pguess=max(log(rat(i))/log( .5*r12+.5*r23 ),0.5);
%     if (rat(i)<1); pguess=0; else; pguess = max(10,pguess); end;

    p(i) = fzero(ptrans,pguess,options);
    if isnan(p(i))
        p(i)=0;
    end
 end
 p=reshape(p,size(rat));
end