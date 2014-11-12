within Components.Units.HeatExchangers.MovingBoundary;
model Cell_OnePhase_Base_SH "1-D lumped fluid flow model (Real fluid model)"
replaceable package Medium = ThermoCycle.Media.DummyFluid constrainedby
    Modelica.Media.Interfaces.PartialMedium
annotation (choicesAllMatching = true);

  /************ Thermal and fluid ports ***********/
 ThermoCycle.Interfaces.Fluid.FlangeA inFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}}),
        iconTransformation(extent={{-120,-20},{-80,20}})));
 ThermoCycle.Interfaces.Fluid.FlangeB outFlow(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
        iconTransformation(extent={{80,-18},{120,20}})));

  /************ Geometric characteristics **************/
  constant Real pi=Modelica.Constants.pi "pi-greco";
  parameter Modelica.SIunits.Area AA "Cross sectional area";
  final parameter Modelica.SIunits.Length rr=sqrt(AA/pi) "radius of the tube";
  parameter Modelica.SIunits.MassFlowRate Mdotnom=0 "Nominal fluid flow rate";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer Unom=250;

  /************ FLUID INITIAL VALUES ***************/
  parameter Modelica.SIunits.Pressure pstart "Fluid pressure start value"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.SpecificEnthalpy hstart=1E5 "Start value of enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Length lstart=1 "Start value of length"
    annotation (Dialog(tab="Initialization"));

  /***************  VARIABLES ******************/
  /* Geometry */
  parameter Modelica.SIunits.Length ll "Lenght of this segment";
  //Modelica.SIunits.Length lll(start=lstart) "Lenght of this segment";
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

  /* Fluid property records, original states */
  Medium.ThermodynamicState fluidState =  Medium.setState_ph(pp,hh);
  Medium.SaturationProperties satState =  Medium.setSat_p(pp);

  /* Shorter notation for later access */
  Medium.AbsolutePressure pp(start=pstart) "Fluid pressure, mean";
  Medium.AbsolutePressure p_a(start=pstart) "Fluid pressure at inlet";
  Medium.AbsolutePressure p_b(start=pstart) "Fluid pressure at outlet";

  Medium.SpecificEnthalpy hh(start=hstart) "Fluid enthalpy, mean";
  Medium.SpecificEnthalpy h_a "Fluid enthalpy at inlet";
  Medium.SpecificEnthalpy h_b "Fluid enthalpy at outlet";
  Medium.SpecificEnthalpy h_l "Fluid enthalpy, saturated liquid";
  Medium.SpecificEnthalpy h_v "Fluid enthalpy, saturated vapour";

  Medium.Density rho "Fluid density, mean";
  Medium.Density rho_a "Fluid density at inlet";
  Medium.Density rho_b "Fluid density at outlet";
  Medium.Density rho_l "Fluid density, saturated liquid";
  Medium.Density rho_v "Fluid density, saturated vapour";
  Medium.Temperature TT "Fluid temperature, mean";

  /* Partial derivatives of fluid properties */
  Modelica.SIunits.DerDensityByEnthalpy drdh "Fluid state - rho deriv wrt h";
  Modelica.SIunits.DerDensityByPressure drdp "Fluid state - rho deriv wrt p";
  Modelica.SIunits.DerEnthalpyByPressure dhdp_l;
  Modelica.SIunits.DerEnthalpyByPressure dhdp_v;

  /* Total derivatives of fluid properties */
  Real drdt "Fluid state - rho deriv wrt time";
  Real dpdt "Fluid state - p deriv wrt time";
  Real dhdt "Fluid state - h deriv wrt time";
  Real dhdt_a "Inlet state - h deriv wrt time";
  Real dhdt_b "Outlet state - h deriv wrt time";

  /* Additional variables for display purposes */
  Modelica.SIunits.Volume Volume = AA*ll "Control volume";
  Modelica.SIunits.Mass MM = rho*Volume "Mass in control volume";

 Real tFactor;
 output Real ll_output;
 Real AU;
 Real C_dot;
 Real NTU;
 Real epsilon;
 Real q_dot;
  ThermoCycle.Interfaces.HeatTransfer.ThermalPortL thermalPortL
    annotation (Placement(transformation(extent={{-20,40},{20,60}})));

equation
  ll = ll_output;
