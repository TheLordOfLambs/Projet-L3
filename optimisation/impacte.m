function I = impacte(CI,Wox,Woy,Woz,F,P)

e = P.restitution ;
r = P.rayon ;
X = CI ;
Vlimite = P.Vlimite;

% création d'une base orthonormée locale en un point d'impact de la surface

nz= normale(X(1),X(2),F) ;                  % axe z de la base locale {n}
nx = [-nz(3),0,nz(1)];                      % axe x de la base locale {n}
ny = cross(nz,nx);                          % axe y engendré par produit
nx = nx./norm(nx)  ;                        % normalisation de {n}
ny = ny./norm(ny);

Mat_n_e = [nx',ny',nz'];                    % Matrice de la base {n} dans {e}


V = [X(4),X(5),X(6)]' ;                     % vitesse


Vn = Mat_n_e\V   ;                          % On exprime la vitesse dans la base du plan tangeant

Vn(3) = -e*Vn(3) ;                          % rebond inversion suivant nz qui contient toute l'information sur la nouvelle direction puisqu'elle se décompose suivant les TROIS axes de {e}

if Vn(3) < Vlimite
    rebond = 0 ;
    Vn(3) = 0 ;   
else
    rebond = 1 ;
end

Ve = Mat_n_e*Vn ;                           % expression dans la base {e}


X(4) = Ve(1) ;
X(5) = Ve(2) ;
X(6) = Ve(3) ;

I = [X,rebond];