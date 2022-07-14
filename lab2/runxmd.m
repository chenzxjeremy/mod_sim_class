function [E,V,A,sigma] = runxmd()

    system('xmd al.xm > res.dat');
    
    res=fopen('res.dat','r');
    
    for k=1:16
        cline=fgetl(res);
    end
    
    ncells(1,1:3)=sscanf(cline(4:end),'%e %e %e');
    
    for k=1:23
        cline=fgetl(res);
    end
    
    E=sscanf(cline(5:end),'%e');
    
    for k=1:2
        cline=fgetl(res);
    end    

    A(1,1:3)=sscanf(cline(4:end),'%e %e %e');
    
    for k=1:2
        cline=fgetl(res);
    end  

    nat=sscanf(cline(4:end), '%e');

    V=(A(1,1)*A(1,2)*A(1,3))/(ncells(1,1)*ncells(1,2)*ncells(1,3)*nat);
    
    for k=1:4
        cline=fgetl(res);
    end  
    
    sigma(1,1:6)=sscanf(cline(7:end),'%e %e %e %e %e %e');
    
    fclose(res);
end