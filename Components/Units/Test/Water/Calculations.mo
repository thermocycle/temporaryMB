within Components.Units.Test.Water;
model Calculations
replaceable package Medium = CoolProp2Modelica.Media.WaterTPSI_FP constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

parameter Modelica.SIunits.SpecificEnthalpy h_ex = 3043000;
parameter Modelica.SIunits.Pressure p_ex = 60e5;
Modelica.SIunits.Temperature T_ex;

equation
T_ex = Medium.temperature_ph(p_ex,h_ex);

end Calculations;
