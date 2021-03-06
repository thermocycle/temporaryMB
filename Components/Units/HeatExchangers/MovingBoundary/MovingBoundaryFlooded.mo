within Components.Units.HeatExchangers.MovingBoundary;
model MovingBoundaryFlooded

/* Define fluid for both side  */
  replaceable package Medium1 = CoolProp2Modelica.Interfaces.CoolPropMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid (cold)" annotation (choicesAllMatching=true);
  replaceable package Medium2 = CoolProp2Modelica.Interfaces.CoolPropMedium                           constrainedby
    Modelica.Media.Interfaces.PartialMedium "Hot fluid" annotation (choicesAllMatching=true);

/**** PARAMETERS *******/
/*geometrical parameter */
constant Real pi = Modelica.Constants.pi;
parameter Modelica.SIunits.Area AA = 1 "Cross sectional area of tube";
final parameter Modelica.SIunits.Length rr = sqrt(AA/(2*pi))
    "radius of the tube";
parameter Modelica.SIunits.Length LL = 2 "Total length of the Hx";
/** Metal Wall **/
parameter Modelica.SIunits.Mass M_w "Wall: TotalMass";
parameter Modelica.SIunits.SpecificHeatCapacity c_w "Wall: Cp";
parameter Modelica.SIunits.SpecificHeatCapacity c_sf "SF: Cp";
/* Heat transfer parameter */
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_sc
    "Heat transfer coefficient sub-cooled side";
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_tp
    "Heat transfer coefficient two-phase side";
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_sf
    "Secondary fluid Heat transfer coefficient sub-cooled side";

/** VARIABLES **/
/*length*/
Modelica.SIunits.Length l_sc( start= 0) "SC: length of the sub-cooled region";
Modelica.SIunits.Length l_tp "SC: length of the sub-cooled region";
/* MassFlow */
Modelica.SIunits.MassFlowRate m_dot_su( start = 0)
    "SU: MassFlow at inlet of Hx";
Modelica.SIunits.MassFlowRate m_dot_a "A: MassFlow at SC-TP interface";
Modelica.SIunits.MassFlowRate m_dot_ex( start = 0) "EX: MassFlow at outlet Hx";
Modelica.SIunits.MassFlowRate m_dot_sf "SF: MassFlow of the secondary fluid";
/* Thermodynamic states*/
Medium1.ThermodynamicState subCooled "SC: sub-cooled thermodynamic state";
Medium1.SaturationProperties sat "TP: Two-phase thermpdynamic state";
//Medium1.ThermodynamicState meanState "TP: state at the middle of the two-phase";
Medium1.ThermodynamicState outlet "EX: Outlet thermodynamic state";
/*  PRESSURE */
Modelica.SIunits.Pressure p_wf( start = 0) "Pressure of the working fluid";
/** TEMPERATURES **/
/* ¨Primary fluid */
Modelica.SIunits.Temperature T_su "SU: T at the inlet of Hx";
Modelica.SIunits.Temperature T_sc(start = 273.15) "SC: T of sub-cooled";
//Modelica.SIunits.Temperature T_a "A: T at SC-TP interface NOT USED";
Modelica.SIunits.Temperature T_tp(start = 273.15)
    "TP: T of the two-phase region";
Modelica.SIunits.Temperature T_ex "EX: T at the outlet of Hx";

/* Wall */
Modelica.SIunits.Temperature Tw_1( start = 273.15)
    "SU_wall: T at the inlet of the Hx";
Modelica.SIunits.Temperature Tw_sc(  start = 273.15)
    "SC_wall: T of sub-cooled zone";
Modelica.SIunits.Temperature Tw_a "A_wall: T at the SB-TP interface";
Modelica.SIunits.Temperature Tw_tp(  start = 273.15)
    "TP_wall: T of the two phase zone";
Modelica.SIunits.Temperature Tw_2( start = 273.15)
    "EX_wall: T at the outlet of the Hxr";

