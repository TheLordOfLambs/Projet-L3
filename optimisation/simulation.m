
function solution = simulation(ci,P) 

    m = P.masse ;
    D = 0.5*P.traine*P.densite*pi*P.rayon^2 ;
    Cm = P.magnus ;
    g = P.gravite ;
    
    options=P.options;
    to = P.to ;
    tf = P.tf ;
    Wox = P.omega0x ;
    Woy = P.omega0y ;
    Woz = P.omega0z ;
   

    CI = [P.Xo;P.Yo;P.Zo;ci(1);ci(2);ci(3)];


    % fonction de l'EDO

    F = @(t,Y) [Y(4);Y(5);Y(6);-sign(Y(4))*(D/m)*(Y(4)-P.Vwx)^2+(Cm/m)*(Woy*Y(6)-Woz*Y(5));-sign(Y(5))*(D/m)*(Y(5)-P.Vwy)^2+(Cm/m)*(Woz*Y(4)-Wox*Y(6));-sign(Y(6))*(D/m)*(Y(6)-P.Vwz)^2-g+(Cm/m)*(Wox*Y(5)-Woy*Y(4))];

    t = to;
    Y = transpose(CI);

    P = Parametres() ;
    F = @(t,Y) [Y(4);Y(5);Y(6);-sign(Y(4))*(D/m)*Y(4)^2+(Cm/m)*(Woy*Y(6)-Woz*Y(5));-sign(Y(5))*(D/m)*Y(5)^2+(Cm/m)*(Woz*Y(4)-Wox*Y(6));-sign(Y(6))*(D/m)*Y(6)^2-g+(Cm/m)*(Wox*Y(5)-Woy*Y(4))];

    
    rebond = 1 ;
    

    while rebond

        [t_rebond,Y_rebond]=ode45(F,[to,tf],CI,options);

        n_steps = length(t_rebond);
        t= [t;t_rebond(1:n_steps)];

        Y = [Y;Y_rebond(1:n_steps,:)];

        CI = Y_rebond(n_steps,:);

        X1 = impacte(CI,Wox,Woy,Woz,'terrain',P);
        CI = X1(1:6);
        rebond = X1(7);

        to = t_rebond(n_steps);
        

        if tf == to
            break
        end
        
    end

    x = CI(1) ;
    y = CI(2) ;
    z = CI(3) ;
    Vx = CI(4) ;
    Vy = CI(5) ;
    Vz = CI(6) ;
    V = [Vx,Vy,Vz]' ;
    

 
    h = 0.0001 ;
    tg = t(end) ;

    while tg < tf
        
        
        tol = 10^(-3) ;
        integration = 1 ;
        r = [x,y,z];
        
        while integration == 1
            
            r1 = glissement(r,V,h,P) ;
            r2_temp = glissement(r,V,h/2,P) ;
            r2 = glissement(r2_temp(1:3),r2_temp(4:6)',h/2,P) ;       %
        
            erreur = norm([r1(1);r1(2);r1(3)]-[r2(1);r2(2);r2(3)]);
            
                
                
                
            h = h*0.9*(tol/erreur)^(1/2);
            
            
            if erreur < tol
                x = r2(1) ;
                y = r2(2) ;
                z = r2(3) ;
                V = [r2(4);r2(5);r2(6)] ;
                break
            end
                
            
        end
               
        if z < terrain(x,y)
            z=terrain(x,y);
        end
        
        
        tg = tg +h ;

        t= [t;tg];

        Y = [Y;[x y z V(1) V(2) V(3)]];
        
        
        
        if and(norm([x;y;z]-[P.tXo;P.tyo;terrain(P.tXo,P.tyo)])<P.rayontrou,norm(V) < P.Vlimite)
            break
        end
        
        if norm(V) < tol
            break
        end
        
        
        


    end

    
solution = [t,Y] ;

end
