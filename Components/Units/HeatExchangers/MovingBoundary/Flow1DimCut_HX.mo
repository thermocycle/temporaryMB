within Components.Units.HeatExchangers.MovingBoundary;
model Flow1DimCut_HX
  "1-D fluid flow model (lumped, real fluid, variable length)"
  import Components;
replaceable package Medium = ThermoCycle.Media.R245faCool constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);
//Modelica.Media.Interfaces.PartialTwoPhaseMedium
  import ThermoCycle.Functions.Enumerations.HTtypes;
  parameter HTtypes HTtype=HTtypes.LiqVap
    "Select type of heat transfer coefficient";
/* Thermal and fluid ports */
 Modelica.Fluid.Interfaces.FluidPort_a inlet(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
 Modelica.Fluid.Interfaces.FluidPort_b outlet(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-12},{110,8}})));
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a
                                                  Wall_int
    annotation (Placement(transformation(extent={{-10,32},{10,52}}),
        iconTransformation(extent={{-10,44},{10,64}})));

/* Heat transfer Model */
replaceable model HeatTransfer =
Components.Units.HeatExchangers.MovingBoundary.HeatTransfer.HeatTransferLiquid.HeatTransfer_OffDesign
constrainedby
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer
    "Convective heat transfer"                                                         annotation (Dialog(choicesAllMatching = true));

HeatTransfer heatTransfer( redeclare final package Medium = Medium,
final n=1,
final Mdotnom = Mdotnom,
final Unom = Unom_l,
final M_dot = M_dot_su,
final diameter = diameter,
final surfaceAreas={Ai},
final states={fluidState})
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));

/* Geometric characteristics */
  constant Real pi = Modelica.Constants.pi "pi-greco";

  input Modelica.SIunits.Length length "length of the current segment";

  parameter Modelica.SIunits.Length diameter "diameter of the current segment";

  Modelica.SIunits.Volume Vi = pi*(diameter/2)^2*length
    "Volume of a single cell";
  Modelica.SIunits.Area Ai = 2*pi*diameter/2*length
    "Lateral surface of a single cell";

  parameter Modelica.SIunits.MassFlowRate Mdotnom "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_l
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone ";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_tp
    "if HTtype = LiqVap : heat transfer coefficient, two-phase zone";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom_v
    "if HTtype = LiqVap : heat transfer coefficient, vapor zone";

 /* FLUID INITIAL VALUES */
parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
                                     annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature Tstart "Inlet temperature start value"
     annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=Medium.specificEnthalpy_pT(pstart,Tstart)
    "Start value of enthalpy (initialized by default)"
    annotation (Dialog(tab="Initialization"));
/* NUMERICAL OPTIONS  */
  import ThermoCycle.Functions.Enumerations.Discretizations;
  parameter Discretizations Discretization=ThermoCycle.Functions.Enumerations.Discretizations.centr_diff
    "Selection of the spatial discretization scheme"  annotation (Dialog(tab="Numerical options"));
  parameter Boolean Mdotconst=false
    "Set to yes to assume constant mass flow rate at each node (easier convergence)"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean max_der=false
    "Set to yes to limit the density derivative during phase transitions"
    annotation (Dialog(tab="Numerical options"));
  parameter Boolean filter_dMdt=false
    "Set to yes to filter dMdt with a first-order filter"
    annotation (Dialog(tab="Numerical options"));
  parameter Real max_drhodt=100 "Maximum value for the density derivative"
    annotation (Dialog(enable=filter_dMdt, tab="Numerical options"));
  parameter Modelica.SIunits.Time TT=1
    "Integration time of the first-order filter"
    annotation (Dialog(enable=max_der, tab="Numerical options"));
//enable=filter_dMdt,enable=max_der,
  parameter Boolean steadystate=true
    "if true, sets the derivative of h (working fluids enthalpy in each cell) to zero during Initialization"
    annotation (Dialog(group="Intialization options", tab="Initialization"));