/* Secondary fluid */
Modelica.SIunits.Temperature Tsf_su( start = 273.15)
    "SF_SU: T at the inlet of the Hx";
Modelica.SIunits.Temperature Tsf_a "SF_A: T at the SC-TP interface";
Modelica.SIunits.Temperature Tsf_ex( start = 273.15)
    "SF_EX: T at the outlet of the Hx";

/** THERMODYNAMIC PROPERTIES OF THE WORKING FLUID **/
/* Enthalpies */
Modelica.SIunits.SpecificEnthalpy h_su "SU: h at the inlet";
Modelica.SIunits.SpecificEnthalpy h_sc "SC: h of the SC region";
Modelica.SIunits.SpecificEnthalpy h_a "SC_TP: h at the SC-TP region";
Modelica.SIunits.SpecificEnthalpy h_sl "TP: h of saturated liquid";
Modelica.SIunits.SpecificEnthalpy h_sv "TP: h of saturated vapor";
Modelica.SIunits.SpecificEnthalpy h_ex( start = 0) "EX: h at the outlet";

/* Enthalpy derivatives */
Real der_h_a "SC_TP: h deriv at outlet of SC region ";
Modelica.SIunits.DerEnthalpyByPressure dhdp_sl "TP:SatLiq - h deriv wrt p";
Modelica.SIunits.DerEnthalpyByPressure dhdp_sv "TP: SatVap - h deriv wrt p";

/*Density */
Modelica.SIunits.Density rho_sc "SC: D";
Modelica.SIunits.Density rho_a "A: D at the SC-TP interface";
Modelica.SIunits.Density rho_sl "TP: SatLiq - D of saturated liquid";
Modelica.SIunits.Density rho_sv "TP: SatVap - D of saturated vapor";

/* Density derivatives */
Real DrhoDt_sc "SC: D derivative wrt time";
Modelica.SIunits.DerDensityByEnthalpy drdh_sc "SC : D deriv wrt h at const. p";
Modelica.SIunits.DerDensityByPressure drdp_sc "SC : D deriv wrt p at const. h";

Modelica.SIunits.DerDensityByPressure drdp_sl "TP: SatLiq - D deriv wrt p ";
Modelica.SIunits.DerDensityByPressure drdp_sv "TP: SatVap - D deriv wrt p";

/** HEAT TRANSFER **/
Modelica.SIunits.ThermodynamicTemperature LMTD_sc_wf(displayUnit="K");
Real  NTU_tp;
Real C_dot_tp;
Real epsilon_tp;
Modelica.SIunits.ThermodynamicTemperature LMTD_sc_sf(displayUnit="K");
Modelica.SIunits.ThermodynamicTemperature LMTD_tp_sf(displayUnit="K");

Modelica.SIunits.ThermodynamicTemperature pinch_sc_wf(displayUnit="K",min=1);
Modelica.SIunits.ThermodynamicTemperature pinch_sc_sf(displayUnit="K",min=1);
//Modelica.SIunits.ThermodynamicTemperature pinch_tp_wf(displayUnit="K",min=1);
Modelica.SIunits.ThermodynamicTemperature pinch_tp_sf(displayUnit="K",min=1);
  Modelica.SIunits.ThermalConductance AU_sc_wf;
  Modelica.SIunits.ThermalConductance AU_tp_wf;
  Modelica.SIunits.ThermalConductance AU_sc_sf;
  Modelica.SIunits.ThermalConductance AU_tp_sf;

/* Heat flow */
Modelica.SIunits.Power Q_sc_wf "SC: Q wf to wall";
Modelica.SIunits.Power Q_sc_sf "SC: Q wf to wall";
Modelica.SIunits.Power Q_tp_wf "SC: Q wf to wall";
Modelica.SIunits.Power Q_tp_sf "SC: Q wf to wall";

/* Void fraction */
parameter Real VV = 0.2 "Average Void fraction";
parameter Real DVVdt = 0.002 "Derivative of Void fraction wrt Time";

