function I = impact(CI,F,P)

%Param�tres

e = P.restitution ;
r = P.rayon ;
X = CI ;
Vlimite = P.Vlimite;

% cr�ation d'une base orthonorm�e locale en un point d'impact de la surface

nz= normale(X(1),X(2),F) ;                  % axe z de la base locale {n}
nx = [-nz(3),0,nz(1)];                      % axe x de la base locale {n} orthogonal au pr�c�dent
ny = cross(nz,nx);                          % axe y engendr� par produit
nx = nx./norm(nx)  ;                        % normalisation de {n}
ny = ny./norm(ny);
Mat_n_e = [nx',ny',nz'];                    % Matrice de la base {n} dans {e}

% vitesse dans {n} - r�flexion

V = [X(4),X(5),X(6)]' ;                     % vitesse
Vn = Mat_n_e\V   ;                          % Ovitesse dans la base du plan tangeant
Vn(3) = -e*Vn(3) ;                          

% condition pour l'arret ou non des rebonds

if Vn(3) < Vlimite
    rebond = 0 ;
    Vn(3) = 0 ;   
else
    rebond = 1 ;
end

% passage des r�sultats dans la base cart�sienne fixe de travail

Ve = Mat_n_e*Vn ;                         
X(4) = Ve(1) ;
X(5) = Ve(2) ;
X(6) = Ve(3) ;

I = [X,rebond];