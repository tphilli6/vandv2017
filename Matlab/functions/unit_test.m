% Fabricated Uncertaity unit test

fex=[1,3];
pf=1.5;
ferr=@(h) 0.1*h.^pf;



%Equal spacing
h=[1,2,4]; err = fex'*ferr(h); fun = err + repmat(fex',[1,3]);
ptest = orderOfAccuracy(fun(1,1), fun(1,2), fun(1,3), h(2)/h(1),h(3)/h(2)); %expected: pf
fprintf(' OrderOfAccuracy.m test:: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', pf, ptest, abs(ptest-pf)<1e-10);

%Not Equal Spacing
h=[1,1.5,2]; err = fex'*ferr(h); fun = err + repmat(fex',[1,3]);
ptest = orderOfAccuracy(fun(1,1), fun(1,2), fun(1,3), h(2)/h(1),h(3)/h(2)); %expected: pf
fprintf(' OrderOfAccuracy.m test:: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', pf, ptest, abs(ptest-pf)<1e-10);


%Equal spacing, negative pf
pf=-1.5;
ferr=@(h) 0.1*h.^pf;
h=[1,2,4]; err = fex'*ferr(h); fun = err + repmat(fex',[1,3]);
ptest = orderOfAccuracy(fun(1,1), fun(1,2), fun(1,3), h(2)/h(1),h(3)/h(2)); %expected: pf
fprintf(' OrderOfAccuracy.m test:: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', pf, ptest, abs(ptest-pf)<1e-10);

%Equal spacing,oscillatory
pf=1.5;
ferr=@(h) 0.1*h.^pf;
h=[1,2,4]; err = fex'*ferr(h); err(:,3)=-err(:,3); fun = err + repmat(fex',[1,3]);
ptest = orderOfAccuracy(fun(1,1), fun(1,2), fun(1,3), h(2)/h(1),h(3)/h(2)); %expected: 2.5661
fprintf(' OrderOfAccuracy.m test:: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', 2.5661, ptest, abs(ptest-2.5661)<1e-4);

%Global deviation order of accuracy
pf1=4.5;
pf2=4.2;
pexp=0.1;
dpexp=1.9;

h=[1,2,4]; 

ferr1=@(h) 0.1*h.^pf1;
ferr2=@(h) 0.1*h.^pf2;
err = [fex(1)*ferr1(h); fex(2)*ferr2(h)]; fun = err + repmat(fex',[1,3]);
[pstar, dp] = globalDeviationOrderOfAccuracy(fun(:,1), fun(:,2), fun(:,3), h(2)/h(1),h(3)/h(2), 2);%expected: 0.5pf1+0.5pf2
fprintf(' globalDeviationOrderOfAccuracy.m test (p*):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', pexp, pstar, abs(pstar-pexp)<1e-10);
fprintf('                                       (dp):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', dpexp, dp, abs(dp-dpexp)<1e-10);

%Global deviation order of accuracy
pf1=-0.5;
pf2=-1.0;
pexp=0.1;
dpexp=1.9;

h=[1,2,4]; 

ferr1=@(h) 0.1*h.^pf1;
ferr2=@(h) 0.1*h.^pf2;
err = [fex(1)*ferr1(h); fex(2)*ferr2(h)]; fun = err + repmat(fex',[1,3]);
[pstar, dp] = globalDeviationOrderOfAccuracy(fun(:,1), fun(:,2), fun(:,3), h(2)/h(1),h(3)/h(2), 2);%expected: 0.5pf1+0.5pf2
fprintf(' globalDeviationOrderOfAccuracy.m test (p*):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', pexp, pstar, abs(pstar-pexp)<1e-10);
fprintf('                                       (dp):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', dpexp, dp, abs(dp-dpexp)<1e-10);

%Global deviation order of accuracy
pf1=1.5;
pf2=1.8;
pexp=0.5*pf1+0.5*pf2;
dpexp=2-pexp;

h=[1,2,4]; 

ferr1=@(h) 0.1*h.^pf1;
ferr2=@(h) 0.1*h.^pf2;
err = [fex(1)*ferr1(h); fex(2)*ferr2(h)]; fun = err + repmat(fex',[1,3]);
[pstar, dp] = globalDeviationOrderOfAccuracy(fun(:,1), fun(:,2), fun(:,3), h(2)/h(1),h(3)/h(2), 2);%expected: 0.5pf1+0.5pf2
fprintf(' globalDeviationOrderOfAccuracy.m test (p*):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', pexp, pstar, abs(pstar-pexp)<1e-10);
fprintf('                                       (dp):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', dpexp, dp, abs(dp-dpexp)<1e-10);

fprintf('   dpFS.m test (dp=0):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', 1.1, dpFS(2,2), abs(dpFS(2,2)-1.1)<1e-10);
fprintf(' dpFS.m test (dp=1.9):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', 3, dpFS(0.1,2), abs(dpFS(0.1,2)-3)<1e-10);

Uexp=dpFS(pexp,2)*(fun(:,2)-fun(:,1))/(2^pexp-1);
Utest = globalDeviationUncertainty(fun(:,1), fun(:,2), fun(:,3), h(2)/h(1),h(3)/h(2), 2);
fprintf('globalDeviationUncertainty.m test (dp=0):: Expected=%4.2f, Returned=%4.2f, Pass=[%1.0f]\n', Uexp(1), Utest(1), abs(Utest(1)-Uexp(1))<1e-10);

