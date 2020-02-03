function z = terrain(x,y)
%z = -1*x +0*y ;
%z = exp(-3*(x-1).^2 -3*y.^2)+exp(-3*(x+1).^2 -3*(y+1).^2);
z = exp(-0.05*x.^2 -0.05*y.^2).*(sin(1.5*x)+cos(1.5*y));
%z = 0.1+ 0*x+0*y ;
%z=sin(1.5*x)+cos(1.5*y);
%z=cos(1.5*x).*exp(-0.07*x.^2)+0*y;