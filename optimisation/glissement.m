function Y = glissement(r,V,h,P)
x = r(1);
y = r(2);
z = r(3);
g=P.gravite ;
m=P.masse ;
mu = P.frottement;
dt = h ;

% base locale normale orthonormée {n}

gradx = (terrain(x+h,y) - terrain(x,y))/h;
grady = (terrain(x,y+h) - terrain(x,y))/h;
t1 = [1,0,gradx];
t2 = [0,1,grady];
n = cross(t1,t2);
nz = n./norm(n);
nx = [-nz(3),0,nz(1)];                      % axe x de la base locale {n}
ny = cross(nz,nx);                          % axe y engendré par produit
nx = nx./norm(nx);                          % normalisation de {n}
ny = ny./norm(ny);
Mat_n_e = [nx',ny',nz'] ;                   % matrice de passe de {n} vers {e}

% vitesse dans la base {n}

Vn = Mat_n_e\V ;
Vn(3)=0;
V = Mat_n_e*Vn;

% glissement

Poid = m*g*[0;0;-1];
alpha = acos(dot([0;0;1],nz'));
Resistance = m*g*cos(alpha)*nz';
frottement = -mu*V ;
a = (Resistance+Poid+frottement)/m;

% intégration

V = V + a*dt;
x = x + V(1)*dt ;
y = y + V(2)*dt ;
z = z + V(3)*dt ;

if z< terrain(x,y)
    z=terrain(x,y);
end

Y = [x,y,z,V(1),V(2),V(3)];