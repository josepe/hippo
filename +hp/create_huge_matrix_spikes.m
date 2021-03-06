function data=create_huge_matrix_spikes(fs)
import hp.*
di=dir('a*');
for k=2:10
    cd(di(k).name);
    
    %thalamus
    dbt=dir('t-unit*');
    dat=importdata(dbt(1).name);
    data(1,k-1).times=extractspikes(dat.data,fs)/fs;
    
    %hippocampus
    dbh=dir('h-unit*');
    dat=importdata(dbh(1).name);
    data(2,k-1).times=extractspikes(dat.data,fs)/fs;
    
    cd ..
end

end

