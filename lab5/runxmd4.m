function [tcpu,twall] = runxmd4(kelvins,timestep,bulkmod,md_steps,composition,pressure)

tbeg = cputime;
tic;
        input1=fopen('nial_MD.xm','r');
        output=fopen('nial_1.xm','wt');
        upperlim1 = 16;
        upperlim2 = 17;
        upperlim3 = 8;
  
    for i=1:upperlim1
        cline=fgets(input1);
        fprintf(output,cline);
    end

    %Read SQS structure with appropriate composition

    fread = sprintf(['read ','structures2/s-',composition,'.sqs \n']);
    fprintf(output, fread);

    for i=1:upperlim2
        cline=fgets(input1);
        fprintf(output,cline);
    end
    
%   fprintf(output,'scale %9.8f ',sc(j,1));fprintf(output,'%9.8f ',sc(j,2));fprintf(output,'%9.8f \n',sc(j,3));
     
    fprintf(output, 'dtime %7.3e \n',timestep);
    fprintf(output, 'itemp %8.1f \n',kelvins*2);
    fprintf(output, 'clamp %8.1f \n',kelvins);
    fprintf(output, 'pressure clamp %8.1f \n',bulkmod);
    fprintf(output, 'pressure external %9.3f \n',pressure);
    fprintf(output, 'cmd %6i \n',md_steps);

    
    for i=1:upperlim3
        cline=fgets(input1);
        fprintf(output,cline);
    end
    
    fclose(input1);
    fclose(output);
    
    system('xmd nial_1.xm > res.dat');
    
%    res=fopen('res.dat','r');
%    cline_test=textscan(res, '%s', 'Delimiter', '\n');
%    cline_testtest=char(cline_test{1});

%    Line_chr=strfind(cline_test{1}, 'EPOT');
%    Line_idx=find(~cellfun(@isempty,Line_chr));
%    E=sscanf(cline_testtest(Line_idx,5:end),'%e')%e is floating point number.

%    Line_chr=strfind(cline_test{1}, 'BOX');
%    Line_idx=find(~cellfun(@isempty,Line_chr));
%    A(1:3)=sscanf(cline_testtest(Line_idx,4:end),'%e %e %e');
    
%    Line_chr=strfind(cline_test{1}, 'nat');
%    Line_idx=find(~cellfun(@isempty,Line_chr));
%    nat=sscanf(cline_testtest(Line_idx(2),4:end), '%e');

%    V=(A(1)*A(2)*A(3))/(nat);
    
%    Line_chr=strfind(cline_test{1}, 'STRESS');
%    Line_idx=find(~cellfun(@isempty,Line_chr));
%    sigma(1:6)=sscanf(cline_testtest(Line_idx,7:end),'%e %e %e %e %e %e');
%    pause(5)  
%   fclose(res);
tcpu = cputime - tbeg;
twall = toc;
end