/* FLUID VARIABLES */
  Medium.ThermodynamicState  fluidState;
  Medium.SaturationProperties sat;
  //Medium.Temperature T_sat "Saturation temperature";
  Medium.AbsolutePressure p(start=pstart);
  Modelica.SIunits.MassFlowRate M_dot_su(start=Mdotnom, min=0);
  Modelica.SIunits.MassFlowRate M_dot_ex(start=Mdotnom, min=0);
  Medium.SpecificEnthalpy h(start=hstart)
    "Fluid specific enthalpy at the cells";
  Medium.Temperature T;//(start=Tstart) "Fluid temperature";
  //Modelica.SIunits.Temperature T_wall "Internal wall temperature";
  Medium.Density rho "Fluid cell density";
  Modelica.SIunits.DerDensityByEnthalpy drdh
    "Derivative of density by enthalpy";
  Modelica.SIunits.DerDensityByPressure drdp
    "Derivative of density by pressure";
  Modelica.SIunits.SpecificEnthalpy hnode_su
    "Enthalpy state variable at inlet node";
  Modelica.SIunits.SpecificEnthalpy hnode_ex
    "Enthalpy state variable at outlet node";
  Real dMdt "Time derivative of mass in cell";
  Modelica.SIunits.HeatFlux qdot "heat flux at each cell";
  Real x "Vapor quality";
  Modelica.SIunits.SpecificEnthalpy h_l;
  Modelica.SIunits.SpecificEnthalpy h_v;
  Modelica.SIunits.Power Q_tot "Total heat flux exchanged by the thermal port";
  Modelica.SIunits.Mass M_tot "Total mass of the fluid in the component";

equation
  //Saturation
  sat = Medium.setSat_p(p);
  h_v = Medium.dewEnthalpy(sat);
  h_l = Medium.bubbleEnthalpy(sat);
  //T_sat = Medium.temperature(sat);
  /* Fluid Properties */
  fluidState = Medium.setState_ph(p,h);
  T = Medium.temperature(fluidState);
  rho = Medium.density(fluidState);
  if max_der then
      drdp = min(max_drhodt/10^5, Medium.density_derp_h(fluidState));
      drdh = max(max_drhodt/(-4000), Medium.density_derh_p(fluidState));
  else
      drdp = Medium.density_derp_h(fluidState);
      drdh = Medium.density_derh_p(fluidState);
  end if;
  /* ENERGY BALANCE */
    Vi*rho*der(h) + M_dot_ex*(hnode_ex - h) - M_dot_su*(hnode_su - h) - Vi*der(p) = qdot*Ai
    "Energy balance";

  x = (h - h_l)/(h_v - h_l);
  Q_tot = Ai*qdot "Total heat flow through the thermal port";
  M_tot = Vi*rho;
  Q_tot = heatTransfer.Q_flows[1];

/* MASS BALANCE */
  if filter_dMdt then
      der(dMdt) = (Vi*(drdh*der(h) + drdp*der(p)) - dMdt)/TT
      "Mass derivative for each volume";
       else
      dMdt = Vi*(drdh*der(h) + drdp*der(p));
   end if;
if Mdotconst then
      M_dot_ex = M_dot_su;
   else
      dMdt = -M_dot_ex + M_dot_su;
end if;
if (Discretization==Discretizations.centr_diff) then
      h = (hnode_su + hnode_ex)/2;
else
  hnode_su = h;
     //!! Needs to be modified in case of flow reversal
end if;

//* BOUNDARY CONDITIONS *//
 /* Enthalpies */
 inStream(inlet.h_outflow) = hnode_su;
 hnode_su = inlet.h_outflow;
 outlet.h_outflow = hnode_ex;

 /* pressures */
 p = outlet.p;
 inlet.p = p;
/*Mass Flow*/
 M_dot_su = inlet.m_flow;
 if Mdotconst then
   outlet.m_flow = - M_dot_su + dMdt;
 else
   outlet.m_flow = -M_dot_ex;
 end if;
inlet.Xi_outflow = inStream(outlet.Xi_outflow);
outlet.Xi_outflow = inStream(inlet.Xi_outflow);

/* Thermal port boundary condition */
/*Temperatures */
 //Wall_int.T = heatTransfer.T;
 /*Heat flow */
 // Wall_int.Q_flow = qdot*Ai;
 connect(heatTransfer.heatPorts[1], Wall_int) annotation (Line(
      points={{0,15},{0,42}},
      color={127,0,0},
      smooth=Smooth.None));
initial equation
  if steadystate then
    der(h) = 0;
      end if;
  if filter_dMdt then
    der(dMdt) = 0;
    end if;
  annotation (Diagram(graphics), Icon(graphics={
        Polygon(
          points={{30,-60},{70,-75},{30,-90},{30,-60}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=showDesignFlowDirection),
        Polygon(
          points={{30,-65},{60,-75},{30,-85},{30,-65}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowFlowReversal),
        Line(
          points={{65,-75},{-50,-75}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=showDesignFlowDirection),
                                     Rectangle(
          extent={{-100,44},{100,-44}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}));
end Flow1DimCut_HX;