//   if (ll<=1e-3) then
//     rho_b = rho_a;
//     rho_a = Medium.density_ph(pp,h_a);
//     dzdt_a = 0;
//     dldt = 0;
//     dhdt_a = der(inFlow.h_outflow);
//     dhdt_b = dhdt_a;
//     h_b = h_a;
//     /* Mass balance */
//     //ll = Modelica.Constants.small;
//     dMdt = M_dot_a - M_dot_b;
//     //dMdt = 0;
//     //ll*drdt + rho*dldt + rho_a*dzdt_a - rho_b*dzdt_b = dMdt/AA;
//     /* Energy balance */
//     //dUdt = 0;
//     dUdt = H_dot_a - H_dot_b + q_dot "No work is done";
//    dUdt = 0;
//     //rho*hh*dldt + rho*ll*dhdt + drdt*hh*ll - ll*dpdt + h_a*rho_a*dzdt_a - h_b*rho_b*dzdt_b = dUdt/AA;
//     active = false;
//   else
//     rho_b = rho_l; /* Fictisus value not use in the equation */
//     rho_a = Medium.density_ph(pp,h_a);
//     dldt = der(ll);
//     dzdt_a = 0;
//     dhdt_a = der(inFlow.h_outflow);
//     dhdt_b = dhdp_l*dpdt;
//     h_b = h_l;
//     /* Mass balance */
//     dMdt = M_dot_a - M_dot_b;
//     ll*drdt + rho*dldt + rho_a*dzdt_a - rho_b*dzdt_b = dMdt/AA;
//     /* Energy balance */
//     dUdt = H_dot_a - H_dot_b + q_dot "No work is done";
//     rho*hh*dldt + rho*ll*dhdt + drdt*hh*ll - ll*dpdt + h_a*rho_a*dzdt_a - h_b*rho_b*dzdt_b = dUdt/AA;
//     active = true;
//   end if;

    //rho_a = Medium.density_ph(pp,h_a);
    rho_a = Medium.density_ph(p_a,h_a);
    rho_b  = Medium.density_ph(p_b,h_b);

    dhdt_a = der(inFlow.h_outflow);
    dhdt_b = der(outFlow.h_outflow);

    dzdt_a = 0;
    dldt   = 0;
    dzdt_b = 0;

    //h_b    = ;

    /* Mass balance */
    dMdt = M_dot_a - M_dot_b;
    /* Energy balance */
    dUdt = H_dot_a - H_dot_b + q_dot "No work is done";

    dMdt   = (ll*drdt + rho*dldt + rho_a*dzdt_a - rho_b*dzdt_b) * AA;
    dUdt   = (rho*hh*dldt + rho*ll*dhdt + drdt*hh*ll - ll*dpdt + h_a*rho_a*dzdt_a - h_b*rho_b*dzdt_b) * AA;

  //tFactor = 1 - ThermoCycle.Functions.transition_factor(start=h_l-10,stop=h_l-1,position=h_a);
  tFactor = 0;

//   dMdt   = tFactor*0      + (1 - tFactor)*(ll*drdt + rho*dldt + rho_a*dzdt_a - rho_b*dzdt_b) * AA;
//   dUdt   = tFactor*0      + (1 - tFactor)*(rho*hh*dldt + rho*ll*dhdt + drdt*hh*ll - ll*dpdt + h_a*rho_a*dzdt_a - h_b*rho_b*dzdt_b) * AA;
//   h_b    = tFactor*h_a    + (1 - tFactor)*h_l;
//   dhdt_b = tFactor*dhdt_a + (1 - tFactor)*dhdp_l*dpdt;
//   rho_b  = tFactor*rho_a  + (1 - tFactor)*rho_l;

  /* Fluid Properties */
  hh = 1/2*(h_a + h_b);
  pp = 1/2*(p_a + p_b);
  dhdt = 1/2*(dhdt_a + dhdt_b);

  /* Shorter notation for later access */
  TT = Medium.temperature(fluidState);
  rho = Medium.density(fluidState);
  drdh = Medium.density_derh_p(fluidState);
  drdp = Medium.density_derp_h(fluidState);
  dpdt = der(pp);
  drdt = drdp*dpdt + drdh*(dhdt_a+dhdt_b);

  /* Two-phase properties */
  h_v = Medium.dewEnthalpy(satState);
  h_l = Medium.bubbleEnthalpy(satState);
  rho_v =  Medium.dewDensity(satState);
  rho_l = Medium.bubbleDensity(satState);
  dhdp_l = Medium.dBubbleEnthalpy_dPressure(satState);
  dhdp_v = Medium.dDewEnthalpy_dPressure(satState);

  /* Heat transfer */
  AU = 2*pi*rr*ll*Unom;
  C_dot = (M_dot_a+M_dot_b)/2*Medium.specificHeatCapacityCp(fluidState);
  NTU = AU/C_dot;
  epsilon =  1 - exp(-NTU);

  /* Energy boundaries */
  H_dot_a = M_dot_a*h_a;
  H_dot_b = M_dot_b*h_b;
  q_dot   = thermalPortL.phi*(2*pi*rr*ll);
  TT      = thermalPortL.T;

  //* BOUNDARY CONDITIONS *//
  /* Enthalpies */

 //   h_b = if noEvent(M_dot_b >= 0) then hh else inStream(outFlow.h_outflow);  ///
  //  h_a = if noEvent(M_dot_a <= 0) then hh else inStream(inFlow.h_outflow);

  h_a = inStream(inFlow.h_outflow);
  inFlow.h_outflow = h_a;
  outFlow.h_outflow = h_b;

  /* pressures */
  p_b = outFlow.p;
  p_a = inFlow.p;
  p_a = outFlow.p;

  /* Mass and substance flows, no composition changes */
  M_dot_a = inFlow.m_flow;
  M_dot_b = -outFlow.m_flow;
  inFlow.Xi_outflow  = inStream(outFlow.Xi_outflow);
  outFlow.Xi_outflow = inStream(inFlow.Xi_outflow);
  inFlow.C_outflow  = inStream(outFlow.C_outflow);
  outFlow.C_outflow = inStream(inFlow.C_outflow);
//  assert(M_dot_a > -Modelica.Constants.small, "Flow reversal at inlet detected, this case is not tested.");
//  assert(M_dot_b > -Modelica.Constants.small, "Flow reversal at outlet detected, this case is not tested.");

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={Rectangle(
          extent={{-92,40},{88,-40}},
          lineColor={0,0,255},
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-88,24},{92,-20}},
          lineColor={0,0,255},
          textString="%Cell1D")}),Documentation(info="<HTML>
          
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
end Cell_OnePhase_Base_SH;
