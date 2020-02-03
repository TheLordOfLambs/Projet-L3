function [value,isterminal,direction] = Evenement_rebond(t,Y)
value = Y(3) > feval('terrain',Y(1),Y(2));                   % arrêt de l'itération quand cette condition n'est plus vérifiée
isterminal = 1;                                              % arrêt de l'intégration
direction = -1;                                              % pour les directions négatives seulement