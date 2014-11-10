within Components.Units.HeatExchangers.MovingBoundary;
model MovingBoundary_NTU

/* Define fluid for both side  */
  replaceable package Medium1 = CoolProp2Modelica.Interfaces.CoolPropMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium "Working fluid (cold)" annotation (choicesAllMatching=true);

/**** PARAMETERS *******/
/*geometrical parameter */
constant Real pi = Modelica.Constants.pi;
parameter Modelica.SIunits.Area AA = 1 "Cross sectional area of tube";
final parameter Modelica.SIunits.Length rr = sqrt(AA/pi) "radius of the tube";
parameter Modelica.SIunits.Length LL = 2 "Total length of the Hx";
/** Metal Wall **/
parameter Modelica.SIunits.Mass M_w "Wall: TotalMass";
parameter Modelica.SIunits.SpecificHeatCapacity c_w "Wall: Cp";
Modelica.SIunits.SpecificHeatCapacity c_sf "SF: Cp";
Modelica.SIunits.Density rho_sf "Density of the secondary fluid at the inlet";
/* Heat transfer parameter */
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_sc
    "Heat transfer coefficient sub-cooled side";
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_tp
    "Heat transfer coefficient two-phase side";
    parameter Modelica.SIunits.CoefficientOfHeatTransfer U_sh
    "Heat transfer coefficient superHeated side";
parameter Modelica.SIunits.CoefficientOfHeatTransfer U_sf
    "Secondary fluid Heat transfer coefficient sub-cooled side";

/** VARIABLES **/
/*length*/
Modelica.SIunits.Length l_sc( start= 0) "SC: length of the sub-cooled region";
Modelica.SIunits.Length l_tp( start=0) "SC: length of the sub-cooled region";
Modelica.SIunits.Length l_sh "SC: length of the sub-cooled region";
/* MassFlow */
Modelica.SIunits.MassFlowRate m_dot_su "SU: MassFlow at inlet of Hx";
Modelica.SIunits.MassFlowRate m_dot_a "A: MassFlow at SC-TP interface";
Modelica.SIunits.MassFlowRate m_dot_b "A: MassFlow at SC-TP interface";
Modelica.SIunits.MassFlowRate m_dot_ex "EX: MassFlow at outlet Hx";
Modelica.SIunits.MassFlowRate m_dot_sf "SF: MassFlow of the sf";

/* Thermodynamic states*/
Medium1.ThermodynamicState subCooled "SC: sub-cooled thermodynamic state";
Medium1.SaturationProperties sat "TP: Two-phase thermpdynamic state";
Medium1.ThermodynamicState superHeated "SH: SuperHeated thermodynamic state";
Medium1.ThermodynamicState outlet "EX: Outlet thermodynamic state";

/*  PRESSURE */
Modelica.SIunits.Pressure p_wf(start = 0) "Pressure of the working fluid";

/** TEMPERATURES **/
/* ¨Primary fluid */
Modelica.SIunits.Temperature T_su "SU: T at the inlet of Hx";
Modelica.SIunits.Temperature T_sc "SC: T of sub-cooled";
Modelica.SIunits.Temperature T_tp "TP: T of the two-phase region";
Modelica.SIunits.Temperature T_sh "SH: T of the super-heated region";
Modelica.SIunits.Temperature T_ex "EX: T at the outlet of Hx";

/* Wall */
Modelica.SIunits.Temperature Tw_sc(start = 273.15)
    "SC_wall: T of sub-cooled zone";
Modelica.SIunits.Temperature Tw_a "A_wall: T at the SB-TP interface";
Modelica.SIunits.Temperature Tw_tp(start = 273.15)
    "TP_wall: T of the two phase zone";
Modelica.SIunits.Temperature Tw_b "B_wall: T at the TP-SH interface";
    Modelica.SIunits.Temperature Tw_sh(start = 273.15)
    "SH_wall: T of superheated zone";

/* Secondary fluid */
Modelica.SIunits.Temperature Tsf_su(start = 273.15)
    "SF_SU: T at the inlet of the Hx";
