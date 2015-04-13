within MovingBoundaryLibrary.Spline;
function MakeSpline
  extends Modelica.Icons.Function;
  input Integer n;
  input Real xp[n] "abscissa";
  input Real yp[n] "ordinates";
  input Real dydxl=Modelica.Constants.inf "left slope";
  input Real dydxr=Modelica.Constants.inf "right slope";
  output Real y2[n] "2nd derivatives";
protected
  Real uh[n] "auxiliaey array";
  Real sig;
  Real p;
algorithm
  if dydxl == Modelica.Constants.inf then
//natural spline i.e. left curvature = 0
    y2[1]:= 0;
    uh[1]:= 0;
  else
//given slope at the left border
    y2[1]:= -0.5;
    uh[1]:= +3/(xp[2] - xp[1])*((yp[2] - yp[1])/(xp[2] - xp[1]) - dydxl);
  end if;
//decomposition of tridiagonal algorithm
  for i in 2:n - 1 loop
    sig:= (xp[i] - xp[i-1])/(xp[i+1] - xp[i-1]);
    p:= sig*y2[i-1] + 2;
    y2[i]:= (sig - 1)/p;
    uh[i]:= (6*((yp[i+1] - yp[i])/(xp[i+1] - xp[i]) -
                (yp[i] - yp[i-1])/(xp[i] - xp[i-1]))/
                (xp[i+1] - xp[i-1]) - sig*uh[i-1])/p;
  end for;
  if dydxr == Modelica.Constants.inf then
//natural spline i.e. right curvature = 0
    y2[n]:= 0;
    uh[n]:= 0;
  else
//given slope at the right border
    y2[n]:= +0.5;
    uh[n]:= -3/(xp[n] - xp[n-1])*((yp[n] - yp[n-1])/(xp[n] - xp[n-1]) - dydxr);
  end if;
//backsubstitution of tridiagonal algorithm
  y2[n]:= (uh[n] - y2[n]*uh[n-1])/(y2[n]*y2[n-1] + 1);
  for i in 1:n - 1 loop
    y2[n-i]:= y2[n-i]*y2[n-i+1] + uh[n-i];
  end for;
end MakeSpline;
