%==========================================================================
%Computes statistics from analytical solutions of Fxx for comparison
%with LaMEM Models. 
%==========================================================================

nnk=length(LTF_array);
diffs_ave_a=zeros(1,nnk);
dsnorm_a=zeros(1,nnk);
dsnorm2_a=zeros(1,nnk);
fxxslope2_a=zeros(1,nnk);
fxxslope1_a=zeros(1,nnk);
h0_a=zeros(1,nnk);
dh_a=zeros(1,nnk);
lthick_TF_a=zeros(1,nnk);

    
for nk=1:nnk
    xL=-2; xR=2;
    xridge=LTF_array(nk)/2;
    ymax=6.25;
    %ymax=5;
    x=[0:0.1:2*xridge]; %ok fine this starts at the middle of the TF as per LaMEM coords and
    %it MUST extend beyond the NE ridge to compute asymmetry
    y=[0:0.1:ymax];
    Ny=length(y);
    model_lithosphere;
    get_Lfac;
    L=Lfac0(kk).*Lfac.*2*xridge;  %Lfac0 is the factor of modification
    full_analytical_solution; 
    
    [lthick_TF_a(nk),diffs_ave_a(nk),dsnorm2_a(nk),fxxslope1_a(nk),h0_a(nk),dh_a(nk),sxx_a_ave,fxx_a_ave]=...
    stats4analytical_solns(j4TFLthickness,zLa,x,y,xridge,xL,xR,fxx_a_ave,sxx_a_ave,dist_ave,dist_find_peak);
    %disp(sprintf('nk=%3.0f TFl=%4.1f; dsnorm=%3.2f; hTF=%3.1f; tauTF=%4.0f; L=%3.1f \n',[nk 2*xridge dsnorm2_a(nk) zTF tauTF L]'));  %debugging
end