Modelica.SIunits.Temperature Tsf_sh "SF_TP: T of sf at the two-phase region";
Modelica.SIunits.Temperature Tsf_b "SF_B: T of sf at the TP-SH interface";
Modelica.SIunits.Temperature Tsf_tp "SF_TP: T of sf at the two-phase region";
Modelica.SIunits.Temperature Tsf_a "SF_A: T of sf at the SC-TP interface";
Modelica.SIunits.Temperature Tsf_sc "SF_SC: T of sf at the SC region";
Modelica.SIunits.Temperature Tsf_ex( start = 273.15)
    "SF_EX: T of sf at the outlet of the Hx";

/** THERMODYNAMIC PROPERTIES OF THE WORKING FLUID **/
/* Enthalpies */
Modelica.SIunits.SpecificEnthalpy h_su "SU: h at the inlet";
Modelica.SIunits.SpecificEnthalpy h_sc "SC: h of the SC region";
Modelica.SIunits.SpecificEnthalpy h_a "A: h at the SC-TP region";
Modelica.SIunits.SpecificEnthalpy h_b "B: h at the TP-SH region";
Modelica.SIunits.SpecificEnthalpy h_sl "TP: h of saturated liquid";
Modelica.SIunits.SpecificEnthalpy h_sv "TP: h of saturated vapor";
Modelica.SIunits.SpecificEnthalpy h_sh "SH: h of SH region";
Modelica.SIunits.SpecificEnthalpy h_ex(start = 0) "EX: h at the outlet";

/* Enthalpy derivatives */
Real der_h_a "SC_TP: h deriv at outlet of SC region ";
Real der_h_b "TP-SH: h deriv at outlet of TP region ";
Modelica.SIunits.DerEnthalpyByPressure dhdp_sl "TP:SatLiq - h deriv wrt p";
Modelica.SIunits.DerEnthalpyByPressure dhdp_sv "TP: SatVap - h deriv wrt p";

/*Density */
Modelica.SIunits.Density rho_sc "SC: D";
Modelica.SIunits.Density rho_a "A: D at the SC-TP interface";
Modelica.SIunits.Density rho_b "B: D at the TP-SH interface";
Modelica.SIunits.Density rho_sl "TP: SatLiq - D of saturated liquid";
Modelica.SIunits.Density rho_sv "TP: SatVap - D of saturated vapor";
Modelica.SIunits.Density rho_sh "SH: D at the SH region";

/* Density derivatives */
Real DrhoDt_sc "SC: D derivative wrt time";
Real DrhoDt_sh "SH: D derivative wrt time";
Modelica.SIunits.DerDensityByEnthalpy drdh_sc "SC : D deriv wrt h at const. p";
Modelica.SIunits.DerDensityByPressure drdp_sc "SC : D deriv wrt p at const. h";

Modelica.SIunits.DerDensityByPressure drdp_sl "TP: SatLiq - D deriv wrt p ";
Modelica.SIunits.DerDensityByPressure drdp_sv "TP: SatVap - D deriv wrt p";

Modelica.SIunits.DerDensityByEnthalpy drdh_sh "SH : D deriv wrt h at const. p";
Modelica.SIunits.DerDensityByPressure drdp_sh "SH : D deriv wrt p at const. h";

/** HEAT TRANSFER **/
/* SubCooled region */
Modelica.SIunits.ThermalConductance AU_sc;
Real NTU_sc;
Real C_dot_sc;
Real epsilon_sc;
Modelica.SIunits.ThermalConductance AU_sc_sf;
Real NTU_sc_sf;
Real epsilon_sc_sf;

/* Two-phase region */
Modelica.SIunits.ThermalConductance AU_tp;
Real  NTU_tp;
Real C_dot_tp;
Real epsilon_tp;
Modelica.SIunits.ThermalConductance AU_tp_sf;
Real  NTU_tp_sf;
Real epsilon_tp_sf;

/* SuperHeated region */
Modelica.SIunits.ThermalConductance AU_sh;
Real NTU_sh;
Real C_dot_sh;
Real epsilon_sh;
Modelica.SIunits.ThermalConductance AU_sh_sf;
Real NTU_sh_sf;
Real epsilon_sh_sf;

Real C_dot_sf;

/* Heat flow */
Modelica.SIunits.Power Q_sc_wf "SC: Q wf to wall";
Modelica.SIunits.Power Q_sc_sf "SC: Q wf to wall";
Modelica.SIunits.Power Q_tp_wf "SC: Q wf to wall";
Modelica.SIunits.Power Q_tp_sf "SC: Q wf to wall";
Modelica.SIunits.Power Q_sh_wf "SC: Q wf to wall";
Modelica.SIunits.Power Q_sh_sf "SC: Q wf to wall";

