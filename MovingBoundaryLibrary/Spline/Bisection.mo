within MovingBoundaryLibrary.Spline;
function Bisection
  extends Modelica.Icons.Function;
  input Real x;
  input Real xp[:] "abscissa";
  output Integer i;
protected
  Integer n = size(xp,1);
  Integer ilo;
  Integer ihi;
algorithm
  if x <= xp[1] then
//below first point
    i:= 0;
  elseif x >= xp[n] then
//above last point
    i:= n;
  else
//bisectional search for the interval
    ilo:= 1;
    ihi:= n;
    while (ihi - ilo) > 1 loop
      i:= integer((ihi + ilo)/2);
      if (xp[i] > x) then
        ihi:= i;
      else
        ilo:= i;
      end if;
    end while;
//xp[i] <= x < xp[i+1]
    i:= ilo;
  end if;
end Bisection;
