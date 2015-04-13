within MovingBoundaryLibrary.Spline;
function EvalSpline
  extends Modelica.Icons.Function;
  input Real x;
  input Real xp[:] "abscissa";
  input Real yp[:] "ordinates";
  input Real y2[:] "2nd derivatives";
  output Real y;
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
    h:= (yp[2] - yp[1])/h - (2*y2[1] - (-1)*y2[2])*h/6;
    y:= yp[1] + h*(x - xp[1]);
  elseif i == n then
//extrapolation above last point
    h:= (xp[n] - xp[n-1]);
    h:= (yp[n] - yp[n-1])/h - ((-1)*y2[n-1] - 2*y2[n])*h/6;
    y:= yp[n] + h*(x - xp[n]);
  else
//evaluation of cubic spline
    h:= (xp[i+1] - xp[i]);
    a:= (xp[i+1] - x)/h;
    b:= (x - xp[i])/h;
    y:= a*yp[i] + b*yp[i+1] + ((a^3 - a)*y2[i] + (b^3 - b)*y2[i+1])*h^2/6;
  end if;
  annotation(derivative(noDerivative=xp, noDerivative=yp, noDerivative=y2)=Der1Spline);
end EvalSpline;