/* Void fraction */
parameter Real VV = 0.2 "Average Void fraction";
parameter Real DVVdt = 0 "Derivative of Void fraction wrt Time";

/*** CONNECTORS ***/
  ThermoCycle.Interfaces.Fluid.FlangeA InFlow_wf( redeclare package Medium =
        Medium1)
    annotation (Placement(transformation(extent={{-108,-68},{-88,-48}})));
  ThermoCycle.Interfaces.Fluid.FlangeB OutFlow_wf( redeclare package Medium =
        Medium1)
    annotation (Placement(transformation(extent={{86,-68},{106,-48}})));
   ThermoCycle.Interfaces.Fluid.Flange_Cdot InFlow_sf
    annotation (Placement(transformation(extent={{86,44},{106,64}})));
  ThermoCycle.Interfaces.Fluid.Flange_ex_Cdot OutFlow_sf
    annotation (Placement(transformation(extent={{-108,50},{-88,70}})));

equation
LL = l_sc + l_tp + l_sh;

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
  AA*(rho_sc*h_sc*der(l_sc) + h_sc*l_sc*DrhoDt_sc + rho_sc*l_sc*1/2*(der(h_su)+der_h_a)) - AA*rho_a*h_a*der(l_sc) -AA*l_sc*der(p_wf) = m_dot_su*h_su - m_dot_a*h_a + Q_sc_wf;

 /* Heat transfer wf */
  AU_sc = 2*pi*rr*l_sc*U_sc;
  C_dot_sc = (m_dot_su+m_dot_a)/2*Medium1.specificHeatCapacityCp(subCooled);
  NTU_sc = AU_sc/C_dot_sc;
  epsilon_sc =  1 - exp(-NTU_sc);
  Q_sc_wf = C_dot_sc*epsilon_sc*(Tw_sc - T_su);

 /* Energy balance wall*/
  (c_w*M_w/LL)*(l_sc*der(Tw_sc) + (Tw_sc - Tw_a)*der(l_sc)) = Q_sc_sf - Q_sc_wf;

   //Tw_a = (Tw_sc*l_tp + Tw_tp*l_sc)/(LL);
Tw_a = (Tw_sc*l_tp + Tw_tp*l_sc)/(l_sc +l_tp)
    "Wall Temperature at the border between subcooled and two-phase region";
Tw_b = (Tw_sh*l_tp + Tw_tp*l_sh)/(l_tp +l_sh)
    "Wall Temperature at the border between two-phase and superheated region";

 /*Secondary fluid */
   AU_sc_sf = 2*pi*rr*l_sc*U_sf;
   C_dot_sf = m_dot_sf*c_sf;
   NTU_sc_sf = AU_sc_sf/C_dot_sf;
   epsilon_sc_sf = 1 - exp(-NTU_sc_sf);
   Q_sc_sf = C_dot_sf*epsilon_sc_sf*(Tsf_a - Tw_sc);
   Tsf_sc = (Tsf_a+Tsf_ex)/2;
   Q_sc_sf = C_dot_sf*(Tsf_a - Tsf_ex);

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
  AA*(der(l_tp)*(rho_sv*VV + (1-VV)*rho_sl) + (l_tp)*((rho_sv - rho_sl)*DVVdt + VV*drdp_sv*der(p_wf) + (1-VV)*drdp_sl*der(p_wf))) + AA*rho_a*der(l_sc) - AA*rho_b*der(l_sc+l_tp)= m_dot_a - m_dot_b;

rho_b = rho_sv;
h_b = h_sv;
der_h_b =dhdp_sv*der(p_wf);

/* Energy Balance wf */
 AA*(der(l_tp)*(rho_sv*h_sv*VV +(1-VV)*rho_sl*h_sl) +
  l_tp*(DVVdt*(rho_sv*h_sv - rho_sl*h_sl) + VV*h_sv*drdp_sv*der(p_wf) + VV*rho_sv*dhdp_sv*der(p_wf) + (1-VV)*drdp_sl*der(p_wf)*h_sl + (1-VV)*rho_sl*dhdp_sl*der(p_wf)))
   +AA*rho_a*h_a*der(l_sc) - AA*l_tp*der(p_wf) - AA*rho_b*h_b*der(l_sc+l_tp)= m_dot_a*h_a - m_dot_b*h_b + Q_tp_wf;