/*** CONNECTORS ***/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow_wf( redeclare package Medium =
        Medium1)
    annotation (Placement(transformation(extent={{-108,-68},{-88,-48}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_wf( redeclare package Medium =
        Medium1)
    annotation (Placement(transformation(extent={{86,-68},{106,-48}})));
  ThermoCycle.Interfaces.Fluid.FlangeA_pT InFlow_sf( redeclare package Medium
      =                                                                          Medium2)
    annotation (Placement(transformation(extent={{86,44},{106,64}})));
  ThermoCycle.Interfaces.Fluid.FlangeB_pT OutFlow_sf( redeclare package Medium
      =                                                                          Medium2)
    annotation (Placement(transformation(extent={{-108,50},{-88,70}})));

equation
LL = l_sc + l_tp;

  /*** SUB-COOLED REGION ***/
  subCooled = Medium1.setState_ph(p_wf,h_sc);
  h_sc = 1/2*(h_su+h_a);
  T_su = Medium1.temperature_ph(p_wf,h_su);
  T_sc =  Medium1.temperature(subCooled);
  rho_sc = Medium1.density(subCooled);
  drdh_sc = Medium1.density_derh_p(subCooled);
  drdp_sc = Medium1.density_derp_h(subCooled);
  /*Mass balance wf*/
  AA*(DrhoDt_sc*l_sc +rho_sc*der(l_sc)) - AA*rho_a*der(l_sc) = m_dot_su - m_dot_a;
  DrhoDt_sc =  drdp_sc*der(p_wf) + 1/2*drdh_sc*(der(h_su)+der_h_a);

  der_h_a = dhdp_sl*der(p_wf);
  rho_a = rho_sl;
  h_a = h_sl;

 /* Energy balance wf*/
  AA*(rho_sc*h_sc*der(l_sc) + h_sc*l_sc*DrhoDt_sc + rho_sc*l_sc*1/2*drdh_sc*(der(h_su)+der_h_a)) - AA*rho_a*h_a*der(l_sc) -AA*l_sc*der(p_wf) = m_dot_su*h_su - m_dot_a*h_a + Q_sc_wf;

 /* Heat transfer wf */
  AU_sc_wf = 2*pi*rr*l_sc*U_sc;
  Q_sc_wf = AU_sc_wf*LMTD_sc_wf;
  LMTD_sc_wf = homotopy(ThermoCycle.Functions.LMTD_robust(Tw_1 - T_su, Tw_a -T_tp), max(0, pinch_sc_wf));
  pinch_sc_wf = min(Tw_1-T_su,Tw_a-T_tp);
  Q_sc_wf = (m_dot_su+m_dot_a)/2*(h_a - h_su);

 /* Energy balance wall*/
  (c_w*M_w/LL)*(l_sc*der(Tw_sc) + (Tw_sc - Tw_a)*der(l_sc)) = Q_sc_sf - Q_sc_wf;
   //Tw_sc = Tw_1 + (Tw_a - Tw_1)/2;
   Tw_a = (Tw_sc*l_tp + Tw_tp*l_sc)/(LL);

 /*Secondary fluid */
   AU_sc_sf = 2*pi*rr*l_sc*U_sf;
   LMTD_sc_sf=  homotopy(ThermoCycle.Functions.LMTD_robust(Tsf_ex - Tw_1, Tsf_a - Tw_a),max(0, pinch_sc_sf));
   pinch_sc_sf = min(Tsf_ex - Tw_1,Tsf_a - Tw_a);
   Q_sc_sf = AU_sc_sf*LMTD_sc_sf;
   Q_sc_sf = m_dot_sf*c_sf*(Tsf_a - Tsf_ex);

 /*** TWO-PHASE REGION ***/
  sat = Medium1.setSat_p(p_wf);
  T_tp = Medium1.saturationTemperature_sat(sat);
  h_sl = Medium1.bubbleEnthalpy(sat);
  h_sv = Medium1.dewEnthalpy(sat);
  rho_sl = Medium1.bubbleDensity(sat);
  rho_sv = Medium1.dewDensity(sat);
  drdp_sl = Medium1.dBubbleDensity_dPressure(sat);
  drdp_sv = Medium1.dDewDensity_dPressure(sat);
  dhdp_sl = Medium1.dBubbleEnthalpy_dPressure(sat);
  dhdp_sv = Medium1.dDewEnthalpy_dPressure(sat);

  /* Mass Balance wf */
  AA*(-der(l_sc)*(rho_sv*VV + (1-VV)*rho_sl) + (l_tp)*((rho_sv - rho_sl)*DVVdt + VV*drdp_sv*der(p_wf) + (1-VV)*drdp_sl*der(p_wf))) + AA*rho_a*der(l_sc) = m_dot_a - m_dot_ex;

  /* Energy Balance wf */
 AA*(-der(l_sc)*(rho_sv*h_sv*VV +(1-VV)*rho_sl*h_sl) +
  l_tp*(DVVdt*(rho_sv*h_sv - rho_sl*h_sl) + VV*h_sv*drdp_sv*der(p_wf) + VV*rho_sv*dhdp_sv*der(p_wf) + (1-VV)*drdp_sl*der(p_wf)*h_sl + (1-VV)*rho_sl*dhdp_sl*der(p_wf)))
   +AA*rho_a*h_a*der(l_sc) - AA*l_tp*der(p_wf) = m_dot_a*h_a - m_dot_ex*h_ex + Q_tp_wf;

/*Heat transfer wf */
AU_tp_wf = 2*pi*rr*l_tp*U_tp;
C_dot_tp = (m_dot_a+m_dot_ex)/2*(Medium1.specificHeatCapacityCp(subCooled)+Medium1.specificHeatCapacityCp(outlet));
NTU_tp = AU_tp_wf/C_dot_tp;
epsilon_tp = 1-exp(-NTU_tp);
Q_tp_wf = epsilon_tp*C_dot_tp*(Tw_tp -T_tp);

//pinch_tp_wf = Tw_tp - T_tp;

/*Energy balance wall*/
 (c_w*M_w/LL)*(l_tp*der(Tw_tp) - (Tw_a - Tw_tp)*der(l_sc)) = Q_tp_sf - Q_tp_wf;
  Tw_tp = Tw_a + (Tw_2 - Tw_a)/2;

/*Secondary fluid */
   AU_tp_sf = 2*pi*rr*l_tp*U_sf;
   LMTD_tp_sf=  homotopy(ThermoCycle.Functions.LMTD_robust(Tsf_su - Tw_2, Tsf_a - Tw_a),max(0, pinch_tp_sf));
   pinch_tp_sf = min(Tsf_su - Tw_2,Tsf_a - Tw_a);
   Q_tp_sf = AU_tp_sf*LMTD_tp_sf;
   Q_tp_sf = m_dot_sf*c_sf*(Tsf_su - Tsf_a);

   outlet = Medium1.setState_ph(p_wf,h_ex);
   T_ex = Medium1.temperature(outlet);

/* BOUNDARY CONDITION */
p_wf = InFlow_wf.p;
p_wf = OutFlow_wf.p;
h_su = inStream(InFlow_wf.h_outflow);
h_su = InFlow_wf.h_outflow;
h_ex = OutFlow_wf.h_outflow;
m_dot_su = InFlow_wf.m_flow;
m_dot_ex = -OutFlow_wf.m_flow;

/* Secondary fluid */
//InFlow_sf.T_outflow = inStream(OutFlow_sf.T_outflow);
Tsf_su = inStream(InFlow_sf.T_outflow);
Tsf_su = InFlow_sf.T_outflow;
Tsf_ex = OutFlow_sf.T_outflow;
InFlow_sf.m_flow = m_dot_sf;
 m_dot_sf = -OutFlow_sf.m_flow;
InFlow_sf.p = OutFlow_sf.p;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end MovingBoundaryFlooded;
