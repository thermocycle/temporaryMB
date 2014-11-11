within Components.Units.Test;
model FluidProperties
replaceable package MediumINC =
      ThermoCycle.Media.Incompressible.IncompressibleTables.Therminol66;
replaceable package Medium = ThermoCycle.Media.Water;

      parameter Modelica.SIunits.Temperature T_su = 250 +273.15;
      parameter Modelica.SIunits.Temperature T_ex = 215 +273.15;
      parameter Modelica.SIunits.AbsolutePressure Pinc = 2E5;

       Modelica.SIunits.SpecificHeatCapacity Cp_sf;
      MediumINC.ThermodynamicState Incompressible;
Medium.SaturationProperties sat "TP: Two-phase thermpdynamic state";
Medium.Temperature T_tp;
parameter Modelica.SIunits.AbsolutePressure  p_wf = 1E5;

Modelica.SIunits.SpecificEnthalpy h_l;
Modelica.SIunits.SpecificEnthalpy h_v;
equation
Incompressible = MediumINC.setState_pT(Pinc,(T_su + T_ex)/2);

Cp_sf = MediumINC.specificHeatCapacityCp(Incompressible);

  sat = Medium.setSat_p(p_wf);
  T_tp = Medium.saturationTemperature_sat(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  h_v = Medium.dewEnthalpy(sat);
end FluidProperties;
