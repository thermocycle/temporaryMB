within MovingBoundaryLibrary.Spline;
function Der1Spline
  extends Modelica.Icons.Function;
  input Real x;
  input Real xp[:] "abscissa";
  input Real yp[:] "ordinates";
  input Real y2[:] "2nd derivatives";
  input Real der_x;
  output Real der_y;
protected
  Integer n = size(xp,1);
  Integer i;
  Real h;
  Real a;
  Real b;
algorithm
  i:= Bisection(x, xp);
  if i == 0 then
//extrapolation below first point
    h:= (xp[2] - xp[1]);
    der_y:= ((yp[2] - yp[1])/h - (2*y2[1] - (-1)*y2[2])*h/6)*der_x;
  elseif i == n then
//extrapolation above last point
    h:= (xp[n] - xp[n-1]);
    der_y:= ((yp[n] - yp[n-1])/h - ((-1)*y2[n-1] - 2*y2[n])*h/6)*der_x;
  else
//1st derivative of cubic spline
    h:= (xp[i+1] - xp[i]);
    a:= (xp[i+1] - x)/h;
    b:= (x - xp[i])/h;
    der_y:= ((yp[i+1] - yp[i])/h - ((3*a^2 - 1)*y2[i] - (3*b^2-1)*y2[i+1])*h/6)*der_x;
  end if;
end Der1Spline;
