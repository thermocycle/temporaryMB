within Components.Units.Test;
model Test_GG

replaceable package Medium = Components.Media.WaterCoolProp constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

parameter Modelica.SIunits.Pressure pp = 10E5;

Modelica.SIunits.SpecificEnthalpy h_a;
Modelica.SIunits.SpecificEnthalpy h_b;
  Medium.SaturationProperties sat;
  Medium.Density rho_l "Fluid cell density";
  Medium.Density rho_v "Fluid cell density";
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  Real GG;
  Real Gamma_a;
  Real Gamma_b;
  Real logGG;

equation
  h_a = Medium.bubbleEnthalpy(sat)+1E3;
  //h_a = Medium.specificEnthalpy_ps();
  h_b = Medium.dewEnthalpy(sat)-1E3;

  sat = Medium.setSat_p(pp);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  rho_v =  Medium.dewDensity(sat);
  rho_l = Medium.bubbleDensity(sat);

Gamma_a = Components.Units.HeatExchangers.MovingBoundary.Functions.Gamma(hh=  h_a, rho_l= rho_l,rho_v=  rho_v, h_l=  h_l, h_v= h_v);
Gamma_b = Components.Units.HeatExchangers.MovingBoundary.Functions.Gamma(hh=  h_b, rho_l= rho_l,rho_v=  rho_v, h_l=  h_l, h_v= h_v);
GG = Gamma_a/Gamma_b;

logGG = log(GG);

end Test_GG;
