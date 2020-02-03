%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                           Projet Numérique                          %%%
%%%                            final_simulation                         %%%
%%%                         CHARRY. A - YAACOUB. D                      %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
clear all; close all; clc ;


% Paramètres
P = Parametres() ; 
m = P.masse ;
D = 0.5*P.traine*P.densite*pi*P.rayon^2 ;
Cm = P.magnus ;
g = P.gravite ;
r = P.rayon ;

options=P.options;
to = P.to ;
tf = P.tf ;

Wox = P.omega0x ;
Woy = P.omega0y ;
Woz = P.omega0z ;
CI = [P.Xo;P.Yo;P.Zo;P.Vox;P.Voy;P.Voz];

% fonction de l'EDO
F = @(t,Y) [Y(4);Y(5);Y(6);-sign(Y(4))*(D/m)*(Y(4)-P.Vwx)^2+(Cm/m)*(Woy*Y(6)-Woz*Y(5));-sign(Y(5))*(D/m)*(Y(5)-P.Vwy)^2+(Cm/m)*(Woz*Y(4)-Wox*Y(6));-sign(Y(6))*(D/m)*(Y(6)-P.Vwz)^2-g+(Cm/m)*(Wox*Y(5)-Woy*Y(4))];

% initialisation
t = to;
Y = transpose(CI);
rebond = 1 ;

% intégration

% rebonds
while rebond ;

    [t_vol,Y_vol]=ode45(F,[to,tf],CI,options);

    duree_vol = length(t_vol);
    t= [t;t_vol(1:duree_vol)];
    Y = [Y;Y_vol(1:duree_vol,:)];

    CI = Y_vol(duree_vol,:);
    X1 = impact(CI,'terrain',P);
    CI = X1(1:6);
    rebond = X1(7);
    to = t_vol(duree_vol);

    if tf == to
        break
    end
end

% glissement

% initialisation
x = CI(1) ;
y = CI(2) ;
z = CI(3) ;
Vx = CI(4) ;
Vy = CI(5) ;
Vz = CI(6) ;
V = [Vx,Vy,Vz]' ;
h = 0.0001 ;
tg = t(end) ;

% intégration
while tg < tf

    tol = 10^(-6) ;
    integration = 1 ;
    r = [x,y,z];

    while integration == 1                      % adaptation du pas

        r1 = glissement(r,V,h,P) ;
        r2_temp = glissement(r,V,h/2,P) ;
        r2 = glissement(r2_temp(1:3),r2_temp(4:6)',h/2,P) ;

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

    tg = tg +h ;
    t= [t;tg];

    Y = [Y;[x y z V(1) V(2) V(3)]];

    if norm(V) < tol
        break
    end
end

% Graphique

% terrain
terrain_x = min(Y(:,1))-1:0.1:max(Y(:,1))+1 ;
terrain_y = (min(Y(:,2))-1:0.1:max(Y(:,2))+1)';
terrain_z =  terrain(terrain_x,terrain_y);
C = terrain_z;

% Animation trajectoire

to =t(1); 
dto = 0.01;

figure('Position',[0 0 1550 800])
for i = 1:length(Y(:,1))
    
    dt = t(i)-to;
    if dt >= dto
        mesh(terrain_x,terrain_y,terrain_z)
        axis equal
        hold on
        plot3(Y(1:i,1),Y(1:i,2),Y(1:i,3),'b',Y(i,1),Y(i,2),Y(i,3),'-ob')
        view(-88,50)
        title('trajectoire')
        title(sprintf('t=%f',t(i)))
        xlabel('x (m)')
        ylabel('y (m)')
        zlabel('z (m)')
        grid ON
        hold off
         
        to = t(i);
    end
    pause(0.00001)
end
%{
% énergétique
Ec2=0.5*m*(Y(:,4).^2+Y(:,5).^2+Y(:,6).^2);
Ep = m*g*Y(:,3);
E = Ec2+Ep;

figure(2)
plot(t,Ec2,'r',t,Ep,'b',t,E,'k',t,Ec2,'g')
title('Energie cinetique-rouge | Energie potentielle-bleue | Energie mécanique-noire)')
xlabel('Temps (s)')
ylabel('Energie (j)')
%}