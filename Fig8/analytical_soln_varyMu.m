%==========================================================================
%Computes statistics from analytical solutions of Fxx for comparison
%with LaMEM Models. 
%==========================================================================

nnk=length(weak_array);
diffs_ave_a=zeros(1,nnk);
dsnorm_a=zeros(1,nnk);
dsnorm2_a=zeros(1,nnk);
fxxslope2_a=zeros(1,nnk);
fxxslope1_a=zeros(1,nnk);
h0_a=zeros(1,nnk);
dh_a=zeros(1,nnk);
lthick_TF_a=zeros(1,nnk);
model_lithosphere;
L=Lfac.*2*xridge;

for nk=1:length(weak_array)
    weak=weak_array(nk);

    full_analytical_solution; 
    
    [lthick_TF_a(nk),diffs_ave_a(nk),dsnorm2_a(nk),fxxslope1_a(nk),h0_a(nk),dh_a(nk),sxx_a_ave,fxx_a_ave]=...
    stats4analytical_solns(j4TFLthickness,zLa,x,y,xridge,xL,xR,fxx_a_ave,sxx_a_ave,dist_ave,dist_find_peak);


end