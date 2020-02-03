function n = normale(x0,y0,F)
h = 0.0001 ;
fgradx = (feval(F,x0+h,y0) - feval(F,x0,y0))/h;
fgrady = (feval(F,x0,y0+h) - feval(F,x0,y0))/h;
t1 = [1,0,fgradx];
t2 = [0,1,fgrady];
n = cross(t1,t2) ;
n = n./norm(n);
end