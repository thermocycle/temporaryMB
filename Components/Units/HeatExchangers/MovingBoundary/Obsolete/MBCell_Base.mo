within Components.Units.HeatExchangers.MovingBoundary.Obsolete;
model MBCell_Base "1-D lumped fluid flow model with variable length"
  replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);

  /************ Thermal and fluid ports ***********/
  ThermoCycle.Interfaces.Fluid.FlangeA inFlow(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
  ThermoCycle.Interfaces.Fluid.FlangeB outFlow(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));

  /************ Geometric characteristics **************/
  constant Real pi=Modelica.Constants.pi "pi-greco";
  parameter Modelica.SIunits.Area AA "Cross sectional area";
  final parameter Modelica.SIunits.Length rr=sqrt(AA/pi) "radius of the tube";
  parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom=250
    "if HTtype = LiqVap : Heat transfer coefficient, liquid zone ";

  /************ FLUID INITIAL VALUES ***************/
  parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));

  /***************  VARIABLES ******************/
  /* Geometry */
  Modelica.SIunits.Length ll "Lenght of this segment";
  Modelica.SIunits.Velocity dldt "Change of the length with time";
  Modelica.SIunits.Velocity dzdt_a "Change of the inlet position with time";
  Modelica.SIunits.Velocity dzdt_b "Change of the outlet position with time";

  /* Balance variables */
  Modelica.SIunits.MassFlowRate M_dot_a(start=Mdotnom);
  Modelica.SIunits.MassFlowRate M_dot_b(start=Mdotnom);
  Modelica.SIunits.MassFlowRate dMdt(start=0)
    "Change in mass in control volume";

  Modelica.SIunits.HeatFlowRate H_dot_a(start=Mdotnom*hstart);
  Modelica.SIunits.HeatFlowRate H_dot_b(start=Mdotnom*hstart);
  Modelica.SIunits.HeatFlowRate dUdt(start=0)
    "Change in energy in control volume";

  /* State variables */
  Medium.AbsolutePressure pp(start=pstart);
  Medium.SpecificEnthalpy hh(start=hstart);
  Medium.AbsolutePressure pa(start=pstart);
  Medium.SpecificEnthalpy ha(start=hstart);
  Medium.AbsolutePressure pb(start=pstart);
  Medium.SpecificEnthalpy hb(start=hstart);

  /* Fluid property records, original states */
  Medium.ThermodynamicState fluidState =  Medium.setState_ph(pp, hh);
  Medium.SaturationProperties satState =  Medium.setSat_p(pp);
  Medium.ThermodynamicState inletState =  Medium.setState_ph(pa, ha);
  Medium.ThermodynamicState outletState = Medium.setState_ph(pb, hb);

  /* Derived states */
  Medium.ThermodynamicState bubState =    Medium.setBubbleState(satState);
  Medium.ThermodynamicState dewState =    Medium.setDewState(satState);
  Medium.ThermodynamicState critState =   Medium.setState_pT(
    Medium.getCriticalPressure(), Medium.getCriticalTemperature());

  /* Shorter notation for later access */
  Medium.AbsolutePressure p "Fluid pressure, mean";
  Medium.AbsolutePressure p_a "Fluid pressure at inlet";
  Medium.AbsolutePressure p_b "Fluid pressure at outlet";
  Medium.AbsolutePressure p_l "Fluid pressure, saturated liquid";
  Medium.AbsolutePressure p_v "Fluid pressure, saturated vapour";
  Medium.AbsolutePressure p_c "Fluid pressure, critical state";

  Medium.SpecificEnthalpy h "Fluid enthalpy, mean";
  Medium.SpecificEnthalpy h_a "Fluid enthalpy at inlet";
  Medium.SpecificEnthalpy h_b "Fluid enthalpy at outlet";
  Medium.SpecificEnthalpy h_l "Fluid enthalpy, saturated liquid";
  Medium.SpecificEnthalpy h_v "Fluid enthalpy, saturated vapour";
  Medium.SpecificEnthalpy h_c "Fluid enthalpy, critical state";

  Medium.Density rho "Fluid density, mean";
  Medium.Density rho_a "Fluid density at inlet";
  Medium.Density rho_b "Fluid density at outlet";
  Medium.Density rho_l "Fluid density, saturated liquid";
  Medium.Density rho_v "Fluid density, saturated vapour";
  Medium.Density rho_c "Fluid density, critical state";

  Medium.Temperature T "Fluid temperature, mean";
  Medium.Temperature T_a "Fluid temperature at inlet";
  Medium.Temperature T_b "Fluid temperature at outlet";
  Medium.Temperature T_l "Fluid temperature, saturated liquid";
  Medium.Temperature T_v "Fluid temperature, saturated vapour";
  Medium.Temperature T_c "Fluid temperature, critical state";

  /* Partial derivatives of fluid properties */
  Modelica.SIunits.DerDensityByEnthalpy drdh "Fluid state - rho deriv wrt h";
  Modelica.SIunits.DerDensityByPressure drdp "Fluid state - rho deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_l
    "Saturated liquid - h deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_v
    "Saturated vapour - h deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure drdp_l
    "Saturated liquid - rho deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure drdp_v
    "Saturated vapour - rho deriv wrt p";

  /* Total derivatives of fluid properties */
  Real drdt "Fluid state - rho deriv wrt time";

  Real dhdt "Fluid state - h deriv wrt time";
  Real dhdt_a "Inlet state - h deriv wrt time";
  Real dhdt_b "Outlet state - h deriv wrt time";

  Real dpdt "Fluid state - p deriv wrt time";
  //Real dpdt_a "Inlet state - p deriv wrt time";
  //Real dpdt_b "Outlet state - p deriv wrt time";

  /* Additional variables for display purposes */
  Modelica.SIunits.Volume VV = AA*ll "Control volume";
  Modelica.SIunits.Mass MM = rho*VV "Mass in control volume";

  /* Heat transfer */
  Real q_dot;
  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL thermalPortL
    annotation (Placement(transformation(extent={{-20,40},{20,60}})));

