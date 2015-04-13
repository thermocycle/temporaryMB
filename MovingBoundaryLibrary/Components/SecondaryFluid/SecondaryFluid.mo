within MovingBoundaryLibrary.Components.SecondaryFluid;
model SecondaryFluid

 parameter Integer n= 1 "Number of CV";
  Interfaces.MbIn mbIn[n]
    annotation (Placement(transformation(extent={{-10,-102},{10,-82}})));
  ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlow_sf
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

parameter Modelica.SIunits.CoefficientOfHeatTransfer Usf
    "Secondary fluid Heat transfer coefficient sub-cooled side";
constant Real pi = Modelica.Constants.pi;
parameter Modelica.SIunits.Area AA "Channel cross section";
parameter Modelica.SIunits.Length YY "Channel perimeter";
parameter Modelica.SIunits.Length L_total "Channel total length";
parameter Boolean eps_NTU = false "Set true to for eps-NTU relation";
parameter Modelica.SIunits.Temperature Tstart
    "Start value for average temperature of inlet cell";
parameter Modelica.SIunits.Temperature DTstart
    "Delta T to initialize second and third volume average temperature";
final parameter Modelica.SIunits.Temperature Tsf_start[n] = {Tstart - DTstart*i for i in 1:n}
    "Initial temperature of the secondary fluid";
/******* Secondary fluid  ****************/
Modelica.SIunits.SpecificHeatCapacity cp_sf
    "Specific heat capacity of the secondary fluid at the inlet";
    Modelica.SIunits.Temperature T_sfA[n]
    "Temperature at the inlet of the volume";
    Modelica.SIunits.Temperature T_sf[n](start = Tsf_start)
    "Temperature at the center of the volume";
Modelica.SIunits.Temperature T_sfB[n] "Temperature at the outlet of the volume";

Modelica.SIunits.Power Qsf[n] "Heat from the secondary side";

Modelica.SIunits.MassFlowRate Mdot_sf "Mass flow rate of the secondary fluid";
Modelica.SIunits.Density rho_sf "Density of the secondary fluid";
/******* Heat transfer coefficient  ****************/
Real epsilon[n] "Epsilon Sub-cooled secondary fluid - wall Side";
Real NTU[n] "NTU Sub-cooled secondary fluid-Wall side";
Real Cdot_wf[n] "Thermal energy capacity rate of the working fluid [J/k]";
Real  Cdot_sf "Thermal energy capacity rate of the secondary fluid [J/k]";

equation
  /* Cell One */

  Cdot_sf = Mdot_sf*cp_sf;
  if eps_NTU then
  for i in 1:n loop
   NTU[i] =   Usf*YY*mbIn[i].ll/(Cdot_sf);
  epsilon[i] = 1 - exp(-NTU[i]);
  T_sf[i] = (T_sfA[i] + T_sfB[i])/2;
  Qsf[i] = Mdot_sf*cp_sf*(T_sfA[i] - T_sfB[i]);
  Qsf[i] = cp_sf*Mdot_sf*epsilon[i]*(T_sfA[i] - mbIn[i].T);
  end for;
  else
    for i in 1:n loop
  NTU[i] =   Usf*YY*mbIn[i].ll/(Cdot_sf);
  epsilon[i] = 1 - exp(-NTU[i]);
  T_sf[i] = (T_sfA[i] + T_sfB[i])/2;
  Qsf[i] = Mdot_sf*cp_sf*(T_sfA[i] - T_sfB[i]);
  Qsf[i] = Usf*YY*mbIn[i].ll*(T_sf[i] - mbIn[i].T);
  end for;
  end if;
 for i in 1:n-1 loop
   T_sfB[i] = T_sfA[i+1];
 end for;

  /* Cell One - Cell Two */

/* Connector */
InFlow_sf.cp = cp_sf;
InFlow_sf.rho = rho_sf;
InFlow_sf.Mdot = Mdot_sf;
InFlow_sf.T = T_sfA[1];

  mbIn.Q_flow = -Qsf;
  mbIn.Cdot = Cdot_wf;
 // mbIn[2].Q_flow = -Qsf[1];

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end SecondaryFluid;
