function [E,V,A,sigma] = runxmd3(struct,low_bound,hi_bound,n_steps,relax,composition)
% bulk='B/(2*V0)*(x-V0).^2+E0';
% C11='C11*V0/2*x.^2+E0'
% C44='2*C44*V0*x.^2+E0'
    sc=ones(n_steps,3);
sc(:,1)=linspace(low_bound,hi_bound,n_steps);
    if struct==11
        sc(:,1)=sc(:,1);
    elseif struct==22
        sc(:,[1,2])=sc(:,[2,1]);
    elseif struct==33
        sc(:,[1,3])=sc(:,[3,1]);
    elseif struct==44
        sc(:,2)=2-sc(:,1);
    elseif struct==0
        sc(:,2)=sc(:,1);
        sc(:,3)=sc(:,1);
    else
        disp('ERROR- invalid structure selection')
        return;
    end

E=zeros(n_steps,1);
A=zeros(n_steps,3);
nat=zeros(n_steps,1);
V=zeros(n_steps,1);
sigma=zeros(n_steps,6);
%prompt = 'Running 100% Ni? (1=yes, 0=no)';
%prompt_res = input(prompt);

% %Edit this to import the right line on 103
% temprel=109;
% tempnr=83;
% 
% if struct==44
%     tempnr=89;
%     temprel=115;
% end
% if composition=='00-32' 
%     temprel = temprel+1;
%     tempnr  = tempnr +1;
% elseif composition=='32-00'
%     temprel = temprel+1;
%     tempnr  = tempnr +1;
% end 
% if relax==1
%     temp=temprel;
% else
%     temp=tempnr;
% end
for j=1:n_steps
% j=1;

    if relax==1
        input1=fopen('nial_relax.xm','r');
        output=fopen('nial_1.xm','wt');
        upperlim1 = 16;
        upperlim2 = 10;
        upperlim3 = 28;

    else
        input1=fopen('nial.xm','r');
        output=fopen('nial_1.xm','wt');
        upperlim1 = 16;
        upperlim2 = 10;
        upperlim3 = 17;
    end
    
    for i=1:upperlim1
        cline=fgets(input1);
        fprintf(output,cline);
    end

    %choose elastic constant to simulate
    %0=B
    %11/22/33=C11/C22/C33
    %12/23/13=C12/C23/C13
    %44=C44
    %disp(fread)
    if struct==0 || struct==11 || struct==22 || struct==33
        fread = sprintf(['read ','structures2/s-',composition,'.sqs \n']);%strcat('read ',{' '},'structures/s-',composition,'.dat \n');
        fprintf(output, fread);
    elseif struct==44
         fread = sprintf(['read ','structures2/r-',composition,'.sqs \n']); %strcat('read ','structures/s-',composition,'.dat \n');
        fprintf(output, fread);
    else
        disp('ERROR- invalid structure selection')
        return;
    end

    for i=1:upperlim2
        cline=fgets(input1);
        fprintf(output,cline);
    end
    
    fprintf(output,'scale %9.8f ',sc(j,1));fprintf(output,'%9.8f ',sc(j,2));fprintf(output,'%9.8f \n',sc(j,3));
    Xwow = ['sc = ',num2str(sc(j,1:3))];
    disp(Xwow);
    %disp(sc(j,1:3));
    
    for i=1:upperlim3
        cline=fgets(input1);
        fprintf(output,cline);
    end
    
    fclose(input1);
    fclose(output);
    
    system('xmd nial_1.xm > res.dat');
    
    res=fopen('res.dat','r');
    cline_test=textscan(res, '%s', 'Delimiter', '\n');
    cline_testtest=char(cline_test{1});
%     disp(temp);
%     
%     for k=1:temp
%         cline=fgetl(res);
%         disp(cline);
%     end
%     %disp(cline)
%     %Edit above to import the correct line. Code skips 
%     %temp number of lines. Use the disp to figure out which one
%     %is being read.
    Line_chr=strfind(cline_test{1}, 'EPOT');
    Line_idx=find(~cellfun(@isempty,Line_chr));
    E(j,1)=sscanf(cline_testtest(Line_idx,5:end),'%e')%e is floating point number.
%     E(j,1)=sscanf(B_test(5:end),'%e'); 
    
%     for k=1:3
%         cline=fgetl(res);
%     end    
% 
%     A(j,1:3)=sscanf(cline(4:end),'%e %e %e');
    Line_chr=strfind(cline_test{1}, 'BOX');
    Line_idx=find(~cellfun(@isempty,Line_chr));
    A(j,1:3)=sscanf(cline_testtest(Line_idx,4:end),'%e %e %e');
    
%     for k=1:3
%         cline=fgetl(res);
%     end  
% 
%     nat(j)=sscanf(cline(4:end), '%e');
    Line_chr=strfind(cline_test{1}, 'nat');
    Line_idx=find(~cellfun(@isempty,Line_chr));
    nat(j)=sscanf(cline_testtest(Line_idx(2),4:end), '%e');

    V(j)=(A(j,1)*A(j,2)*A(j,3))/(nat(j));
    
%     for k=1:7
%         cline=fgetl(res); 
%     end
%     
%     sigma(j,1:6)=sscanf(cline(7:end),'%e %e %e %e %e %e');
    Line_chr=strfind(cline_test{1}, 'STRESS');
    Line_idx=find(~cellfun(@isempty,Line_chr));
    sigma(j,1:6)=sscanf(cline_testtest(Line_idx,7:end),'%e %e %e %e %e %e');
    pause(5)  
    fclose(res);
    
end
end
