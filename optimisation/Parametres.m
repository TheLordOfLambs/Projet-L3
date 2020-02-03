function P = Parametres()           % fonction des paramètre pour un usage clair et efficace

P.Xo = 30 ;                          % positions initiales
P.Yo = 0 ;
P.Zo = -4;

P.tXo = -1 ;                            % position du trou
P.tyo = -2 ;
P.rayontrou = 0.04 ;


if P.Zo < terrain(P.Xo,P.Yo)        % on ne peut crever la surface dans les paramètres instruits par l'utilisateur
    P.Zo = terrain(P.Xo,P.Yo)+0.01 ;
end



P.omega0x = 0 ;                     % rotations initiales de la balle de golf
P.omega0y = 0 ;
P.omega0z = 0 ;

P.gravite = 9.81 ;                  % acélération de la pesanteur
P.densite = 1 ;                     % denstité volumique de l'air
P.traine =  0.2 ;                   % coefficient de trainé
P.magnus =  0.0005 ;                % coefficient de Magnus
P.restitution = 0.5 ;               % coefficient de restitution (homogène dans l'espace)
P.Vlimite = 0.2 ;                   % condition de roulement
P.frottement = 0.15 ;                % coefficient de frottement

P.rayon = 0.021135 ;                % rayon de la balle de golf
P.masse = 0.045 ;                   % masse de la balle de golf

P.Vwx = 0 ;                         % vitesses du vent
P.Vwy = 0 ;
P.Vwz = 0 ;

% Parametres d'integration

P.to = 0 ;                          % intervalle temporel
P.tf = 100 ;
P.options = odeset(  'RelTol',1e-6,...
                        'AbsTol', 1e-6,...
                        'Events', @Evenement_rebond,'MaxStep',0.1);

