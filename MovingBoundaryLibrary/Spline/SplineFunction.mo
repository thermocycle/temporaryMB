within MovingBoundaryLibrary.Spline;
model SplineFunction
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real table[:,2] "u data on first column, y data on y column";
protected
  parameter Integer n = size(table,1) "Number of data points";
  parameter Real y2[n]= MakeSpline(n, table[:,1], table[:,2])
    "Spline derivative data";
equation
  y = EvalSpline(u, table[:,1], table[:,2], y2);
  annotation (Icon(graphics={
        Line(points={{-78,82},{-78,-82}}, color={0,0,0}),
        Line(points={{-86,-72},{84,-72}}, color={0,0,0}),
        Line(points={{70,-64},{84,-72},{70,-78}}, color={0,0,0}),
        Line(points={{-84,68},{-78,82},{-72,68}}, color={0,0,0}),
        Line(points={{-70,-22},{-60,-14},{-46,-6},{-32,-2},{-18,-4},{-8,-10},{
              2,-16},{14,-22},{28,-26},{38,-26},{48,-20},{56,-10},{62,2},{66,14}},
            color={0,0,0})}));
end SplineFunction;
