function [E,V,A,sigma] = runxmd2(struct,low_bound,hi_bound,n_steps)
sc=ones(n_steps,3);
sc(:,1)=linspace(low_bound,hi_bound,n_steps);
    if struct==AA
        sc(:,1)=sc(:,1);
    elseif struct==BB
        sc(:,[1,2])=sc(:,[2,1]);
    elseif struct==CC
        sc(:,[1,3])=sc(:,[3,1]);
    elseif struct==DD
        sc(:,2)=2-sc(:,1);
    elseif struct==EE
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
for j=1:n_steps

    input=fopen('al.xm','r');
    output=fopen('al_1.xm','wt');
    
    for i=1:15
        cline=fgets(input);
        fprintf(output,cline);
    end

    %choose elastic constant to simulate
    %0=B
    %11/22/33=C11/C22/C33
    %12/23/13=C12/C23/C13
    %44=C44
    if struct==0
        fprintf(output, 'read cubic_cell.dat \n');
        %disp('Use cubic_cell.dat');
    elseif struct==11 || struct==22 || struct==33
        fprintf(output,'read cubic_cell.dat \n');
        %disp('Use cubic_cell.dat');
    elseif struct==44
        fprintf(output,'read bain_cell.dat \n');
        %disp('Use bain_cell.dat');
    else
        disp('ERROR- invalid structure selection')
        return;
    end

    for i=1:10
        cline=fgets(input);
        fprintf(output,cline);
    end
    
    fprintf(output,'scale %9.8f ',sc(j,1));fprintf(output,'%9.8f ',sc(j,2));fprintf(output,'%9.8f \n',sc(j,3));
    disp('sc = ');
    disp(sc(j,1:3));
    
    for i=1:13
        cline=fgets(input);
        fprintf(output,cline);
    end
    
    fclose(input);
    fclose(output);
    
    system('xmd al_1.xm > res.dat');
    
    res=fopen('res.dat','r');
    for k=1:72
        cline=fgetl(res);
    end
    
    E(j,1)=sscanf(cline(5:end),'%e');
    
    for k=1:3
        cline=fgetl(res);
    end    

    A(j,1:3)=sscanf(cline(4:end),'%e %e %e');
    
    for k=1:3
        cline=fgetl(res);
    end  

    nat(j)=sscanf(cline(4:end), '%e');

    V(j)=(A(j,1)*A(j,2)*A(j,3))/(216*nat(j));
    
    for k=1:7
        cline=fgetl(res);
    end  
    
    sigma(j,1:6)=sscanf(cline(7:end),'%e %e %e %e %e %e');
    
    fclose(res);
end