/*Heat transfer wf */
AU_tp = 2*pi*rr*l_tp*U_tp;
C_dot_tp = ((m_dot_a+m_dot_b)*(Medium1.specificHeatCapacityCp(subCooled)+Medium1.specificHeatCapacityCp(superHeated)))/2;
NTU_tp = AU_tp/C_dot_tp;
epsilon_tp = 1-exp(-NTU_tp);
Q_tp_wf = epsilon_tp*C_dot_tp*(Tw_tp -T_tp);

/*Energy balance wall*/
 (c_w*M_w/LL)*(l_tp*der(Tw_tp) + (Tw_a - Tw_b)*der(l_sc) + (Tw_tp - Tw_b)*der(l_tp)) = Q_tp_sf - Q_tp_wf;

/*Secondary fluid */
AU_tp_sf = 2*pi*rr*l_tp*U_sf;
NTU_tp_sf = AU_tp_sf/C_dot_sf;
epsilon_tp_sf = 1 -exp(-NTU_tp_sf);
Q_tp_sf = C_dot_sf*epsilon_tp_sf*(Tsf_tp - Tw_tp);
Q_tp_sf = C_dot_sf*(Tsf_su - Tsf_a);
Tsf_tp = 1/2*(Tsf_b + Tsf_a);

/*** SUPER-HEATED REGION ***/
superHeated = Medium1.setState_ph(p_wf,h_sh);
h_sh = 1/2*(h_b+h_ex);
T_sh =  Medium1.temperature(superHeated);
rho_sh = Medium1.density(superHeated);
drdh_sh = Medium1.density_derh_p(superHeated);
drdp_sh = Medium1.density_derp_h(superHeated);

/*Mass balance wf*/
AA*(DrhoDt_sh*l_sh - rho_sh*der(l_sc +l_tp)) + AA*rho_b*der(l_sc+l_tp) = m_dot_b - m_dot_ex;
  DrhoDt_sh =  drdp_sh*der(p_wf) + 1/2*drdh_sh*(der(h_ex)+der_h_b);

/* Energy balance wf*/
  AA*(-rho_sh*h_sc*der(l_sc+l_tp) + h_sh*l_sc*DrhoDt_sh + rho_sh*l_sh*1/2*(der(h_ex)+der_h_b)) + AA*rho_b*h_b*der(l_sc+l_tp) - AA*l_sh*der(p_wf) = m_dot_b*h_b - m_dot_ex*h_ex + Q_sc_wf;

 /* Heat transfer wf */
  AU_sh = 2*pi*rr*l_sh*U_sh;
  C_dot_sh = (m_dot_b+m_dot_ex)/2*Medium1.specificHeatCapacityCp(superHeated);
  NTU_sh = AU_sh/C_dot_sh;
  epsilon_sh =  1 - exp(-NTU_sh);
  Q_sh_wf = C_dot_sh*epsilon_sh*(Tw_sh - T_sh);

/*******  WallEnergyBalance SUPER-HEATED **********/
(c_w*M_w/LL)*(l_sh*der(Tw_sh) + (Tw_b -Tw_sh)*(der(l_sc)+ der(l_tp)))= Q_sh_sf - Q_sh_wf;

 /*Secondary fluid */
   AU_sh_sf = 2*pi*rr*l_sh*U_sh;
   NTU_sh_sf = AU_sh_sf/C_dot_sf;
   epsilon_sh_sf = 1 - exp(-NTU_sh_sf);
   Q_sh_sf = C_dot_sf*epsilon_sh_sf*(Tsf_sh - Tw_sh);
   Tsf_sh = (Tsf_b+Tsf_su)/2;
   Q_sh_sf = C_dot_sf*(Tsf_su - Tsf_b);

/** OUTLET **/
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
/**********Specific Heat Capacity *************/
OutFlow_sf.cp = c_sf;
InFlow_sf.cp = c_sf;

/*********** Density ***********/
OutFlow_sf.rho = rho_sf;
InFlow_sf.rho = rho_sf;

Tsf_su =InFlow_sf.T;
Tsf_ex = OutFlow_sf.T;
InFlow_sf.Mdot = m_dot_sf;
m_dot_sf = OutFlow_sf.Mdot;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end MovingBoundary_NTU;