equation
  /* Shorter notation for later access */
  p   = Medium.pressure(fluidState);
  p_a = Medium.pressure(inletState);
  p_b = Medium.pressure(outletState);
  p_l = Medium.pressure(bubState);
  p_v = Medium.pressure(dewState);
  p_c = Medium.pressure(critState);

  h   = Medium.specificEnthalpy(fluidState);
  h_a = Medium.specificEnthalpy(inletState);
  h_b = Medium.specificEnthalpy(outletState);
  h_l = Medium.specificEnthalpy(bubState);
  h_v = Medium.specificEnthalpy(dewState);
  h_c = Medium.specificEnthalpy(critState);

  rho   = Medium.density(fluidState);
  rho_a = Medium.density(inletState);
  rho_b = Medium.density(outletState);
  rho_l = Medium.density(bubState);
  rho_v = Medium.density(dewState);
  rho_c = Medium.density(critState);

  T   = Medium.temperature(fluidState);
  T_a = Medium.temperature(inletState);
  T_b = Medium.temperature(outletState);
  T_l = Medium.temperature(bubState);
  T_v = Medium.temperature(dewState);
  T_c = Medium.temperature(critState);

  /* Partial derivatives of fluid properties */
  drdh = Medium.density_derh_p(fluidState);
  drdp = Medium.density_derp_h(fluidState);
  dhdp_l = Medium.dBubbleEnthalpy_dPressure(satState);
  dhdp_v = Medium.dDewEnthalpy_dPressure(satState);
  drdp_l = Medium.dBubbleDensity_dPressure(satState);
  drdp_v = Medium.dDewDensity_dPressure(satState);

  /* Total derivatives of fluid properties */
  drdt = drdp*dpdt + drdh*dhdt;

  //dhdt = der(hh);
  dhdt = 1/2*(dhdt_a + dhdt_b);
  //dhdt_a "Inlet state - h deriv wrt time";
  //dhdt_b "Outlet state - h deriv wrt time";

  dpdt = der(pp);
  //dpdt_a "Inlet state - p deriv wrt time";
  //dpdt_b "Outlet state - p deriv wrt time";

  /* Geometry change */
  der(ll) = dldt;
  dldt = dzdt_a + dzdt_b;

  /* Mass balance */
  dMdt = M_dot_a - M_dot_b;
  ll*drdt + rho*dldt + rho_a*dzdt_a - rho_b*dzdt_b = dMdt/AA;

  /* Energy balance */
  dUdt = H_dot_a - H_dot_b + q_dot "No work is done";
   AA*(rho*dldt*h + rho*ll*dhdt + drdt*ll*h)
  -AA*(ll*dpdt + h_a*rho_a*dzdt_a - h_b*rho_b*dzdt_b)
  = dUdt;

  /* Energy boundaries */
  H_dot_a = M_dot_a*h_a;
  H_dot_b = M_dot_b*h_b;
  q_dot   = thermalPortL.phi*(2*pi*rr*ll);
  T       = thermalPortL.T;

  /* Mass and substance flows, no composition changes */
  M_dot_a = inFlow.m_flow;
  M_dot_b = -outFlow.m_flow;
  inFlow.Xi_outflow  = inStream(outFlow.Xi_outflow);
  outFlow.Xi_outflow = inStream(inFlow.Xi_outflow);
  inFlow.C_outflow  = inStream(outFlow.C_outflow);
  outFlow.C_outflow = inStream(inFlow.C_outflow);
  assert(M_dot_a > -Modelica.Constants.small, "Flow reversal at inlet detected, this case is not tested.");
  assert(M_dot_b > -Modelica.Constants.small, "Flow reversal at outlet detected, this case is not tested.");

  /* Define flow boundaries, no more underscores */
  ha = inStream(inFlow.h_outflow);
  hb = inStream(outFlow.h_outflow);
  pb = outFlow.p;
  pa = inFlow.p;

  /* Define the fluid state */
  hh = 1/2*(ha + hb);
  pp = 1/2*(pa + pb);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          fillColor={175,255,200}),       Text(
          extent={{-80,20},{80,-20}},
          lineColor={0,0,0},
          textString="MBCell")}),
    Documentation(info="<HTML>
          
         <p><big>Model <b>Cell1Dim</b> describes the flow of fluid through a single cell. An overall flow model can be obtained by interconnecting several cells in series 
         (see <em><FONT COLOR=red><a href=\"modelica://ThermoCycle.Components.FluidFlow.Pipes.Flow1Dim\">Flow1Dim</a></FONT></em>).
         
          <p><big><b>Pressure</b> and <b>enthalpy</b> are selected as state variables. 
          <p><big>Two types of variables can be distinguished: cell variables and node variables. Node variables are characterized by the su (supply) and ex (exhaust) subscripts, and correspond to the inlet and outlet nodes at each cell. The relation between the cell and node values depends on the discretization scheme selected. 
 <p><big>The assumptions for this model are:
         <ul><li> Velocity is considered uniform on the cross section. 1-D lumped parameter model
         <li> The model is based on dynamic mass and energy balances and on a static momentum balance
         <li> Constant pressure is assumed in the cell
         <li> Axial thermal energy transfer is neglected
         <li> Thermal energy transfer through the lateral surface is ensured by the <em>wall_int</em> connector. The actual heat flow is computed by the thermal energy model
         </ul>

 <p><big>The model is characterized by two flow connector and one lumped thermal port connector. During normal operation the fluid enters the model from the <em>inFlow</em> connector and exits from the <em>outFlow</em> connector. In case of flow reversal the fluid direction is inversed.
 <p><big> The thermal energy transfer  through the lateral surface is computed by the <em><a href=\"modelica://ThermoCycle.Components.HeatFlow.HeatTransfer.ConvectiveHeatTransfer\">ConvectiveHeatTransfer</a></em> model which is inerithed in the <em>Cell1Dim</em> model. 
        
        <p><b><big>Modelling options</b></p>
        <p><big> In the <b>General</b> tab the following options are availabe:
        <ul><li>Medium: the user has the possibility to easly switch Medium.
        <li> HeatTransfer: the user can choose the thermal energy model he prefers </ul> 
        <p><big> In the <b>Initialization</b> tab the following options are availabe:
        <ul><li> steadystate: If it sets to true, the derivative of enthalpy is sets to zero during <em>Initialization</em> 
         </ul>
        <p><b><big>Numerical options</b></p>
<p><big> In this tab several options are available to make the model more robust:
<ul><li> Discretization: 2 main discretization options are available: UpWind and central difference method. The authors recommend the <em>UpWind Scheme - AllowsFlowReversal</em> in case flow reversal is expected.
<li> Mdotconst: assume constant mass flow rate at each node.
<li> max_der: if true the density derivative is truncated during phase change
<li> filter_dMdt: if true a first order filter is applied to the fast variations of the density with respect to time
<li> max_drhodt: it represents the maximum value of the density derivative. It activates when using max_der is set to true
<li> TT: it represents the integration time of the first order filter. It activates when filter_dMdt is set to true
<li> ComputeSat: if false saturation properties are not computed in the fluid model and they can be passed as a parameter.
 </ul>
 <p><big> 
        </HTML>"));
end MBCell_Base;
