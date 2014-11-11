within Components.Units.Test;
model Test_vector_summary_Class

parameter Integer N = 3;
parameter Modelica.SIunits.Temperature T_1;
parameter Modelica.SIunits.Temperature T_2;
parameter Modelica.SIunits.Temperature T_3;
Modelica.SIunits.Temperature T_wall[1,N];

equation
T_wall = [T_1,T_2,T_3];

end Test_vector_summary_Class;
